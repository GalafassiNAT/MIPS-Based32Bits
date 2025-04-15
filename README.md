# Mips Based Architecture
This project consists in a work from the **Computer Organization and Architecture's** subject of the **Computer Science's** degree at the **Federal University of Technology Parana (UTFPR-CM)**.
The objective of this work is to implement a MIPS based architecture, using the *Logisim* software. 

For starters, let's take a look at the Datapath of the architecture and its components:
![Datapath](Datapath%20Image.png) 

The components of the Datapath are:
- **PC**: Program Counter.
- **Instruction Memory**: Memory that stores the instructions.
- **Registers**: 32 bits memory where the data is stored and can be manipulated. 
- **ALU**: Arithmetic Logic Unit.
- **Data Memory**: Memory that stores the data.
- **Control Unit**: Unit that controls the flow of the data.
- **Signal Extender**: Unit that extends the signal of a 16 bits immediate to 32 bits.
- **Multiplexers**: Unit that selects the input to be sent to the output.
- **Shift << 2 concatenator**: Unit that shifts the address to the left by 2 bits and concatenates it with the PC address + 4.
- **Decoder**: Unit that decodes the instruction that came from the Instruction Memory.
- **Alu Control**: Unit that controls the ALU operation.
- **Register's bank**: Unit that stores the main registers of the architecture.
- **Exception Control Unit**: Unit that controls the exceptions of the architecture.

---

## Program Counter (PC):
The PC is a 32 bits register that stores the address of the next instruction to be executed. It is incremented by 4 in each cycle, so it can point to the next instruction. It can also be changed by the Jump and Branch instructions or if an exception occurs.

## Instruction Memory:
The Instruction Memory is a ROM memory that stores the instructions of the program. It is a 32 bits memory, where each instruction is stored in a 32 bits address. The instruction memory is read in each cycle, and the instruction that is stored in the address pointed by the PC is sent to the Decoder. Due to **limitations** of the logisim software, the memories that it provides has only 24 bits of address, so to deal with this problem, we used two memories, where the 2nd memory would only be selected at the 25th bit, in this way, we can store the instructions in a number bigger than 24 bits addresses. One thing that is important to mention is that we only are able to walk through the memory in steps of 4, because of a shift of 2 bits. We can't have all the 32 bits of address, unless we use another memory for each remaining bit of address, but this would be very inefficient.

![Instruction Memory](/Images/Instruction%20Memory.png)

## Decoder:
The Decoder is a unit that decodes the instruction that came from the Instruction Memory. It is a combinational circuit that receives the instruction and outputs the control signals that will be used by the Control Unit. With the decoder we can know if an instruction is a R-Type, I-Type or J-Type, and also what operation it is. The decoder also outputs the registers that will be used by the instruction, the immediate and the address of the jump instruction. Basicaly it takes the instruction and outputs the data that will be used by the other units of the architecture, its outputs are:
- **Opcode**: The operation code of the instruction.
- **Rs**: The first register that will be used by the instruction.
- **Rt**: The second register that will be used by the instruction, can be used as a destination register.
- **Rd**: The third register that will be used by the instruction generally used as a destination register.
- **Shamt**: The shift amount of the instruction.
- **Funct**: The function code of the instruction.
- **Imm**: The immediate of the instruction.
- **Addr**: The address of the jump instruction.

![Decoder External](/Images/Decoder%20External.png)
![Decoder Internal](/Images/Decoder.png)


## Registers' File:
The Register's File contains all the main registers used by the architecture, it has 5 inputs and 2 outputs. The inputs are:
- LR1: The first register that will be read (Rs).
- LR2: The second register that will be read (Rt).
- WR: The register that will be written (Rd). In instructions that aren't R-Type, sometimes Rt is used.
- WD: The data that will be written in the register.
- RegWrite: A control signal that indicates if the register will be written or not.

For the outputs, we have:
- RD1: The data that is stored in the first register.
- RD2: The data that is stored in the second register.

As for the register, we have 32 registers, each one with 32 bits. The registers are numbered from 0 to 31, and the register **\$0** or **$zero** will always be 0.  

| Register     | Number | Register | Number | Register | Number | Register | Number |
| --------     | ------ | -------- | ------ | -------- | ------ | -------- | ------ |
| **$zero**    | 0      | **$t0**  | 8      | **$s0**  | 16     | **$t8**  | 24     |
| **$at**      | 1      | **$t1**  | 9      | **$s1**  | 17     | **$t9**  | 25     |
| **$v0**      | 2      | **$t2**  | 10     | **$s2**  | 18     | **$k0**  | 26     |
| **$v1**      | 3      | **$t3**  | 11     | **$s3**  | 19     | **$k1**  | 27     |
| **$a0**      | 4      | **$t4**  | 12     | **$s4**  | 20     | **$gp**  | 28     |
| **$a1**      | 5      | **$t5**  | 13     | **$s5**  | 21     | **$sp**  | 29     |
| **$a2**      | 6      | **$t6**  | 14     | **$s6**  | 22     | **$fp**  | 30     |
| **$a3**      | 7      | **$t7**  | 15     | **$s7**  | 23     | **$ra**  | 31     |

![Inside Register's Bank](/Images/Register's%20Bank.png)
![Register's Bank](/Images/Register's%20Bank%20external.png)

## ALU:
The ALU is a unit that performs the arithmetic and logic operations. It has 4 inputs and 3 outputs. The inputs are:
- A: The first operand.
- B: The second operand, if the flag AluSrc is activated, it'll receive an immediate.
- AluOp: The operation that will be performed.
- Shamt: The shift amount.

