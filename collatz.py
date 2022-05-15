import sys

def collatz(n):
    if n == 1:
        return 1
    elif (n%2 == 0):
        return 1 + collatz(n//2)
    else:
        return 1 + collatz(n*3 + 1)

print(collatz(int(sys.argv[1])))