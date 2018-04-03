#!/usr/bin/env python
# -*- coding: windows-1252 -*-
'''
Created on 20/03/2018

@author: diego.hahn
'''

import re
import sys
import os
import array
import struct
import glob
import mmap

from pytable import normal_table
from rhCompression import lzss, rle, huffman

import argparse

__title__ = "MMBN2 Text Processor"
__version__ = "1.0"

def scandirs(path):
    files = []
    for currentFile in glob.glob( os.path.join(path, '*') ):
        if os.path.isdir(currentFile):
            files += scandirs(currentFile)
        else:
            files.append(currentFile)
    return files          

def fnTagE7(fd , buffer, tagname):
    # End of Block
    buffer.extend( "<{0}>\n!*********************!\n".format(tagname) )

def fnTagE8(fd , buffer, tagname):
    # Line Feed
    buffer.extend( "<{0}>\n".format(tagname) )
    
def fnTagE9(fd , buffer, tagname):
    # Carriage Return
    buffer.extend( "<{0}>\n!---------------------!\n".format(tagname) )
 
def fnTagEA(fd , buffer, tagname):
    # Button Iteraction
    args = list(struct.unpack("3B", fd.read(3)))
    buffer.extend( "<{0}: {1} {2} {3}>".format(tagname, *args) )   
 
def fnTagEB(fd , buffer, tagname):
    # Button Iteraction
    buffer.extend( "<Button>" )
    
def fnTagED(fd , buffer, tagname):
    args = struct.unpack("2B", fd.read(2))
    buffer.extend( "<Char: {0} {1}>".format(*args) )
    
def fnTagEE(fd , buffer, tagname):
    # Sets (X,Y) position, absolute or relative
    args = list(struct.unpack("B", fd.read(1)))
    if args[0] < 2:
        args += list(struct.unpack("B", fd.read(1)))
        buffer.extend( "<Pos: {0} {1}>".format(*args) )    
    else:
        args += list(struct.unpack("2B", fd.read(2)))
        buffer.extend( "<Pos: {0} {1} {2}>".format(*args) )   
        
def fnTagEF(fd , buffer, tagname):
    args = struct.unpack("BB", fd.read(2))
    buffer.extend( "<Arrow: {0} {1}>".format(*args) )

def fnTagF0(fd , buffer, tagname):    
    args = list(struct.unpack("5B", fd.read(5)))
    buffer.extend( "<CondJmp: {0} {1} {2} {3} {4}>\n!---------------------!\n".format(*args) )   
        
def fnTagF1(fd , buffer, tagname):
    arg = ord(fd.read(1))
    buffer.extend( "<0xF1: {0}>".format(arg) )     
    
def fnTagF2(fd , buffer, tagname):
    args = list(struct.unpack("3B", fd.read(3)))
    buffer.extend( "<0xF2: {0} {1} {2}>".format(*args) )        

def fnTagF3(fd , buffer, tagname):
    # Arg0 deve ser múltiplo de 4.
    # ( 6, 6, 5, 6, 6, 6, 6, 6, 6, 6 )
    args = list(struct.unpack("B", fd.read(1)))
    # Apenas Arg0 == 8 são 5 argumentos. Com outro valor, são 6 argumentos.
    if args[0] == 8:
        args += list(struct.unpack("3B", fd.read(3)))
        buffer.extend( "<0xF3: {0} {1} {2} {3}>".format(*args) )    
    else:
        args += list(struct.unpack("4B", fd.read(4)))
        buffer.extend( "<0xF3: {0} {1} {2} {3} {4}>".format(*args) )

def fnTagF5(fd , buffer, tagname):
    # Jumps to address pointed by pointer table arg index
    args = struct.unpack("BB", fd.read(2))
    buffer.extend( "<Jmp: {0} {1}>".format(*args) ) 

def fnTagF6(fd , buffer, tagname):
    # Jumps to address pointed by pointer table arg index
    # 10h (6), 20h (7), 30h (9)
    # (4, 4, 4, 7)
    args = list(struct.unpack("B", fd.read(1)))
    if args[0] == 0x10:
        args += list(struct.unpack("4B", fd.read(4)))
        buffer.extend( "<{0}: {1} {2} {3} {4} {5}>".format(tagname, *args) )
    elif args[0] == 0x20 or args[0] == 0x3:
        args += list(struct.unpack("5B", fd.read(5)))
        buffer.extend( "<{0}: {1} {2} {3} {4} {5} {6}>".format(tagname, *args) )
    elif args[0] == 0x30:
        args += list(struct.unpack("7B", fd.read(7)))
        buffer.extend( "<{0}: {1} {2} {3} {4} {5} {6} {7} {8}>".format(tagname, *args) )        
    elif args[0] in (0x0,0x1,0x2):
        args += list(struct.unpack("BB", fd.read(2)))
        buffer.extend( "<{0}: {1} {2} {3}>".format(tagname, *args) ) 
    
