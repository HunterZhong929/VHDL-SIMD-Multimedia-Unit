# SIMD Multimedia Unit
This repo contains VHDL files for simulating a single instruction multiple data multimedia unit. This unit is 4-stage pipelined, with data forwarding. 


## Instruction set
Below is the list of implemented instruction set

### 4.1 Load Immediate

- **li:** Load a 16-bit Immediate value from the [20:5] instruction field into the 16-bit field specified by the Load Index field [23:21] of the 128-bit register rd. Other fields of register rd are not changed. Note that a LI instruction first reads register rd and then (after inserting an immediate value into one of its fields) writes it back to register rd, i.e., register rd is both a source and destination register of the LI instruction!

### 4.2 Multiply-Add and Multiply-Subtract R4-Instruction Format

Signed operations are performed with saturated rounding that takes the result, and sets a floor and ceiling corresponding to the max range for that data size. This means that instead of over/underflow wrapping, the max/min values are used.

Size (Num Bits) | Min | Max
--- | --- | ---
Long (64) | -263 | +263 − 1
Int (32) | -231 | +231 − 1

The tables below show the description for each operation:

#### LI/SA/HL

| Opcode [22:20] | Description of Instruction Code |
| --- | --- |
| 000 | Signed Integer Multiply-Add Low with Saturation: Multiply low 16-bit-fields of each 32-bit field of registers rs3 and rs2, then add 32-bit products to 32-bit fields of register rs1, and save result in register rd |
| 001 | Signed Integer Multiply-Add High with Saturation: Multiply high 16-bit-fields of each 32-bit field of registers rs3 and rs2, then add 32-bit products to 32-bit fields of register rs1, and save result in register rd |
| 010 | Signed Integer Multiply-Subtract Low with Saturation: Multiply low 16-bit-fields of each 32-bit field of registers rs3 and rs2, then subtract 32-bit products from 32-bit fields of register rs1, and save result in register rd |
| 011 | Signed Integer Multiply-Subtract High with Saturation: Multiply high 16-bit- fields of each 32-bit field of registers rs3 and rs2, then subtract 32-bit products from 32-bit fields of register rs1, and save result in register rd |
| 100 | Signed Long Integer Multiply-Add Low with Saturation: Multiply low 32-bit- fields of each 64-bit field of registers rs3 and rs2, then add 64-bit products to 64-bit fields of register rs1, and save result in register rd |
| 101 | Signed Long Integer Multiply-Add High with Saturation: Multiply high 32-bit- fields of each 64-bit field of registers rs3 and rs2, then add 64-bit products to 64-bit fields of register rs1, and save result in register rd |
| 110 | Signed Long Integer Multiply-Subtract Low with Saturation: Multiply low 32- bit-fields of each 64-bit field of registers rs3 and rs2, then subtract 64-bit products from 64-bit fields of register rs1, and save result in register rd |
| 111 | Signed Long Integer Multiply-Subtract High with Saturation: Multiply high 32- bit-fields of each 64-bit field of registers rs3 and rs2, then subtract 64-bit products from 64-bit fields of register rs1, and save result in register rd |

#### 4.3 R3-Instruction Format

In the table below, 16-bit signed integer add (AHS), and subtract (SFHS) operations are performed with saturation to signed halfword rounding that takes a 16-bit signed integer X, and converts it to -32768 (the most negative 16-bit signed value) if it is less than -32768, to +32767 (the highest positive 16-bit signed value) if it is greater than 32767, and leaves it unchanged otherwise.

| Opcode [22:15] | Description of Instruction Opcode |
| --- | --- |
| xxxx0000 | NOP: no operation. Make sure that a NOP instruction does not write anything to the register file! |
| xxxx0001 | ABSDB: absolute difference of bytes: the contents of each of the sixteen byte slots in register rs2 is subtracted from the contents of the corresponding byte slots in register rs1. The absolute value of each of the results is placed into the corresponding byte slot in register rd. (Comments: 16 separate 8-bit values in each 128-bit register) |
| xxxx0010 | AU: add word unsigned: packed 32-bit unsigned addition of the contents of registers rs1 and rs2 (Comments: 4 separate 32-bit values in each 128-bit register) |
| xxxx0011 | CNT1W: count 1s in words :: count 1s in each packed 32-bit word of the contents of register rs1. The results are placed into corresponding slots in register rd . (Comments: 4 separate 32-bit values in each 128-bit register) |
| xxxx0100 | AHS: add halfword saturated : packed 16-bit halfword signed addition with saturation of the contents of registers rs1 and rs2 . (Comments: 8 separate 16-bit values in each 128-bit register) |
| xxxx0101 | AND: bitwise logical and of the contents of registers rs1 and rs2 |
| xxxx0110 | BCW: broadcast word : broadcast the rightmost 32-bit word of register rs1 to each of the four 32-bit words of register rd |
| xxxx0111 | MAXWS: max signed word: for each of the four 32-bit word slots, place the maximum signed value between rs1 and rs2 in register rd. (Comments: 4 separate 32-bit values in each128-bit register) |
| xxxx1000 | MINWS: min signed word: for each of the four 32-bit word slots, place the minimum signed value between rs1 and rs2 in register rd . (Comments: 4 separate 32-bit values in each 128-bit register) |
| xxxx1001 | MLHU: multiply low unsigned: the 16 rightmost bits of each of the four 32-bit slots in register rs1 are multiplied by the 16 rightmost bits of the corresponding 32-bit slots in register rs2, treating both operands as unsigned. The four 32-bit products are placed into the corresponding slots of register rd . (Comments: 4 separate 32-bit values in each 128-bit register) |
| xxxx1010 | MLHCU: multiply low by constant unsigned: the 16 rightmost bits of each of the four 32-bit slots in register rs1 are multiplied by a 5-bit value in the rs2 field of the instruction, treating both operands as unsigned. The four 32-bit products are placed into the corresponding slots of register rd . (Comments: 4 separate 32-bit values in each 128-bit register) |
| xxxx1011 | OR: bitwise logical or of the contents of registers rs1 and rs2 |
| xxxx1100 | CNTLZ: count leading zeroes in words: for each of the four 32-bit word slots in


 
