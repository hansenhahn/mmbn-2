# coding: iso-8859-1
#
#	   PyTable.py v0.3
#
#			Copyright 2009:
#			George Alisson de Oliveira (GANO/sei_la0) <george_alisson@yahoo.com.br>
#			Diego Hansen Hahn (DiegoHH) <diegohh90@hotmail.com>
#
#
#	   This program is free software; you can redistribute it and/or modify
#	   it under the terms of the GNU General Public License as published by
#	   the Free Software Foundation; either version 2 of the License, or
#	   (at your option) any later version.
#
#	   This program is distributed in the hope that it will be useful,
#	   but WITHOUT ANY WARRANTY; without even the implied warranty of
#	   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	   GNU General Public License for more details.
#
#	   You should have received a copy of the GNU General Public License
#	   along with this program; if not, write to the Free Software
#	   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#	   MA 02110-1301, USA.

hexint = hex

def hex(x):
	'''
	hex(int) -> str. Converte um inteiro em uma string hexadecimal.
	'''
	if x == 0:
		return '00'
	lista = '0123456789ABCDEF'
	y = ""
	while x:
		y = lista[x%16] + y
		x /= 16
	if len(y)%2 != 0:
		y = '0'+y
	return y

def hexchr(x):
	'''
	hexchr(hex) -> str. Retorna uma string com caracteres de valores da string hexadecimal hex.
	'''
	y = ""
	for i in range(0,len(x),2):
		exec 'y += "\\x%s"'%(x[i:i+2])
	return y

def hexord(x):
	'''
	hexord(str) -> hex. Retorna uma string hexadecimal com o valor da ordem dos caracteres da string str.
	'''
	y = ""
	for i in x:
		y += hex(ord(i))
	return y

def bytewarp(x):
	'''
	bytewarp(str) -> str. Retorna uma string revertida de uma string.
	'''
	y = ""
	for i in range(len(x)):
		y += x[-i-1]
	return y

 #---------------------------------------------------------------------------------------------------------
import exceptions
class TableError(exceptions.Exception):
	'''
	Error for Table files
	'''
	pass

