# ECE251 Final Project
---
This is a single-cycle computer with an 8-bit ALU and 24-bit instructions that includes an assembler which automatically puts the machine code into the system. To create the computer, run `make`. To run one of the three sample programs, use `py assembler.py <program_name.asm>` to create the machine code. Once this is done, running `vvp a.out` will run the computer with the machine code loaded.

# Architecture Diagrams
---
This is the datapath of the computer:
![datapath](https://user-images.githubusercontent.com/60396592/168507506-bd796fc6-165f-4255-9505-3fd76b3610da.jpg)
The PC tells the IM, instruction memory, which 24-bit instruction to load. The first six bits of the instruction operate as the opcode. The first three bits instruct CTRL, the control, how to operate properly for the instruction. This adjusts which registers and areas of memory should be written to and which inputs to various multiplexers should go through. The last three bits of the opcode select the ALU operation, and get passed into the ALU. The next eight bits either operate as an immediate or the second selected register, for which its value is put into the `data2` wire. Wheteher or not it is treated like an immediate or a register is determined by the `rori` output of the control, short for "read or immediate".  The next five bits indicate the first register, which has its value put into `data1`, and the last five registers indicates the register that, in the case that `regwrite` is positive, will be written to with the data in `writedata`, or the register that holds the address to branch to in the case of a branch.

![control](https://user-images.githubusercontent.com/60396592/168507298-f6eae3f5-91db-4cb7-9346-51c24c73ccf7.jpg)
The control reads the instructions from instruction memory and determines how the computer will use the data using the `regwrite`, `rori`, `memwrite`, `aluordm`, and `branch` output wires.  `regwrite` determines if the data in the `writedata` input of the registers is written to the selected register, `rori` determines if the input to the ALU is the immediate or the register data,  `memwrite` determines if the data memory is being written to, `aluordm` determines if the `writedata` input to the registers is coming from the ALU or data memory, and `branch` determines whether to branch, given the output of the ALU is zero.

On instructions that apply the ALU operations to values in registers and stores them back in another register, such as ADD, SUB, AND, ORR, SLT, LSL, and LSR, the register values are put into the ALU, where the output of the ALU is put back into the registers and written to the destination register - branching is off for this operation, and no data is written to data memory. For the immediate ALU operations, like ADDI, SUBI, ANDI, ORRI, SLTI, LSLI, and LSRI, everything is the same but the immediate is put into the ALU. CBE, or condtional branch equal, subtracts the value of the first register by the immediate, and branches if the output is zero - data memory isn't written to, and because the registers aren't being written to it doesn't matter if the output of the ALU or data memory is fed into the registers. For LDUR, or load, a specified value from data memory is selected and written to the destination register - there is no branching, no writing to data memory, and because the output of the ALU doesn't matter, the value of `rori` does not matter.
For STUR,  data from a register is written into memory - there is no branching, nothing is written to the registers so the value of `aluordm` doesn't matter, and the the ALU isn't used so `rori` doesn't matter.

# Timing Diagram
---
![gtkwave](https://user-images.githubusercontent.com/60396592/168507429-3207195c-8f19-4604-ba76-f0204de8e156.jpg)
This GTKWave timing diagram resulted from running `math_and_storage_test.asm`.  The code is as follows:

```Assembly:
ADDI 1 0 255
ADDI 2 0 127
ADDI 3 0 0
ADDI 4 0 1
STUR 0 1 3
STUR 0 2 4
LDUR 5 0 3
LDUR 6 0 4
SUB 1 5 6
CBE 5 0 0
```

It can be noticed overall that on the falling edge of the clock, the instruction and the pc changes. This is as opposed to the branchi, which changes on the rising edge. Only the pc changes on the falling edge and values are evaluated, after which point those values get stored into data memory and the registers. The first four lines use add immediate to load 255 into register 1, 127 into register 2, 0 into register 3, and 1 into register 4 - the control operators are changing the way indicated above. For the stores, the value in register 1, 255, is stored to data memory at the address stored in register 3, 0, and then the value in register 2, 127, is stored to data memory at the address stored in register 4, 1. The store operations has a zero as their first inputs, which don't do anything and could be any arbitrary value. Then with the loads, the values stored in the addresses of data memory stored in registers 3 and 4 are loaded to registers 5 and 6 respectively. The value of register 1 is assigned to the value of register 5, 255, minus the value of register 6, 127, which evaluates to 128. There is then a conditional branch, where if the value in the zero register, 0, equals the immediate value 0, which is always true, the computer will branch to the address in register 5, 255. Branching to 255 ends the program, so the program is finished. The value of register 1 is monitored, since the last value of register 1 is considered the output for this design - in this case the output is 128.

# Example Programs
---
The `math_and_storage_test.asm` program is discussed in depth above in the timing diagram section.

The `collatz.asm` program considers the length of a sequence of integers starting at a certain point. Given a certain starting integer, which is assigned to register 2 in the first line of the program, the next item is either the starting integer times three plus one, if the value is odd, or half the starting integer, if it is even. This sequence proceeds until the value of one is found.

Consider the program for the value 3:
3 -> 10 -> 5 -> 16 -> 8 -> 4 -> 2 -> 1
The sequence is eight values long, so the program returns eight when the program is started with register 2 initialized as 3. If you wish to check that this program works for other values, you can test it against `collatz.py` - running `python collatz.py <integer>` will give the answer with `<integer>` as the starting value.

The `fibonacci.asm` program gives the value of nth fibonnaci number, where n is the number initialized into register 4 on the first line of the program. Changing this value will change the output accordingly, and as long as the output can be respresented with an eight bit unsigned number, the program should operate appropiately.