def fnTagF8(fd , buffer, tagname):
    # Arg0 deve ser múltiplo de 4.
    # ( 2, 3, 2, 2, 2 )
    args = list(struct.unpack("B", fd.read(1)))
    # Apenas Arg0 == 4 são 3 argumentos. Com outro valor, são 2 argumentos.
    if args[0] == 4:
        args += list(struct.unpack("B", fd.read(1)))
        buffer.extend( "<{0}: {1} {2}>".format(tagname, *args) )    
    else:
        buffer.extend( "<{0}: {1}>".format(tagname, *args) )  
        
    
def fnTagF9(fd , buffer, tagname):
    # Aponta para um nome da tabela de items
    args = struct.unpack("BBB", fd.read(3))
    buffer.extend( "<{0}: {1} {2} {3}>".format(tagname, *args) )      

def fnTagFA(fd , buffer, tagname):
    # Aponta para um nome da tabela de items
    #( 4, 4, 2, 2, 2, 4, 4, 2, 2, 2 )
    args = list(struct.unpack("B", fd.read(1)))
    if args[0] in (0x0,0x4,0x14,0x18):
        args += list(struct.unpack("BB", fd.read(2)))
        buffer.extend( "<{0}: {1} {2} {3}>".format(tagname, *args) )    
    else:
        buffer.extend( "<{0}: {1}>".format(tagname, *args) )  
        

# Valor binário : (Nome amigável, Argumentos)
tagsdict = { 0xE7 : ("EB", fnTagE7), 0xE8 : ("LF", fnTagE8), 0xE9 : ("CR", fnTagE9), 0xEA : ("0xEA", fnTagEA) ,
            0xEB : ("Button", fnTagEB) , 0xED : ("Char", fnTagED) , 0xEE : ("Pos", fnTagEE) , 0xEF : ("Arrow", fnTagEF),
            0xF0 : ("CondJmp", fnTagF0) , 0xF1 : ("0xF1", fnTagF1) , 0xF2 : ("0xF2", fnTagF2) , 0xF3 : ("0xF3", fnTagF3) ,
            0xF5 : ("Jmp", fnTagF5) , 0xF6 : ("0xF6", fnTagF6) , 0xF8 : ("0xF8", fnTagF8) , 0xF9 : ("ItemTbl", fnTagF9) ,
            0xFA : ("0xFA", fnTagFA) ,}
            
TAG_IN_LINE = r'(<.+?>)'
GET_TAG = r'^<(.+?)>$'

def Inserter(src, dst):
    table = normal_table('mmbn2.tbl')    
    table.set_mode('inverted')
    
    files = filter(lambda x: x.__contains__('.txt'), scandirs(src))       
    # Cria o dicionário invertido de tags
    itagsdict = dict([[v[0],k] for k,v in tagsdict.items()])
   
    base_ptr = 0x800000   
    dest = open(dst, 'r+b')
    dest.seek( base_ptr )
    
    pointer_files = []
    
    for i, txtname in enumerate(files):
        print ">> Convertendo e comprimindo " + txtname 

        buffer = array.array("c")
        with open(txtname, 'rb') as fd:
            
            pointer_idx = []
        
            for j, line in enumerate(fd):
                try:
                    line = line.strip('\r\n')
                    if not line:
                        continue
                    elif line in ( "!---------------------!", "!*********************!" ):
                        continue
                    else:
                        splitted = re.split( TAG_IN_LINE, line )
                        for string in splitted:
                            tag = re.match( GET_TAG, string )
                            # Se não for uma tag, é texto plano
                            if not tag:                            
                                for char in string:
                                    try:
                                        buffer.extend( table[char] )
                                    except:
                                        print "Line {0} Char {1}".format(j, ord(char))
                                        raise Exception()
                            # Se for uma tag
                            else:
                                tag = tag.groups()[0]
                                argv = []
                                # Tag com argumentos
                                if ": " in tag:
                                    tag,argv = tag.split(": ")
                                    argv = argv.split(" ")
                                    
                                if tag.startswith("@"): # São labels
                                    if "PointerIdx" in tag:
                                        pointer_idx.append( len(buffer) )
                                    else:
                                        print "Line {0} Label {1}".format(j, tag)
                                        raise Exception()
                                else:                                                                    
                                    if tag in itagsdict:
                                        buffer.extend( struct.pack("B", itagsdict[tag]) )
                                        for arg in argv:
                                            buffer.extend( struct.pack("B", int(arg)) )                            
                                    else:
                                        buffer.extend( struct.pack("B", int(tag)) )                                        
                except:
                    print "<< Error"
                    sys.exit()
                    
            size = len(pointer_idx) * 2 + len(buffer)
            temp = mmap.mmap(-1, size)
            offset = len(pointer_idx) * 2
            for ptr in pointer_idx:
                temp.write( struct.pack("<H", offset+ptr) )
            temp.write(buffer.tostring())
            
            ret = lzss.compress(temp) 
            temp.close()
            
            b,name = os.path.split( txtname )
            i, j = name.replace(".txt", "").split("_")

            pointer_files.append( [int(i), int(j), dest.tell()] )            
            ret.tofile(dest)
            

    print ">> Updating pointer table..."    
    for desc in pointer_files:
        dest.seek( 0x228a8 + 4*desc[1] )
        dest.write( struct.pack("<L", desc[2] | 0x08000000) )

    dest.close()
            
