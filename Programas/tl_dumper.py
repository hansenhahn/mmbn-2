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

def reduce_args( args ):
    return reduce(lambda x,y: "{0} {1}".format(x,y), args)
    

def fnTagE7(fd , buffer, tagname):
    # End of Block
    buffer.extend( "<{0}>".format(tagname) )
    buffer.extend( "\n!*********************!\n" )

def fnTagE8(fd , buffer, tagname):
    # Line Feed
    buffer.extend( "<{0}>".format(tagname) )
    buffer.extend( "\n" )
    
def fnTagE9(fd , buffer, tagname):
    # Carriage Return
    buffer.extend( "<{0}>".format(tagname) )
    buffer.extend( "\n!---------------------!\n" )
 
def fnTagEA(fd , buffer, tagname):
    # Button Iteraction
    args = list(struct.unpack("3B", fd.read(3)))
    buffer.extend( "<{0}: {1}>".format(tagname, reduce_args(args)) ) 
 
def fnTagEB(fd , buffer, tagname):
    # Button Iteraction
    buffer.extend( "<{0}>".format(tagname) )
    
def fnTagEC(fd, buffer, tagname):
    args = struct.unpack("2B", fd.read(2))
    buffer.extend( "<{0}: {1}>".format(tagname, reduce_args(args)) )   
    
def fnTagED(fd , buffer, tagname):
    args = list(struct.unpack("B", fd.read(1)))
    if args[0] == 1:
        args += list(struct.unpack("2B", fd.read(2)))
    else:
        args += list(struct.unpack("B", fd.read(1)))
    buffer.extend( "<{0}: {1}>".format(tagname, reduce_args(args)) )             
    
def fnTagEE(fd , buffer, tagname):
    # Sets (X,Y) position, absolute or relative
    args = list(struct.unpack("B", fd.read(1)))
    if args[0] < 2:
        args += list(struct.unpack("B", fd.read(1)))
    else:
        args += list(struct.unpack("2B", fd.read(2)))
    buffer.extend( "<{0}: {1}>".format(tagname, reduce_args(args)) )           
        
def fnTagEF(fd , buffer, tagname):
    args = struct.unpack("2B", fd.read(2))
    buffer.extend( "<{0}: {1}>".format(tagname, reduce_args(args)) )   

def fnTagF0(fd , buffer, tagname):    
    args = struct.unpack("5B", fd.read(5))
    buffer.extend( "<{0}: {1}>".format(tagname, reduce_args(args)) )   
    buffer.extend( "\n!---------------------!\n" )   
        
def fnTagF1(fd , buffer, tagname):
    args = struct.unpack("B", fd.read(1))
    buffer.extend( "<{0}: {1}>".format(tagname, reduce_args(args)) )       
    
def fnTagF2(fd , buffer, tagname):
    args = list(struct.unpack("3B", fd.read(3)))
    buffer.extend( "<{0}: {1}>".format(tagname, reduce_args(args)) )       

def fnTagF3(fd , buffer, tagname):
    # Arg0 deve ser múltiplo de 4.
    # ( 6, 6, 5, 6, 6, 6, 6, 6, 6, 6 )
    args = list(struct.unpack("B", fd.read(1)))
    # Apenas Arg0 == 8 são 5 argumentos. Com outro valor, são 6 argumentos.
    if args[0] == 8:
        args += list(struct.unpack("3B", fd.read(3)))
    else:
        args += list(struct.unpack("4B", fd.read(4)))
    buffer.extend( "<{0}: {1}>".format(tagname, reduce_args(args)) )           
        
def fnTagF4(fd , buffer, tagname):
    args = struct.unpack("B", fd.read(1))
    buffer.extend( "<{0}: {1}>".format(tagname, reduce_args(args)) )   
    buffer.extend( "\n!+++++++++++++++++++++!\n" ) 

def fnTagF5(fd , buffer, tagname):
    # Jumps to address pointed by pointer table arg index
    args = struct.unpack("2B", fd.read(2))
    buffer.extend( "<{0}: {1}>".format(tagname, reduce_args(args)) )       

