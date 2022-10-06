#!/usr/bin/env python
# -*- coding: utf-8 -*-

# compression/onz.py

# Copyright 2010 Diego Hansen Hahn (aka DiegoHH) <diegohh90 [at] hotmail [dot] com>

# lazynds is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License.

# lazynds is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with lazynds. If not, see <http://www.gnu.org/licenses/>.

''' Formação do par LZ obtida no Puyo Tools (http://code.google.com/p/puyotools/) '''

import array
import os
import struct
import mmap

__author__ = "Diego Hansen Hahn"
__version__ = "v2.0.3"

def compress(infile):
    '''
    Recebe um arquivo de entrada (infile), comprime em lzss e retorna o resultado em um array de caracteres.
    '''
    def search(pattern, text):
        ''' Boyer-Moore-Horspool - Copyright Nelson Rush '''
        m = len(pattern)
        n = len(text)
        if m > n:
            return -1
        skip = []
        for k in range(256):
            skip.append(m)
        for k in range(m - 1):
            skip[ord(pattern[k])] = m - k - 1
        skip = tuple(skip)
        k = m - 1
        while k < n:
            j = m - 1
            i = k
            while j >= 0 and text[i] == pattern[j]:
                j -= 1
                i -= 1
            if j == -1:
                return (i + 3, m) # Distância, Tamanho
            k += skip[ord(text[k])]
        return -1

    def encode_buffer(buffer):

        flag = 0
        coded_buffer = array.array('c')

        for x in range(len(buffer)):
            if isinstance(buffer[x], tuple):
                data = ""
                if (buffer[x][1] <= 0xF + 1):
                    data += struct.pack('B', ((((buffer[x][1] - 1) & 0xF) << 4) | ((buffer[x][0] - 1) & 0xFFF) >> 8))
                    data += struct.pack('B', ((buffer[x][0] - 1) & 0xFF))
                elif (buffer[x][1] <= 0xFF + 17):
                    data += struct.pack('B', (((buffer[x][1] - 17) & 0xFF) >> 4))
                    data += struct.pack('B', ((((buffer[x][1] - 17) & 0xF) << 4) | (((buffer[x][0] - 1) & 0xFFF) >> 8)))
                    data += struct.pack('B', ((buffer[x][0] - 1) & 0xFF))
                else:
                    data += struct.pack('B', ((1 << 4) | (((buffer[x][1] - 273) & 0xFFFF) >> 12)))
                    data += struct.pack('B', (((buffer[x][1] - 273) & 0xFFF) >> 4))
                    data += struct.pack('B', ((((buffer[x][1] - 273) & 0xF) << 4) | (((buffer[x][0] - 1) & 0xFFF) >> 8)))
                    data += struct.pack('B', ((buffer[x][0] - 1) & 0xFF))
                coded_buffer.extend(data)
                flag |= (1 << 7 - x)
            else:
                coded_buffer.extend(buffer[x])
        coded_buffer.insert(0, chr(flag))
        return coded_buffer

    buffer = array.array('c')

    uncoded_lookahead = array.array('c')

    # Poderia ter usado o deque do collections para fazer a pilha (sliding_window).
    # mas, aparentemente, ficou mais lento usando ele...
    sliding_window = array.array('c')

    sliding_window_size = 0x1000
    max_search_size = 0xFFFF + 273

    to_code_buffer = []

    infile.seek(0,0)

    flag = 0x11
    if isinstance(infile, mmap.mmap):
	#size = infile.size()
	size = len(infile)
    else:
        size = os.path.getsize(infile.name)
    header = ((size << 8) | flag) & 0xFFFFFFFF
    buffer.extend(struct.pack('<L', header))
    # Inicia preenchendo sliding_window com 2 bytes
    for x in infile.read(2):
        sliding_window.insert(0, x)
        to_code_buffer.append(x)
    while True:
        pattern = infile.read(3)
        if len(pattern) != 3:
            for x in pattern:
                if len(to_code_buffer) == 8:
                    buffer.extend(encode_buffer(to_code_buffer))
                    to_code_buffer = []
                to_code_buffer.append(x)
            buffer.extend(encode_buffer(to_code_buffer))
            buffer.extend('\x00'*(len(buffer) % 4))
            return buffer
        for x in pattern:
            uncoded_lookahead.insert(0, x)
        #Adiciona o primeiro byte do padrão na janela deslizante
        sliding_window.insert(0, pattern[0])
        s_result = search(uncoded_lookahead, sliding_window)
        if s_result == -1: #Não foi achado o padrão na janela
            infile.seek(-2, 1)
            to_code_buffer.append(pattern[0])
            uncoded_lookahead = array.array('c')
        else: # Foi achado. Será buscado na janela um padrão maior (de até 18 bytes de tamanho)
            settings = None
            while True:
                c = infile.read(1)
                if not c: # Se não houver mais bytes, adiciona os parâmetros da busca anterior
                    to_code_buffer.append(s_result)
                    buffer.extend(encode_buffer(to_code_buffer))
                    buffer.extend('\x00'*(len(buffer) % 4))
                    return buffer
                uncoded_lookahead.insert(0, c)
                sliding_window.insert(0, uncoded_lookahead[2])
                settings = s_result # Guarda o resultado anterior em uma variável
                s_result = search(uncoded_lookahead, sliding_window)
                if s_result == -1:
                    infile.seek(-1, 1)
                    to_code_buffer.append(settings)
                    sliding_window.insert(0, uncoded_lookahead[1])
                    uncoded_lookahead = array.array('c')
                    break
                elif len(uncoded_lookahead) == max_search_size:
                    to_code_buffer.append(s_result)
                    sliding_window.insert(0, uncoded_lookahead[1])
                    sliding_window.insert(0, uncoded_lookahead[0])
                    uncoded_lookahead = array.array('c')
                    break

        while len(sliding_window) > sliding_window_size:
            sliding_window.pop()

        if len(to_code_buffer) == 8:
            buffer.extend(encode_buffer(to_code_buffer))
            to_code_buffer = []

