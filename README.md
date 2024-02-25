# SIMD Multimedia Unit
This repo contains VHDL files for simulating a single instruction multiple data multimedia unit. This unit is 4-stage pipelined, with data forwarding. 


## Instruction set
Below is the list of implemented instruction set

4.1 Load Immediate (LI)
Load a 16-bit Immediate value from the [20:5] instruction field into the 16-bit field specified by the Load Index field [23:21] of the 128-bit register rd. Other fields of register rd are not changed. Note that a LI instruction first reads register rd and then (after inserting an immediate value into one of its fields) writes it back to register rd, i.e., register rd is both a source and destination register of the LI instruction.

4.2 Multiply-Add and Multiply-Subtract R4-Instruction Format
Signed operations are performed with saturated rounding that takes the result, and sets a floor and ceiling corresponding to the max range for that data size. This means that instead of over/underflow wrapping, the max/min values are used.

Opcode [22:20]	Description of Instruction Code
000	Signed Integer Multiply-Add Low with Saturation
001	Signed Integer Multiply-Add High with Saturation
010	Signed Integer Multiply-Subtract Low with Saturation
011	Signed Integer Multiply-Subtract High with Saturation
100	Signed Long Integer Multiply-Add Low with Saturation
101	Signed Long Integer Multiply-Add High with Saturation
110	Signed Long Integer Multiply-Subtract Low with Saturation
111	Signed Long Integer Multiply-Subtract High with Saturation
4.3 R3-Instruction Format
In the table below, 16-bit signed integer add (AHS), and subtract (SFHS) operations are performed with saturation to signed halfword rounding that takes a 16-bit signed integer X, and converts it to -32768 (the most negative 16-bit signed value) if it is less than -32768, to +32767 (the highest positive 16-bit signed value) if it is greater than 32767, and leaves it unchanged otherwise.

Opcode [22:15]	Description of Instruction Opcode
xxxx0000	NOP: no operation. Make sure that a NOP instruction does not write anything to the register file!
xxxx0001	ABSDB: absolute difference of bytes
xxxx0010	AU: add word unsigned
xxxx0011	CNT1W: count 1s in words
xxxx0100	AHS: add halfword saturated
xxxx0101	AND: bitwise logical and of the contents of registers rs1 and rs2
xxxx0110	BCW: broadcast word
xxxx0111	MAXWS: max signed word
xxxx1000	MINWS: min signed word
xxxx1001	MLHU: multiply low unsigned
xxxx1010	MLHCU: multiply low by constant unsigned
xxxx1011	OR: bitwise logical or of the contents of registers rs1 and rs2
xxxx1100	CNTLZ: count leading zeroes in words
xxxx1101	ROTW: rotate bits in word
xxxx1110	SFWU: subtract from word unsigned
xxxx1111	SFHS: subtract from halfword saturated

 
