#!/usr/bin/env python
# -*- coding: windows-1252 -*-
'''
Created on 20/03/2018

@author: diego.hahn
'''

import sys
import os
import array
import struct

from pytable import normal_table
from rhCompression import lzss, rle, huffman

import argparse

__title__ = "MMBN2 Text Processor"
__version__ = "1.0"

def fnTagE7(fd , buffer):
    # End of Block
    buffer.extend( "<EB>\n!*********************!\n" )

def fnTagE8(fd , buffer):
    # Line Feed
    buffer.extend( "<LF>\n" )
    
def fnTagE9(fd , buffer):
    # Carriage Return
    buffer.extend( "<CR>\n!---------------------!\n" )
 
def fnTagEA(fd , buffer):
    # Button Iteraction
    args = list(struct.unpack("BBB", fd.read(3)))
    buffer.extend( "<0xEA: {0} {1} {2}>".format(*args) )   
 
def fnTagEB(fd , buffer):
    # Button Iteraction
    buffer.extend( "<Button>" )
    
def fnTagED(fd , buffer):
    args = struct.unpack("BB", fd.read(2))
    buffer.extend( "<Char: {0} {1}>".format(*args) )
    
def fnTagEE(fd , buffer):
    # Sets (X,Y) position, absolute or relative
    args = list(struct.unpack("B", fd.read(1)))
    if args[0] < 2:
        args += list(struct.unpack("B", fd.read(1)))
        buffer.extend( "<Pos: {0} {1}>".format(*args) )    
    else:
        args += list(struct.unpack("BB", fd.read(2)))
        buffer.extend( "<Pos: {0} {1} {2}>".format(*args) )   
        
def fnTagEF(fd , buffer):
    args = struct.unpack("BB", fd.read(2))
    buffer.extend( "<Arrow: {0} {1}>".format(*args) )

def fnTagF0(fd , buffer):    
    args = list(struct.unpack("BBBBB", fd.read(5)))
    buffer.extend( "<CondJmp: {0} {1} {2} {3} {4}>\n!---------------------!\n".format(*args) )   
        
def fnTagF1(fd , buffer):
    arg = ord(fd.read(1))
    buffer.extend( "<0xF1: {0}>".format(arg) )     
    
def fnTagF2(fd , buffer):
    args = list(struct.unpack("BBB", fd.read(3)))
    buffer.extend( "<0xF2: {0} {1} {2}>".format(*args) )        

def fnTagF3(fd , buffer):
    # ( 6, 6, 5, 6, 6, 6, 6, 6, 6, 6 )
    args = list(struct.unpack("B", fd.read(1)))
    # Apenas 8 tem 4 argumentos. Com outro valor, tem 5 argumentos.
    if args[0] == 8:
        args += list(struct.unpack("BBB", fd.read(3)))
        buffer.extend( "<0xF3: {0} {1} {2} {3}>".format(*args) )    
    else:
        args += list(struct.unpack("BBBB", fd.read(4)))
        buffer.extend( "<0xF3: {0} {1} {2} {3} {4}>".format(*args) )

def fnTagF5(fd , buffer):
    # Jumps to address pointed by pointer table arg index
    args = struct.unpack("BB", fd.read(2))
    buffer.extend( "<Jmp: {0} {1}>".format(*args) )  

# Valor binário : (Nome amigável, Argumentos)
tagsdict = { 0xE7 : ("EB", fnTagE7), 0xE8 : ("LF", fnTagE8), 0xE9 : ("CR", fnTagE9), 0xEA : ("0xEA", fnTagEA) ,
            0xEB : ("Button", fnTagEB) , 0xED : ("Char", fnTagED) , 0xEE : ("Pos", fnTagEE) , 0xEF : ("Arrow", fnTagEF),
            0xF0 : ("CondJmp", fnTagF0) , 0xF1 : ("0xF1", fnTagF1) , 0xF2 : ("0xF2", fnTagF2) , 0xF3 : ("0xF3", fnTagF3) ,
            0xF5 : ("Jmp", fnTagF5) }

#def Extract(src,dst):
def Extract():
    table = normal_table('mmbn2.tbl')

    with open("../teste.bin", "rb") as fd:
    
        # Bufferiza os ponteiros
        entries = struct.unpack("<H" , fd.read(2))[0]/ 2
        
        pointers = []
        fd.seek(0)
        for _ in range(entries):
            pointers.append(struct.unpack("<H", fd.read(2))[0])
        
        buffer = array.array("c")
        
        while True:            
            p  = fd.tell()
            if p in pointers:
                for j, ptr in enumerate( pointers ):
                    if p == ptr:
                        # Coloca labels no texto
                        buffer.extend( "<@PointerIdx%d>\n" % j )
                            
            b = fd.read(1)
            if len(b) == 0: break            
            
            c = struct.unpack("B", b)[0]            
            if c >= 0xE5: # É uma tag.. esse teste é o mesmo do jogo
                if c in tagsdict:
                    tagsdict[c][1](fd, buffer)                    
                        
                else:
                    buffer.extend( "<"+str(hex(c))+">" )                                
            else:            
                if b in table:
                    buffer.append( table[b] )
                else:
                    buffer.extend( "<"+str(hex(c))+">")
            
        teste = open("teste.txt", "w")
        buffer.tofile(teste)
        teste.close()
        
        
        
        
        
    

if __name__ == "__main__":
    import argparse
    
    os.chdir( sys.path[0] )
    os.system( 'cls' )

    print "{0:{fill}{align}70}".format( " {0} {1} ".format( __title__, __version__ ) , align = "^" , fill = "=" )
    
    Extract()

    # parser = argparse.ArgumentParser()
    # parser.add_argument( '-m', dest = "mode", type = str, required = True )
    # parser.add_argument( '-s', dest = "src", type = str, nargs = "?", required = True )
    # parser.add_argument( '-d', dest = "dst", type = str, nargs = "?", required = True )
    
    # args = parser.parse_args()    

    # # dump text
    # if args.mode == "e":
        # print "Desempacotando arquivo"
        # Extract( args.src , args.dst )
    # # insert text
    # elif args.mode == "i": 
        # print "Criando arquivo"
        # Insert( args.src , args.dst )
    # else:
        # sys.exit(1)
    