def uncompress(infile, address):
    # Maior distância que pode percorrer: 0x1000 => 4096
    # Tamanhos máximos: 2 Bytes: 16
    #                   3 Bytes: 272
    #                   4 Bytes: 65808
    decoded_buffer = array.array('c')

    infile.seek(address, 0)
    header = struct.unpack('<L', infile.read(4))[0]
    flag = header & 0xFF
    size = header >> 8

    if flag != 0x11:
        return False

    while True:
        flag = struct.unpack('B', infile.read(1))[0]
        for x in range(8):
            if flag & 0x80:
                byte_1 = struct.unpack('B',infile.read(1))[0]
                case = byte_1 >> 4
                if case == 0:
                    byte_2 = struct.unpack('B',infile.read(1))[0]
                    byte_3 = struct.unpack('B',infile.read(1))[0]
                    lz_distance = (((byte_2 & 0xf) << 8) | byte_3) + 1
                    lz_size = (((byte_1 & 0xf) << 4) | (byte_2 >> 4)) + 17
                elif case == 1:
                    byte_2 = struct.unpack('B',infile.read(1))[0]
                    byte_3 = struct.unpack('B',infile.read(1))[0]
                    byte_4 = struct.unpack('B',infile.read(1))[0]
                    lz_distance = (((byte_3 & 0xf) << 8) | byte_4) + 1
                    lz_size = (((byte_1 & 0xf) << 12) | (byte_2 << 4) | (byte_3 >> 4)) + 273
                else:
                    byte_2 = struct.unpack('B',infile.read(1))[0]
                    lz_distance = (((byte_1 & 0xf) << 8) | byte_2) + 1
                    lz_size = (byte_1 >> 4) + 1
                for x in range(lz_size):
                    decoded_buffer.append(decoded_buffer[len(decoded_buffer) - lz_distance])
            else:
                decoded_buffer.append(infile.read(1))

            if len(decoded_buffer) >= size:
                while len(decoded_buffer) > size:
                    decoded_buffer.pop()
                return decoded_buffer
            flag <<= 1

def try_uncompress(file_map, offset, size):
     try:
         uncompressed_data_size = 0
         offset += 4
         while True:
             flag = struct.unpack('B', file_map[offset])[0]
             offset += 1
             for x in range(8):
                if flag & 0x80:
					byte_1 = struct.unpack('B',file_map[offset:offset+1])[0]
					case = byte_1 >> 4
					if case == 0:
						byte_2 = struct.unpack('B',file_map[offset+1:offset+2])[0]
						byte_3 = struct.unpack('B',file_map[offset+2:offset+3])[0]
						lz_distance = (((byte_2 & 0xf) << 8) | byte_3) + 1
						lz_size = (((byte_1 & 0xf) << 4) | (byte_2 >> 4)) + 17
						offset += 3
					elif case == 1:
						byte_2 = struct.unpack('B',file_map[offset+1:offset+2])[0]
						byte_3 = struct.unpack('B',file_map[offset+2:offset+3])[0]
						byte_4 = struct.unpack('B',file_map[offset+3:offset+4])[0]
						lz_distance = (((byte_3 & 0xf) << 8) | byte_4) + 1
						lz_size = (((byte_1 & 0xf) << 12) | (byte_2 << 4) | (byte_3 >> 4)) + 273
						offset += 4
					else:
						byte_2 = struct.unpack('B',file_map[offset+1:offset+2])[0]
						lz_distance = (((byte_1 & 0xf) << 8) | byte_2) + 1
						lz_size = (byte_1 >> 4) + 1
						offset += 2

					if lz_distance > uncompressed_data_size:
						return False
					uncompressed_data_size += lz_size
                else:
                     uncompressed_data_size += 1
                     offset += 1
                if uncompressed_data_size >= size:
                     return True
                flag <<= 1
     except IndexError:
         # Para o caso de chegar ao fim da rom durante o teste
         return False