def fnTagF6(fd , buffer, tagname):
    # Jumps to address pointed by pointer table arg index
    # 10h (6), 20h (7), 30h (9)
    # (4, 4, 4, 7)
    args = list(struct.unpack("B", fd.read(1)))
    if (args[0] & 0xf0) == 0x10:
        if ( args[0] & 0x0f ) in ( 0x0, 0x1, 0x2 ):
            args += list(struct.unpack("4B", fd.read(4)))
        elif ( args[0] & 0x0f ) in ( 0x3, 0x4 ):
            args += list(struct.unpack("7B", fd.read(7)))
            
    elif (args[0] & 0xf0) == 0x20:
        if ( args[0] & 0x0f ) in ( 0x0, 0x1, 0x3 ):
            args += list(struct.unpack("5B", fd.read(5)))
        elif ( args[0] & 0x0f ) == 0x02 :
            args += list(struct.unpack("2B", fd.read(2)))
            
    elif (args[0] & 0xf0) == 0x30:
        if ( args[0] & 0x0f ) in ( 0x0, 0x1, 0x3 ):
            args += list(struct.unpack("7B", fd.read(7)))
        elif ( args[0] & 0x0f ) == 0x02 :
            args += list(struct.unpack("4B", fd.read(4)))    
            
    elif args[0] in (0x0,0x1,0x2):
        args += list(struct.unpack("2B", fd.read(2)))
        
    elif args[0] == 0x03:
        args += list(struct.unpack("5B", fd.read(5)))        
        
    buffer.extend( "<{0}: {1}>".format(tagname, reduce_args(args)) )           
    
def fnTagF8(fd , buffer, tagname):
    # Arg0 deve ser múltiplo de 4.
    # ( 2, 3, 2, 2, 2 )
    args = list(struct.unpack("B", fd.read(1)))
    # Apenas Arg0 == 4 são 3 argumentos. Com outro valor, são 2 argumentos.
    if args[0] == 4:
        args += list(struct.unpack("B", fd.read(1)))

    buffer.extend( "<{0}: {1}>".format(tagname, reduce_args(args)) )           
        
    
def fnTagF9(fd , buffer, tagname):
    # Aponta para um nome da tabela de items
    args = struct.unpack("BBB", fd.read(3))
    buffer.extend( "<{0}: {1}>".format(tagname, reduce_args(args)) )   

def fnTagFA(fd , buffer, tagname):
    # Aponta para um nome da tabela de items
    #( 4, 4, 2, 2, 2, 4, 4, 2, 2, 2 )
    args = list(struct.unpack("B", fd.read(1)))
    if args[0] in (0x0,0x4,0x14,0x18):
        args += list(struct.unpack("BB", fd.read(2)))
        
    buffer.extend( "<{0}: {1}>".format(tagname, reduce_args(args)) )    
        
# WIP        
def fnTagFB(fd , buffer, tagname):
    args = list(struct.unpack("B", fd.read(1)))
    if args[0] in ( 0x08, 0x10, 0x18, 
                      0x20, 0x24, 0x28, 0x2c,
                      0x30, 0x34, 0x38, 0x3c):
        pass
    elif args[0] in (0x00, 0x04,):
        args += list(struct.unpack("B", fd.read(1)))
        r = ((args[1] + 1) << 2) - 3
        args += list(struct.unpack(r*"B", fd.read(r)))        
    elif args[0] in (0x0c,):
        args += list(struct.unpack("9B", fd.read(9)))
    elif args[0] in (0x14, 0x1c,):    
        args += list(struct.unpack("B", fd.read(1)))
        
    buffer.extend( "<{0}: {1}>".format(tagname, reduce_args(args)) )   

        

# Valor binário : (Nome amigável, Argumentos)
tagsdict = { 0xE7 : ("EB", fnTagE7), 0xE8 : ("LF", fnTagE8), 0xE9 : ("CR", fnTagE9), 0xEA : ("Dly", fnTagEA) ,
            0xEB : ("Button", fnTagEB) , 0xEC : ("0xEC", fnTagEC), 0xED : ("Char", fnTagED) , 0xEE : ("Pos", fnTagEE) , 0xEF : ("Arrow", fnTagEF),
            0xF0 : ("CondJmp", fnTagF0) , 0xF1 : ("0xF1", fnTagF1) , 0xF2 : ("0xF2", fnTagF2) , 0xF3 : ("0xF3", fnTagF3) ,
            0xF4 : ("Rst", fnTagF4) ,  0xF5 : ("Jmp", fnTagF5) , 0xF6 : ("0xF6", fnTagF6) , 0xF8 : ("0xF8", fnTagF8) ,
            0xF9 : ("ItemTbl", fnTagF9) , 0xFA : ("0xFA", fnTagFA) , 0xFB : ("0xFB", fnTagFB) }
            
