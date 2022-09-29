#!/usr/bin/env python
# -*- coding: utf-8 -*-

# compression/huffman.py

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
	Compressão Huffman

  r0  Source Address, aligned by 4, pointing to:
	   Data Header (32bit)
		 Bit0-3   Data size in bit units (normally 4 or 8)
		 Bit4-7   Compressed type (must be 2 for Huffman)
		 Bit8-31  24bit size of decompressed data in bytes
	   Tree Size (8bit)
		 Bit0-7   Size of Tree Table/2-1 (ie. Offset to Compressed Bitstream)
	   Tree Table (list of 8bit nodes, starting with the root node)
		Root Node and Non-Data-Child Nodes are:
		 Bit0-5   Offset to next child node,
				  Next child node0 is at (CurrentAddr AND NOT 1)+Offset*2+2
				  Next child node1 is at (CurrentAddr AND NOT 1)+Offset*2+2+1
		 Bit6	 Node1 End Flag (1=Next child node is data)
		 Bit7	 Node0 End Flag (1=Next child node is data)
		Data nodes are (when End Flag was set in parent node):
		 Bit0-7   Data (upper bits should be zero if Data Size is less than 8)
	   Compressed Bitstream (stored in units of 32bits)
		 Bit0-31  Node Bits (Bit31=First Bit)  (0=Node0, 1=Node1)
  r1  Destination Address
  r2  Callback parameter (NDS SWI 13h only, see Callback notes below)
  r3  Callback structure (NDS SWI 13h only, see Callback notes below)
  Fonte: GBATek
