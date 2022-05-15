import sys
file = open(sys.argv[1], 'r')
lines = [x.rstrip() for x in file]
def linetobinary(line):
    words = line.split()
    opcodes = {"ADD" : 32, "SUB" : 33, "AND" : 34, "ORR" : 35,
               "SLT" : 36, "LSL" : 37, "LSR" : 38,
               "ADDI" : 40, "SUBI" : 41, "ANDI" : 42, "ORRI" : 43,
               "SLTI" : 44, "LSLI" : 45, "LSRI" : 46,
               "CBE" : 1, "LDUR" : 8, "STUR" : 16}
    data = [int(num) for num in words[1:]]
    return opcodes[words[0]]*(2**18) + data[0] + data[1]*(2**5) + data[2]*(2**10)
def makehex(num):
    s = hex(num)[2:]
    s = "0"*(6-len(s)) + s
    return s
linesasnums = [linetobinary(line) for line in lines]
linesasnums += [2**23]*(256 - len(linesasnums))
linesasnums = [makehex(num) for num in linesasnums]
finalstring = "\n".join(linesasnums)
if (len(sys.argv) >= 3):
    file = open(sys.argv[2], 'w')
else:
    file = open("im_data.txt", 'w')
file.write(finalstring)