TAG_IN_LINE = r'(<.+?>)'
GET_TAG = r'^<(.+?)>$'

EOF = 0x800000
BASE_PTR = 0x800000  #0x77d71c  

def Insert_Main(src, dst):
    global BASE_PTR
    table = normal_table('mmbn2.tbl')    
    table.set_mode('inverted')
    
    files = filter(lambda x: x.__contains__('.txt'), scandirs(src))       
    # Cria o dicionário invertido de tags
    itagsdict = dict([[v[0],k] for k,v in tagsdict.items()])
   
    #base_ptr = 0x800000  
    print hex(BASE_PTR)
    dest = open(dst, 'r+b')
    dest.seek( BASE_PTR )
    
    pointer_old = []
    pointer_new = []
    
    for i, txtname in enumerate(files):
        print ">> Convertendo e comprimindo " + txtname 
        
        while dest.tell() % 4 != 0: dest.write("\x00")

        buffer = array.array("c")
        with open(txtname, 'rb') as fd:                       
            
            pointer_idx = []
        
            for j, line in enumerate(fd):
                #try:
                    line = line.strip('\r\n')
                    if not line:
                        continue
                    elif line in ( "!---------------------!","!+++++++++++++++++++++!","!*********************!" ):
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
                                    elif "AbsoluteAddr" in tag:
                                        t,c  = tag.split(" ") # Errei .. faltou o : na tag, para aproveitar o split mais acima
                                        pointer_old.append( struct.pack("<L", int(c) | 0x08000000) )
                                        pointer_new.append( struct.pack("<L", dest.tell() | 0x08000000) )
                                    else:
                                        print "Line {0} Label {1}".format(j, tag)
                                        raise Exception()
                                else:                                                                    
                                    if tag in itagsdict:
                                        buffer.extend( struct.pack("B", itagsdict[tag]) )
                                        for arg in argv:
                                            buffer.extend( struct.pack("B", int(arg)) )                            
                                    else:
                                        buffer.extend( struct.pack("B", int(tag,16)) )                                        
                # except:
                    # print "<< Error"
                    # sys.exit()
                    
            size = len(pointer_idx) * 2 + len(buffer)
            offset = len(pointer_idx) * 2
            for ptr in pointer_idx:
                dest.write( struct.pack("<H", offset+ptr) )
            dest.write(buffer.tostring())
            
            b,name = os.path.split( txtname )
            i, j = name.replace(".txt", "").split("_")          
     
    BASE_PTR = dest.tell()

    print ">> Updating pointer table..."    
    dest.seek( 0 )
    while dest.tell() < 0x800000:
        ptr = dest.read(4)
        if ptr in pointer_old:
            idx = pointer_old.index(ptr)
            dest.seek(-4,1)
            print ">> Updated %s to %s [%s]" % ( hex(struct.unpack("<L",ptr)[0]) , hex(struct.unpack("<L",pointer_new[idx])[0]) , hex( dest.tell()) )            
            dest.write( pointer_new[pointer_old.index(ptr)])

    dest.close()        

def Insert_NPC(src, dst):
    global BASE_PTR
    table = normal_table('mmbn2.tbl')    
    table.set_mode('inverted')
    
    files = filter(lambda x: x.__contains__('.txt'), scandirs(src))       
    # Cria o dicionário invertido de tags
    itagsdict = dict([[v[0],k] for k,v in tagsdict.items()])
   
    print hex(BASE_PTR)
    dest = open(dst, 'r+b')
    dest.seek( BASE_PTR )
    
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
                    elif line in ( "!---------------------!","!+++++++++++++++++++++!","!*********************!" ):
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
            

    BASE_PTR = dest.tell()
            
    print ">> Updating pointer table..."    
    for desc in pointer_files:
        dest.seek( 0x228a8 + 4*desc[1] )
        dest.write( struct.pack("<L", desc[2] | 0x08000000) )

    dest.close()                     
                 