'''

import array
import os
import struct

import collections
import heapq

__author__ = "Diego Hansen Hahn"
__version__ = "v2.0.2"

def compress(infile, bitdepth):
	def codeIt(codes, s, node):
		''' Varre os ramos da árvore gerando a codificação de cada folha '''
		if isinstance(node, tuple):
			codes = codeIt(codes, s+'0', node[0])
			codes = codeIt(codes, s+'1', node[1])
		else:
			if not s:
				codes[node] = '0'
			else:
				codes[node] = s
		return codes

	def codeTable(huff, node, i):
		''' Codifica a árvore pelas especificações da rotina original '''
		child_nodes = []
		# Gera a lista de nós filhos.
		for child in node:
			if isinstance(child[0], tuple):
				child_nodes.append(child[0])
			if isinstance(child[1], tuple):
				child_nodes.append(child[1])
		for x in range(len(node)):
			child = node[x]
			if isinstance(child[0], tuple):
				child_node = 0
				if isinstance(child[0][0], str):
					child_node |= 0x80
				if isinstance(child[0][1], str):
					child_node |= 0x40
				child_node |= i
				huff.append(child_node)
			else:
				huff.append(ord(child[0]))
				i -= 1
			if isinstance(child[1], tuple):
				child_node = 0
				if isinstance(child[1][0], str):
					child_node |= 0x80
				if isinstance(child[1][1], str):
					child_node |= 0x40
				child_node |= (i + 1)
				huff.append(child_node)
			else:
				huff.append(ord(child[1]))
				i -= 1
			i += 1
		if child_nodes:
			huff = codeTable(huff, child_nodes, i)
		else:
			return huff
		return huff

	buffer = array.array('c')

	infile.seek(0,0)

	flag = 0x20 | bitdepth
	size = os.path.getsize(infile.name)
	header = ((size << 8) | flag) & 0xFFFFFFFF
	buffer.extend(struct.pack('<L', header))

	fd_buffer = infile.read()
	frequency_dict = collections.defaultdict(int)
	# Gera o dicionário de frequências
	# Para bitdepth = 4, separar o byte em 2 nibbles
	for x in fd_buffer:
		if bitdepth == 4:
			frequency_dict[chr(ord(x) & 0xF)] += 1
			frequency_dict[chr((ord(x) >> 4) & 0xF)] += 1
		else:
			frequency_dict[x] += 1
	# Cria uma lista com prioridades, onde letras com menor frequência vem primeiro.
	pairs = [(v,k) for (k,v) in frequency_dict.iteritems()]
	heapq.heapify(pairs)
	# Hora de montar a árvore
	while len(pairs) > 1:
		# Monta a árvore huffman
		# child0 e child1 são os filhos com menor frequência no queue.
		# node é o nó pai de child0 e child1. A nova frequência é a soma das frequências dos filhos.
		child1 = heapq.heappop(pairs)
		child0 = heapq.heappop(pairs)
		node = (child0[0]+child1[0],(child0[1],child1[1]))
		heapq.heappush(pairs, node)
	# Árvore criada, gero a tabela de códigos e adiciono o root_node na tabela huffman.
	huff_codes = codeIt({}, '', pairs[0][1])

	huff_tbl = array.array('B')
	root_node = 0
	if isinstance(pairs[0][1][0], str):
		root_node |= 0x80
	if isinstance(pairs[0][1][1], str):
		root_node |= 0x40
	huff_tbl.append(root_node)
	huff_tbl = codeTable(huff_tbl, [pairs[0][1]], 0)

	# Gerando o tamanho de árvore. Ela deve ter tamanho múltiplo de 4. Se não tiver, completar com 00h
	# PS: Somar 1 porque o byte de tamanho também conta
	while (len(huff_tbl) + 1) % 4 != 0:
		huff_tbl.append(00)
	huff_tbl.insert(0, ((len(huff_tbl) + 1)/2 - 1))
	# Adicionando ao buffer de saída...
	buffer.extend(huff_tbl.tostring())
	# Tabela gerada. Agora só resta codificar o arquivo.
	word = 0
	bitcount = 32
	for x in fd_buffer:
		if bitdepth == 4:
			code = (huff_codes[chr(ord(x)&0xf)] + huff_codes[chr(ord(x)>>4 & 0xf)])
		else:
			code = huff_codes[x]
		while True:
			while bitcount and code:
				word <<= 1
				word |= int(code[0])
				bitcount -= 1
				code = code[1:]
			if not bitcount: # Gerou uma palavra / 32 bits
				buffer.extend(struct.pack('<L', word))
				word = 0
				bitcount = 32
			elif not code: # A codificação foi copiada para a palavra. Hora de carregar outra codificação
				break
	# Verifica se ainda há bytes a serem copiados...
	if word:
		while bitcount:
			word <<= 1
			bitcount -= 1
		buffer.extend(struct.pack('<L', word))

	if (len(buffer) % 4) != 0:
		buffer.extend('\x00' * (len(buffer) % 4))

	return buffer

def uncompress(infile, address):
	decoded_buffer = array.array('c')

	infile.seek(address, 0)
	header = struct.unpack('<L', infile.read(4))[0]
	flag = header & 0xFF
	size = header >> 8

	if (flag & 0xF0) != 0x20:
		return False
	# Tamanho da árvore
	tree_size = (struct.unpack('B', infile.read(1))[0] + 1) * 2
	# Monta a árvore
	huffman_tree = [struct.unpack('B', x)[0] for x in infile.read(tree_size - 1)] # Descontar o byte tree size
	# A partir de agora, os bytes são os dados comprimidos
	root_node = huffman_tree[0]

	# Flags
	write_data = False
	word = 0
	bitshift = 0
	bitcount = 32
	half_len = 0
	pos = 0

	current_node = root_node
	try:
			while True:
				data = struct.unpack('<L', infile.read(4))[0]
				for x in range(32): #32 bits
					if pos == 0:
						pos += 1
					else:
						pos += ((( current_node & 0x3F) + 1) << 1)

					if (data & 0x80000000): #Direita - 1
						if (current_node & 0x40):
							write_data = True
						current_node = huffman_tree[pos + 1]
					else: #Esquerda - 0
						if (current_node & 0x80):
							write_data = True
						current_node = huffman_tree[pos]

					if write_data:
						if (flag & 0x0F) == 0x8:
							# Para 8 bits, o data_node atual é o próprio byte
							value = current_node
							half_len += 8
						else:
							# Para 4 bits, o byte é formado: (data_node_2 << 4 | data_node_1) ..
							# Lembrar que (data_node & 0xF0) é sempre 0
							if half_len == 0:
								value = current_node
							else:
								value |= (current_node << 4)
							half_len += 4

						if half_len == 8: # Um byte foi gerado
							word |= (value << bitshift)
							bitcount -= 8
							bitshift += 8
							half_len = 0
							value = 0
							if not bitcount: # Uma palavra (4 bytes) foi gerada
								decoded_buffer.extend(struct.pack('<L', word)) # Adiciona a palavra gerada ao buffer
								bitcount = 32
								bitshift = 0
								word = 0
						write_data = False
						current_node = root_node
						pos = 0

					if len(decoded_buffer) >= size:
							while len(decoded_buffer) > size:
								decoded_buffer.pop()
							return decoded_buffer
					data <<= 1
	except:
		# Problemas com a compressão... Anyway, forço a retornar alguma coisa >.<
		return decoded_buffer

def try_uncompress(file_map, offset, size):
	try:
		flag = struct.unpack('<L', file_map[offset:offset+4])[0] & 0xFF

		uncompressed_data_size = 0
		offset += 4

		tree_size = (struct.unpack('B', file_map[offset])[0] + 1) * 2
		tree_start = offset + 1
		data_offset = offset + tree_size
		huffman_tree = [struct.unpack('B', x)[0] for x in file_map[tree_start:data_offset]]
		root_node = huffman_tree[0]

		write_data = False
		bitcount = 32
		half_len = 0
		pos = 0

		current_node = root_node
		while True:
			data = struct.unpack('<L', file_map[data_offset:data_offset+4])[0]
			data_offset += 4
			for x in range(32): #32 bits
				if pos == 0:
					pos += 1
				else:
					pos += ((( current_node & 0x3F) + 1) << 1)

				if pos >= len(huffman_tree) + 1:
					return False

				if (data & 0x80000000): #Direita - 1
					if (current_node & 0x40):
						write_data = True
					current_node = huffman_tree[pos + 1]
				else: #Esquerda - 0
					if (current_node & 0x80):
						write_data = True
					current_node = huffman_tree[pos]

				if write_data:
					if (flag & 0x0F) == 0x8:
						half_len += 8
					else:
						half_len += 4

					if half_len == 8:
						bitcount -= 8
						half_len = 0
						if not bitcount:
							uncompressed_data_size += 4
							bitcount = 32
					write_data = False
					current_node = root_node
					pos = 0

				if uncompressed_data_size >= size:
					return True
				data <<= 1
	except IndexError:
		return False
