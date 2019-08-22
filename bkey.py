class bkey(object):
	def __init__(self):
		self.high = {}
		self.low  = {}
		self.ptr  = {}
		self.high_rule = {
			"KEY_PTRS" 	: (60, 3),
			"KEY_DIRTY"	: (36, 1),
			"KEY_SIZE"	: (20, 16),
			"KEY_INODE" : (0, 20)
		}

		self.ptr_rule  = {
			"PTR_DEV" 	: (51, 12),
			"PTR_OFFSET": (8, 43),
			"PTR_GEN"	: (0, 8),
		}

	def parse_file(self, file_name):
		count_hi_lo, count_ptr = 0, 0
		fobj = open(file_name)

		for line in fobj.readlines():
			
			if line.count("high") and line.count("low"):
				count_hi_lo += 1
				self.high[count_hi_lo], self.low[count_hi_lo] = [], []
				self.ptr[count_hi_lo] = []
				hi = int(line.split(",")[-2].split(":")[-1].strip())
				self.high[count_hi_lo].append(hi)

				lo = int(line.split(":")[-1].split(":")[-1].strip())
				self.low[count_hi_lo].append(lo)

			elif line.count("ptr"):
				pt = int(line.split(":")[-1].split(":")[-1].strip())
				if pt is not None:
					self.ptr[count_hi_lo].append(pt)

		# print (self.high)
		# print (self.low)
		# print (self.ptr)


	def parse_data(self):
		hi_res = []
		ptr_res = []
		for _, vs in self.high.items():
			for hi in vs: # for each number
				hi = str(bin(hi))[2:]
				if len(hi) == 1: continue
				each_key_hi = []
				for field, _range in self.high_rule.items():
					left = 64 - _range[0] - _range[1]
					right = 64 - _range[0]
					val = int(str(int(hi[left:right], 2)))
					each_key_hi.append((field, val))
				hi_res.append(each_key_hi)

		lo_res = list(self.low.values())

		for _, vs in self.ptr.items():
			tmp = []
			for i, ptr in enumerate(vs):
				ptr = str(bin(ptr))[2:]
				if len(ptr) == 1: continue
				zeros = "".join(["0" for _ in range(64 - len(ptr))])
				ptr = zeros + ptr
				each_key_ptr = []
				for field, _range in self.ptr_rule.items():
					left = 64 - _range[0] - _range[1]
					right = 64 - _range[0]
					val = int(str(int(ptr[left:right], 2)))
					each_key_ptr.append((field, val))
				tmp.append(each_key_ptr)
			ptr_res.append(tmp)


		assert(len(hi_res) == len(lo_res) == len(ptr_res))

		for i in range(len(hi_res)):
			print ("high: ", str(hi_res[i]), ", low: ['KEY_OFFSET'] : %s" % lo_res[i][0])
			if len(ptr_res[i]) == 0:
				print ("	ptr:  []")
			for j, ptr in enumerate(ptr_res[i]):
				if j >= 1: continue
				print ("	ptr%s: " % j, str(ptr))




if __name__ == '__main__':
	b = bkey()
	b.parse_file("bkey.txt")
	b.parse_data()


"""
1001000000000000000000000001000000000000000100000000000000000000

001  KEY_PTRS

00   HEADER_SIZE

00   KEY_CSUM

0    KEY_PINNED

000000000000000000

1    KEY_DIRTY

0000000000000001    KEY_SIZE

00000000000000000000    KEY_INODE
"""