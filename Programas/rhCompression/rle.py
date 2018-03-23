#!/usr/bin/env python
# -*- coding: utf-8 -*-

# compression/rle.py

# Copyright 2009-2010 Diego Hansen Hahn (aka DiegoHH) <diegohh90 [at] hotmail [dot] com>

# lazynds is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License.

# lazynds is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with lazynds. If not, see <http://www.gnu.org/licenses/>.

'''
	Compressão RLE

  r0  Source Address, pointing to data as such:
       Data header (32bit)
         Bit 0-3   Reserved
         Bit 4-7   Compressed type (must be 3 for run-length)
         Bit 8-31  Size of decompressed data
       Repeat below. Each Flag Byte followed by one or more Data Bytes.
       Flag data (8bit)
         Bit 0-6   Expanded Data Length (uncompressed N-1, compressed N-3)
         Bit 7     Flag (0=uncompressed, 1=compressed)
       Data Byte(s) - N uncompressed bytes, or 1 byte repeated N times
  r1  Destination Address
  r2  Callback parameter (NDS SWI 15h only, see Callback notes below)
  r3  Callback structure (NDS SWI 15h only, see Callback notes below)
  Fonte: GBATek
'''

import array
import os
import struct

__author__ = "Diego Hansen Hahn"
__version__ = "v2.0.2"

def compress(infile):
	'''
	Recebe um arquivo de entrada (infile), comprime em rle e retorna o resultado em um array de caracteres
	ou retorna False caso tenha dado algum erro.

	Buffers:
		mode_0_buffer:  buffer-string para caracteres não-repetidos
		mode_1_buffer:  buffer-string para caracteres repetidos
	'''
	def encode_buffer(buffer, mode):
		buff = array.array('c')
		if mode == 0:
			flag = len(buffer) - 1
			buff.extend(struct.pack('B',flag))
			buff.extend(buffer)
		else:
			flag = (1 << 7) | (len(buffer) - 3)
			buff.extend(struct.pack('B',flag))
			buff.extend(buffer[0])
		return buff

	buffer = array.array('c')

	mode_0_buffer = ''
	mode_1_buffer = ''

	infile.seek(0,0)

	flag = 0x30
	size = os.path.getsize(infile.name)
	header = ((size << 8) | flag) & 0xFFFFFFFF
	buffer.extend(struct.pack('<L', header))
	while True:
		pattern = infile.read(3)
		if len(pattern) != 3:
			mode_0_buffer += pattern
			if mode_0_buffer:
				buffer.extend(encode_buffer(mode_0_buffer, 0))
			buffer.extend('\x00'*(len(buffer) % 4))
			return buffer
		else:
			if all([bool(pattern.startswith(x)) for x in pattern]):
				if mode_0_buffer:
					buffer.extend(encode_buffer(mode_0_buffer, 0))
					mode_0_buffer = ''
				mode_1_buffer += pattern
				while (len(mode_1_buffer) - 3) < 0x7F:
					byte = infile.read(1)
					if not byte:
						break
					elif mode_1_buffer.endswith(byte):
						mode_1_buffer += byte
					else:
						infile.seek(-1, 1)
						break
				buffer.extend(encode_buffer(mode_1_buffer, 1))
				mode_1_buffer = ''
			else:
				infile.seek(-3, 1)
				mode_0_buffer += infile.read(1)
				if (len(mode_0_buffer) - 1) == 0x7F:
					buffer.extend(encode_buffer(mode_0_buffer, 0))
					mode_0_buffer = ''

def uncompress(infile, address):
	decoded_buffer = array.array('c')

	infile.seek(address, 0)
	header = struct.unpack('<L', infile.read(4))[0]
	flag = header & 0xFF
	size = header >> 8

	if flag != 0x30:
		return False

	while True:
		flag = struct.unpack('B', infile.read(1))[0]
		mode = (flag >> 7) & 1
		lenght = flag & 0x7F
		if mode == 0:
			decoded_buffer.extend( infile.read(lenght + 1) )
		else:
			decoded_buffer.extend( (lenght + 3) * infile.read(1) )

		if len(decoded_buffer) >= size:
			while len(decoded_buffer) > size:
				decoded_buffer.pop()
			return decoded_buffer

def try_uncompress(file_map, offset, size):
	try:
		uncompressed_data_size = 0
		offset += 4
		while uncompressed_data_size < size:
			flag = struct.unpack('B', file_map[offset])[0]
			mode = (flag >> 7) & 1
			lenght = flag & 0x7F
			if mode == 0:
				uncompressed_data_size += (lenght + 1)
				offset += (lenght + 1)
			else:
				uncompressed_data_size += (lenght + 3)
				offset += 1
		return True
	except IndexError:
		# Para o caso de chegar ao fim da rom durante o teste
		return False