# ----------------------------------------------------------------------------------------------------------
class unicode_table(object):
	'''
	PyTable() -> new empty Table.
	PyTable(File_name, Encoding) -> new Table loaded from file File_name with encoding Encoding.
	If Encoding is equals a None and the table file is marked with "# coding: <encoding>", Encoding will be <encoding>.

	Key and Values are always strings.
	Data are stored as dicts with format {str:unicode} (e.g. {'\\xaf':u'A'})
	'''

	_mode = 'normal'
	_n = {}
	_i  = {}

	def _normalize(self, tab):
		'''
		T._normalize(tab) -> list. Remove os caracteres inúteis da "lista de tabela" tab e retorna uma lista.
		'''
		from os import linesep
		t = []
		for i, line in enumerate(tab):
			if line != linesep and line[0] != '#':
				t += [line.strip('\n\r')]
		return t

	def _create_dict(self, tab):
		'''
		T._create_dict(tab) -> dict. Retorna um dicionário gerado da "lista de tabela" tab.
		'''
		try:
			dic = {}
			for item in tab:
				if '==' in item:
					itemc = [item.split('=')[0]]+['=']
				else:
					itemc = item.split('=')
				key = itemc[0]
				value = unicode(itemc[1])
				dic.update({hexchr(key):value})
			return dic
		except:
			ERRO = TableError('Line "%s" is not in valid format'%repr(itemc))
			raise ERRO

	def _create_table(self, dic):
		'''
		T._create_table(dic) -> str. Retorna uma "string de tabela" do dicionário dic.
		'''
		tab = u""
		items = dic.items()
		items.sort()
		for k,v in items:
			tab += hexord(k) + '=' + v + '\n'
		return tab

	def _invert_dict(self, dic):
		'''
		T._invert_dict(dic) -> dict. Retorna um dict invertido do dicionário dic.
		'''
		d = {}
		for k,v in dic.items():
			d.update({v:k})
		return d

	def update(self, msg):
		'''
		T.update(E, **F) -> None.  Update T from E and F: for k in E: T[k] = E[k]
		(if E has keys, else: for (k, v) in E: T[k] = v) then: for k in F: T[k] = F[k]
		 '''
		self._n.update(msg)
		self._i = self._invert_dict(self._n)

	def add_items(self, *items):
		'''
		T.add_items(*Items) -> Add Items to T. Items should be in "table format" (e.g. "61=A")
		'''
		if items != ():
			self._n.update(self._create_dict(items))
			self._i = self._invert_dict(self._n)

	def fill_with(self, *items):
		'''
		T.fill_with(*Items) -> None. Fill T with lowercase, uppercase or numbers. Items shoud be in "table format".
		Accepts 8 or 16 bits. Accepts 'a', 'A' and '0' as values. (e.g. T.fill_with('42=a', '8080=A') )
		'''
		if items != ():
			for x in range(len(items)):
				item = items[x].split('=')
				key = long(item[0], 16)
				value = item[1]
				if value == 'a': end_value = 'z'
				elif value == 'A': end_value = 'Z'
				elif value == '0': end_value = '9'
				else:
					ERRO = TableError('Value should be \'a\', \'A\' or \'0\'.')
					raise ERRO
				letters = [chr(i) for i in range(ord(value), ord(end_value)+1)]
				for i, letter in enumerate(letters):
					x = key + i
					if x > 0xFF and len(item[0]) == 2: x -= 0x100
					elif x > 0xFFFF and len(item[0]) == 4: x -= 0x10000
					if len(item[0]) == 4 and x <= 0xFF:
						self._n.update({'\x00'+chr(x):unicode(letter)})
					else:
						self._n.update({hexchr(hex(x)):unicode(letter)})
				self._i = self._invert_dict(self._n)

	def __pos__(self):
		'''
		T.__pos__() <==> +T <==> T.set_mode('normal')
		'''
		self._mode = 'normal'

	def __neg__(self):
		'''
		T.__neg__() <==> -T <==> T.set_mode('inverted')
		'''
		self._mode = 'inverted'

	def set_mode(self, mode):
		'''
		T.set_mode(M) -> None. Set M as mode of T. Valid modes are: 'normal' and 'inverted'
		'''
		if mode.lower() in ['normal','inverted']:
			self._mode = mode

	def toggle_mode(self):
		'''
		T.toggle_mode() -> None. Switch modes of T
		'''
		if self._mode == 'normal':
			return -self
		else:
			return +self

	def get_mode(self):
		'''
		T.get_mode() -> str. Return mode of T
		'''
		return self._mode

	def isMode(self, mode):
		'''
		T.isMode(M) -> bool. True if mode of T is M, else False
		'''
		if self._mode == mode:
			return True
		return False

	def __delitem__(self, y):
		'''
		x.__delitem__(y) <==> del x[y]
		'''
		del self._n[y]
		self._i = self._invert_dict(self._n)

	def remove_items(self, *items):
		'''
		T.remove_items(*Items) -> Remove Items of T. Items should be in hex (e.g. "AC")
		'''
		if items != ():
			for k in items:
				del self[hexchr(k)]

	def clear(self):
		'''
		T.clear() -> None.  Remove all items from T
		'''
		self._n = {}
		self._i = {}

	def copy(self):
		'''
		T.copy() -> a shallow copy of T
		'''
		T = PyTable()
		T.update(self._n)
		return T

	def __contains__(self, key):
		'''
		T.__contains__(k) -> True if T has a key k, else False <==> k in T
		Depends on mode of T
		'''
		if self._mode == 'normal':
			return key in self._n
		else:
			return key in self._i

	def __getitem__(self, key):
		'''
		T.__getitem__(y) <==> T[y]
		Depends on mode of T
		'''
		if self._mode == 'normal':
			return self._n[key]
		else:
			return self._i[key]

	def __setitem__(self, key, y):
		'''
		x.__setitem__(i, y) <==> x[i]=y
		'''
		self._n[key] = unicode(y)
		self._i = self._invert_dict(self._n)

	def has_key(self, key):
		'''
		T.has_key(k) -> True if T has a key k, else False
		Depends on mode of T
		'''
		return key in self

	def get(self, key, d = ""):
		'''
		T.get(k[,d]) -> T[k] if k in T, else d.  d defaults to "".
		Depends on mode of T
		'''
		if key in self:
			return self[key]
		else:
			return d

	def setdefault(self, key, d = ""):
		'''
		T.setdefault(k[,d]) -> T[k] (normal mode), also set T[k]=d if k not in T. d defaults to "".
		'''
		if not key in self._n:
			self[key] = d
		else:
			return self._n[key]

	def get_table(self, key, d = ""):
		'''
		T.get(k[,d]) -> T[k] if k in T, else d.  d defaults to "".
		if mode of T is "normal", k should be in hex (e.g. "AC")
		If mode of T is "inverted",  return hex of T[k]
		'''
		if self._mode == 'normal':
			if hexchr(key) in self._n:
				return self[hexchr(key)]
			else:
				return d
		else:
			if key in self._i:
				return hexord(self[key])
			else:
				return d

	def set_table(self, key, v):
		'''
		T.set_table(k,v) -> T[k]=v.
		k should be in hex (e.g. "AC")
		'''
		self[hexchr(key)] = v

	def setdefault_table(self, key, d = ""):
		'''
		T.setdefault(k[,d]) -> T[k] (normal mode), also set T[k]=d if k not in T.
		d defaults to "" and k should be in hex (e.g. "AC")
		'''
		if hexchr(key) in self._n:
			return self._n[hexchr(key)]
		else:
			self[hexchr(key)] = d

	def has_key_table(self, key):
		'''
		T.has_key_table(k) -> True if T has a key k, else False
		if mode of T is "normal", k should be in hex (e.g. "AC")
		Depends on mode of T
		'''
		return hexchr(key) in self

	def items(self):
		'''
		T.items() -> list of T's (key, value) pairs, as 2-tuples
		Depends on mode of T
		'''
		if self._mode == 'normal':
			return self._n.items()
		else:
			return self._i.items()

	def keys(self):
		'''
		T.keys() -> list of T's keys
		Depends on mode of T
		'''
		if self._mode == 'normal':
			return self._n.keys()
		else:
			return self._i.keys()

	def __iter__(self):
		'''
		x.__iter__() <==> iter(x)
		'''
		for k in self.keys():
			yield k

	def values(self):
		'''
		D.values() -> list of D's values
		Depends on mode of T
		'''
		if self._mode == 'normal':
			return self._n.values()
		else:
			return self._i.values()

	def __len__(self):
		'''
		x.__len__() <==> len(x)
		'''
		if self._mode == 'normal':
			return len(self._n)
		else:
			return len(self._i)

	def __str__(self):
		'''
		x.__str__() <==> str(x)
		'''
		return self._create_table(self._n).encode('raw_unicode_escape')

	def __unicode__(self):
		'''
		x.__unicode__() <==> unicode(x)
		'''
		return self._create_table(self._n)

	def __repr__(self):
		'''
		x.__repr__() <==> repr(x)
		'''
		return '<PyTable object at %s>'%(hexint(self.__hash__()))

	def iteritems(self):
		'''
		T.iteritems() -> an iterator over the (key, value) items of T
		Depends on mode of T
		'''
		for k in self:
			yield (k, self[k])

	def iterkeys(self):
		'''
		T.iterkeys() -> an iterator over the keys of T
		Depends on mode of T
		'''
		return self.__iter__()

	def itervalues(self):
		'''
		T.itervalues() -> an iterator over the values of T
		Depends on mode of T
		'''
		for _, v in self._iteritems():
			yield v

	def save(self, file_name, encoding):
		'''
		T.save(F, E) -> None. Save contents of T to file F with encoding E
		Mode of F is overwrite ('w')
		'''
		from os import linesep
		from codecs import open
		file = open(file_name, 'w', encoding)
		file.write(unicode(self).replace('\n',linesep))
		file.close()

	def save_with_mark(self, file_name, encoding):
		'''
		T.save(F) -> None. Save contents of T to file F with encoding E and with mark "# coding: <encoding>"
		Mode of F is overwrite ('w')
		'''
		from os import linesep
		from codecs import open
		file = open(file_name, 'w', encoding)
		file.write('# coding: '+encoding+linesep+
		unicode(self).replace('\n',linesep))
		file.close()

	def __init__(self, file_name = None, encoding = None):
		'''
		x.__init__(...) initializes x; see x.__class__.__doc__ for signature
		'''
		from codecs import open
		if file_name != None:
			if encoding == None:
				file = open(file_name).readline()
				if 'coding:' in file:
					encoding = file[file.index('coding:')+7:].strip()
				else:
					ERRO = UnicodeError("If file_name is giving, encoding can't be None.")
					raise ERRO
			file = open(file_name, 'r', encoding)
			file.seek(0)
			table = self._normalize(file.readlines())
			self._n = self._create_dict(table)
			self._i = self._invert_dict(self._n)
			file.close()

	def open(self, file_name, encoding):
		'''
		T.open(F, E) -> None. Open file F and load contents for T with encoding E
		E defaults to None. If E is equals a None and the table file is marked with "# coding: <encoding>", E will be <encoding>.
		'''
		if file_name != None:
			return self.__init__(file_name, encoding)