def Extract_Main(src, dst):
    table = normal_table('mmbn2.tbl')
    
    main_pointers = [(0x77d71c, 0x79cb18),]  
    
    with open(src, "rb") as fd:

        # Não preciso disso aqui na verdade...
        # main_pointers = []
        # fd.seek( 0x2282c )
        # print ">> Buffering pointer to pointers..."
        # while fd.tell() < 0x228a8 :
            # main_pointers.append(struct.unpack("<L", fd.read(4))[0] & 0xFFFFFF)
        
        for i, pp in enumerate(main_pointers):
            text_pointers = []
            fd.seek( pp[0] )
            print ">> Buffering pointer to text..."
            
            ret = fd.read(pp[1]-pp[0])
            data = mmap.mmap( -1, len(ret) )
            data.write(ret)
            
            data.seek(0)
            j = 0
            while True:        
                # Bufferiza os ponteiros
                while data.tell() % 4 != 0: data.read(1)
                
                offset = data.tell()
                entries = data.read(2)
                if len(entries) == 0: break
                
                print ">> Extracting {0} {1} text".format(i,j)
                entries = struct.unpack("<H" , entries)[0]/ 2
                
                pointers = []
                data.seek(-2,1)
                for _ in range(entries):
                    pointers.append(struct.unpack("<H", data.read(2))[0])
                
                buffer = array.array("c")
                buffer.extend( "<@AbsoluteAddr %d>\n" % (pp[0]+offset) )  
                
                new_eb = True
                while True:            
                    p = data.tell() - offset
                    if p in pointers:
                        for k, ptr in enumerate( pointers ):
                            if p == ptr:
                                # Coloca labels no texto
                                buffer.extend( "<@PointerIdx%d>\n" % k )                                
                        
                    b = data.read(1)
                    if len(b) == 0: break            
                    
                    c = struct.unpack("B", b)[0]
                    # Após a tag 0xE7, sempre devemos ler uma nova tag. Se não, podemos dizer que o bloco de leitura acabou
                    if new_eb:
                        if c < 0xE5:
                            data.seek(-1,1)
                            break
                            
                    new_eb = False
                    
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
                            
                    if c == 0xE7:
                        new_eb = True
                                                
                output = open(os.path.join(dst, "%03d_%03d.txt" %(i,j)), "w")
                buffer.tofile(output)
                output.close()
                
                j += 1
                
            data.close()            
            
#def Extract(src,dst):
def Extract_NPC(src, dst):
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
    
    # Extract_NPC("../ROM Original/0468 - MegaMan Battle Network 2 (U)(Mode7).gba" , "../Textos Originais/npc")
    # Extract_Main("../ROM Original/0468 - MegaMan Battle Network 2 (U)(Mode7).gba" , "../Textos Originais/main")      

    print "{0:{fill}{align}70}".format( " {0} {1} ".format( __title__, __version__ ) , align = "^" , fill = "=" )

    parser = argparse.ArgumentParser()
    parser.add_argument( '-m', dest = "mode", type = str, required = True )
    parser.add_argument( '-s', dest = "src", type = str, nargs = "?", required = True )
    parser.add_argument( '-d', dest = "dst", type = str, nargs = "?", required = True )
    
    args = parser.parse_args()    

    # # dump text
    if args.mode == "e":
        print "Desempacotando arquivo"
        Extract_NPC( args.src , os.path.join(args.dst , "npc" ))
        Extract_Main( args.src , os.path.join(args.dst , "main" ) )
        # Extract_NPC("../ROM Modificada/0468 - MegaMan Battle Network 2 (U)(Mode7).gba" , "../Textos Originais2/npc")
        # Extract_Main("../ROM Modificada/0468 - MegaMan Battle Network 2 (U)(Mode7).gba" , "../Textos Originais2/main")
        # Extract_NPC("../ROM Original/0468 - MegaMan Battle Network 2 (U)(Mode7).gba" , "../Textos Originais/npc")
        # Extract_Main("../ROM Original/0468 - MegaMan Battle Network 2 (U)(Mode7).gba" , "../Textos Originais/main")    
    # # insert text
    elif args.mode == "i": 
        print "Criando arquivo"        
        Insert_NPC( os.path.join(args.src , "npc" ) , args.dst )
        Insert_Main( os.path.join(args.src , "main" ) , args.dst )
        # Insert_NPC("../Textos Traduzidos/npc", "../ROM Modificada/0468 - MegaMan Battle Network 2 (U)(Mode7).gba") 
        # Insert_Main("../Textos Traduzidos/main", "../ROM Modificada/0468 - MegaMan Battle Network 2 (U)(Mode7).gba") 
    else:
        sys.exit(1)
    