#def Extract(src,dst):
def Extract(src, dst):
    table = normal_table('mmbn2.tbl')
    
    with open(src, "rb") as fd:

        # Não preciso disso aqui na verdade...
        # main_pointers = []
        # fd.seek( 0x2282c )
        # print ">> Buffering pointer to pointers..."
        # while fd.tell() < 0x228a8 :
            # main_pointers.append(struct.unpack("<L", fd.read(4))[0] & 0xFFFFFF)
            
        text_pointers = []
        fd.seek( 0x228a8 )
        print ">> Buffering pointer to text..."
        while fd.tell() < 0x22b34 :
            text_pointers.append(struct.unpack("<L", fd.read(4))[0] & 0xFFFFFF)        
        
        i = 0
        for j, pointer_2 in enumerate(text_pointers):
            if pointer_2 == 0:
                continue
        
            print ">> Extracting {0} {1} text".format(i,j)
            ret = lzss.uncompress( fd, pointer_2 )
            
            data = mmap.mmap( -1, len(ret) )
            data.write(ret)
            data.seek(0)
    
            # Bufferiza os ponteiros
            entries = struct.unpack("<H" , data.read(2))[0]/ 2
            
            pointers = []
            data.seek(0)
            for _ in range(entries):
                pointers.append(struct.unpack("<H", data.read(2))[0])
            
            buffer = array.array("c")
            
            while True:            
                p  = data.tell()
                if p in pointers:
                    for k, ptr in enumerate( pointers ):
                        if p == ptr:
                            # Coloca labels no texto
                            buffer.extend( "<@PointerIdx%d>\n" % k )
                                
                b = data.read(1)
                if len(b) == 0: break            
                
                c = struct.unpack("B", b)[0]            
                if c >= 0xE5: # É uma tag.. esse teste é o mesmo do jogo
                    if c in tagsdict:
                        tagsdict[c][1](data, buffer, tagsdict[c][0])                                            
                    else:
                        buffer.extend( "<"+str(hex(c))+">" )                                
                else:            
                    if b in table:
                        buffer.append( table[b] )
                    else:
                        buffer.extend( "<"+str(hex(c))+">")
                        
            data.close()
                
            output = open(os.path.join(dst, "%03d_%03d.txt" %(i,j)), "w")
            buffer.tofile(output)
            output.close()
            
if __name__ == "__main__":
    import argparse
    
    os.chdir( sys.path[0] )
    os.system( 'cls' )

    print "{0:{fill}{align}70}".format( " {0} {1} ".format( __title__, __version__ ) , align = "^" , fill = "=" )
    


    # parser = argparse.ArgumentParser()
    # parser.add_argument( '-m', dest = "mode", type = str, required = True )
    # parser.add_argument( '-s', dest = "src", type = str, nargs = "?", required = True )
    # parser.add_argument( '-d', dest = "dst", type = str, nargs = "?", required = True )
    
    # args = parser.parse_args()    

    # # dump text
    # if args.mode == "e":
        # print "Desempacotando arquivo"
        # Extract( args.src , args.dst )
    # Extract("../ROM Original/0468 - MegaMan Battle Network 2 (U)(Mode7).gba" , "../Textos Originais")
    # # insert text
    # elif args.mode == "i": 
        # print "Criando arquivo"        
        # Insert( args.src , args.dst )
    Inserter("../Textos Traduzidos", "../ROM Modificada/0468 - MegaMan Battle Network 2 (U)(Mode7).gba") 
    # else:
        # sys.exit(1)
    