As for the outputs, we have:
- Result: The result of the operation.
- Zero: A flag that indicates if the result is zero.
- Overflow: A flag that indicates if the result has caused an overflow. It has an AND gate connect to a Branch flag, to not cause an exception when the branch instruction is executed.

The ALU in this architecture can perform the following operations:

| Operation | AluOp |              Description                   |
| --------- | ----- | ------------------------------------------ |
| AND	    | 0000  | Performs the AND operation between A and B.|
| OR	    | 0001  | Performs the OR operation between A and B. |
| ADD	    | 0010  | Performs the ADD operation between A and B.|
| XOR	    | 0011  | Performs the XOR operation between A and B.|
| SLL	    | 0100  | Performs the SLL operation between A and B.|
| SRL	    | 0101  | Performs the SRL operation between A and B.|
| SUB	    | 0110  | Performs the SUB operation between A and B.|
| SLT	    | 0111  | Performs the SLT operation between A and B.|
| NOR	    | 1000  | Performs the NOR operation between A and B.|

For dealing with the overflow, we used a logisim component called **Comparator** that compares two numbers and outputs a flag that indicates if the first number is bigger, equal or smaller than the second number. In this way, we could handle the overflow of the ADD and SUB operations.
Overflow cases for ADD:

```
 if A > 0 AND B > 0 AND Result < 0, then overflow.
``` 
```
 if A < 0 AND B < 0 AND Result > 0, then overflow.
```
Overflow cases for SUB:

```
 if A > 0 AND B < 0 AND Result < 0, then overflow.
``` 
```
 if A < 0 AND B > 0 AND Result > 0, then overflow.
```

![ALU](/Images/ALU.png)
![ALU External](/Images/ALU%20External.png)

## Data Memory:
The Data Memory is a RAM memory that stores the data of the program. It is a 32 bits memory, where each data is stored in a 32 bits address. The data memory is read and written in each cycle, and the data that is stored in the address pointed by the ALU is sent to the Register's File. Like the Instruction memory, due to **limitations** of the logisim software, the memories that it provides has only 24 bits of address, so to deal with this problem, we used two memories, where the 2nd memory would only be selected at the 25th bit, this way, we can store the data in a number bigger than 24 bits addresses. It also has a shift of 2 bits. 

![Data Memory](/Images/Data%20Memory.png)
![Data Memory External](/Images/External%20Data%20Memory.png)

## Control Unit:
The Control Unit is a unit that controls the flow of the data, using flags that are activated or deactivated depending on the instruction that is being executed, affecting multiplexers along the Datapath. It reiceives the opcode from the instruction that comes from the Decoder and outputs the control signals that will be used by the other units of the architecture. The operations and the control signals are:
|Opcode|Instruction|          Control Signals          |AluOP|
|------|-----------|-----------------------------------|-----|
|000000|R-Type     |RegDst, WriteReg                   |00   |
|100000|RFE        |WriteReg, ExcOut                   |XX   |
|100001|MTC0       |MTC0                               |XX   |
|100010|MFC0       |MFC0, WriteReg                     |XX   |
|001000|ADDI       |WriteReg, AluSrc                   |01   |
|100011|LW         |MemToReg, MemRead, WriteReg, AluSrc|01   |
|101011|SW         |MemWrite, AluSrc                   |01   |
|000100|BEQ        |Branch, AluSrc                     |10   |
|000101|BNE        |Branch, Bne                        |10   |
|000010|J          |Jump                               |XX   |
|000011|JAL        |Jump, WriteReg, Link               |XX   |

Here we can find R-Type, I-Type and J-Type instructions. The R-Type instructions are the ones that have the opcode <u>000000</u>, the I-Type instructions are the ones that have the opcodes <u>001000</u>, <u>100011</u>, <u>101011</u>, <u>000100</u> and <u>000101</u>, and the J-Type instructions are the ones that have the opcodes <u>000010</u> and <u>000011</u>.

![Control Unit](/Images/Control%20Unit.png)	
![Control Unit External](/Images/Control%20Unit%20External.png)

## ALU Control:
The ALU Control is a unit that controls the ALU operation, using the funct for R-Type instructions and the aluop for I-Type instructions. It receives the aluop and the funct of the instruction that comes from the Decoder or the aluop that comes from the Control Unit and outputs the aluop that will be used by the ALU. 
For the aluop that comes from the Control Unit we have 2 bits that are used to control the ALU operation with the multiplexer, if the AluOp is 00 we have general operations that will be decided by the funct code, for 01 we force an Add operation and for 10 we force a Sub operation. Let's take a look at the table below:

|Funct |Operation|
|----- |---------|
|100000|Add      |
|100010|Sub      |
|100100|And      |
|100101|Or       |
|100110|Xor      |
|100111|Nor      |
|101010|SLT      |
|000000|SLL      |
|000010|SRL      |
|001000|JR       |

**Note:** The JR instruction is a special case, because it doesn't sends a operation code to the ALU, but instead it sends a signal to the PC to jump to the address that is stored in the register that is being read by the MUX thanks to the flag **Jump Register** in the ALU Control.

## Signal Extender:
The Signal Extender is a unit that extends the signal of a 16 bits immediate to 32 bits. It receives the immediate that comes from the Decoder and outputs the extended immediate that will be used by the ALU. What it does is repeat the MSB of the 16 bits immediate until it reaches the 31st bit.

![Signal Extender](/Images/Signal%20Extender.png)
![Signal Extender External](/Images/Signal%20Extender%20External.png)
