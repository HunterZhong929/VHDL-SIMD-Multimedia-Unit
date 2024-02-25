def convert(line):
    if line[0:3] == "nop":
        return convert_r3(line)
    i = 0
    ins = ""
    while(line[i] != ' '):
        ins = ins + line[i]
        i = i+1

    if ins=="li":
        return convert_li(line)
    elif ((ins=="imal") or (ins=="imah") or (ins=="imsl") or (ins=="imsh") 
        or (ins=="lmal") or (ins=="lmah") or (ins=="lmsh") or (ins=="lmsl")):
        return convert_r4(line)
    else:
        return convert_r3(line)
        
def convert_li(line):
    i = 0
    j = 0
    rd = ""
    immediate = ""
    while(i<len(line)):
        if(line[i] == '$'):
            if j==0:
                j += 1
                rd = rd + line[i+1]
                i += 1
                if line[i+1].isnumeric():
                    rd = rd + line[i+1]
                    i += 1
            i += 1

        elif(j==1 and line[i].isnumeric()):
            index = line[i]
            j += 1
            i += 1
        
        elif(j==2 and line[i].isnumeric()):
            while(i < len(line) and line[i].isnumeric()):
                immediate = immediate + line[i]
                i += 1
        else:
            i += 1

    rd_bin = bin(int(rd))[2:]
    while(len(rd_bin) < 5):
        rd_bin = "0" + rd_bin
    index_bin = bin(int(index))[2:]
    while(len(index_bin) < 3):
        index_bin = "0" + index_bin
    immediate_bin = bin(int(immediate))[2:]
    while(len(immediate_bin) < 16):
        immediate_bin = "0" + immediate_bin
    
    machine_code = "0" + index_bin + immediate_bin + rd_bin
    return machine_code

def convert_r4(line):
    i = 0
    ins = ""
    rd = ""
    rs1 = ""
    rs2 = ""
    rs3 = ""

    while(line[i] != ' '):
        ins = ins + line[i]
        i = i+1
    
    j = 0
    while(i < len(line)-1):
        if(line[i] == '$'):
            if j==0:
                j += 1
                rd = rd + line[i+1]
                if line[i+2].isnumeric():
                    rd = rd + line[i+2]
            elif j==1:
                j += 1
                rs2 = rs2 + line[i+1]
                if line[i+2].isnumeric():
                    rs2 = rs2 + line[i+2]
            elif j==2:
                j += 1
                rs3 = rs3 + line[i+1]
                if line[i+2].isnumeric():
                    rs3 = rs3 + line[i+2]
            elif j==3:
                j += 1
                if (i+1)==len(line)-1:
                    rs1 = rs1 + line[i+1]
                else:
                    rs1 = rs1 + line[i+1] + line[i+2]
        i += 1
    
    rd_bin = bin(int(rd))[2:]
    while(len(rd_bin) < 5):
        rd_bin = "0" + rd_bin
    rs2_bin = bin(int(rs2))[2:]
    while(len(rs2_bin) < 5):
        rs2_bin = "0" + rs2_bin
    rs3_bin = bin(int(rs3))[2:]
    while(len(rs3_bin) < 5):
        rs3_bin = "0" + rs3_bin
    rs1_bin = bin(int(rs1))[2:]
    while(len(rs1_bin) < 5):
        rs1_bin = "0" + rs1_bin
    
    if ins=="imal":
        opc = "000"
    elif ins=="imah":
        opc = "001"
    elif ins=="imsl":
        opc = "010"
    elif ins=="imsh":
        opc = "011"
    elif ins=="lmal":
        opc = "100"
    elif ins=="lmah":
        opc = "101"
    elif ins=="lmsl":
        opc = "110"
    else:
        opc = "111"

    machine_code = "10" + opc + rs3_bin + rs2_bin + rs1_bin + rd_bin
    return machine_code

def convert_r3(line):
    i = 0
    ins = ""
    rd = ""
    rs1 = ""
    rs2 = ""

    if(line[0:3] == "nop"):
        rd = "0"
        rs1 = "0"
        rs2 = "0"
    else:
        while(line[i] != ' '):
            ins = ins + line[i]
            i = i+1

    if(ins=="cnt1h" or ins=="bcw" or ins=="invb"):
        j = 0
        while(i < len(line)-1):
            if(line[i] == '$'):
                if j==0:
                    j += 1
                    rd = rd + line[i+1]
                    if line[i+2].isnumeric():
                        rd = rd + line[i+2]
                elif j==1:
                    j += 1
                    if (i+1)==len(line)-1:
                        rs1 = rs1 + line[i+1]
                    else:
                        rs1 = rs1 + line[i+1] + line[i+2]
            i += 1
        rs2 = "0"
    
    else:
        j = 0
        while(i < len(line)-1):
            if(line[i] == '$'):
                if j==0:
                    j += 1
                    rd = rd + line[i+1]
                    if line[i+2].isnumeric():
                        rd = rd + line[i+2]
                elif j==1:
                    j += 1
                    rs1 = rs1 + line[i+1]
                    if line[i+2].isnumeric():
                        rs1 = rs1 + line[i+2]
                elif j==2:
                    j += 1
                    if (i+1)==len(line)-1:
                        rs2 = rs2 + line[i+1]
                    else:
                        rs2 = rs2 + line[i+1] + line[i+2]
            i += 1

    print(f"rd is {rd}")
    print(f"rs1 is {rs1}")
    print(f"rs2 is {rs2}")
    rd_bin = bin(int(rd))[2:]
    while(len(rd_bin) < 5):
        rd_bin = "0" + rd_bin
    rs1_bin = bin(int(rs1))[2:]
    while(len(rs1_bin) < 5):
        rs1_bin = "0" + rs1_bin
    rs2_bin = bin(int(rs2))[2:]
    while(len(rs2_bin) < 5):
        rs2_bin = "0" + rs2_bin
    
    if ins=="shrhi":
        opc = "0001"
    elif ins=="au":
        opc = "0010"
    elif ins=="cnt1h":
        opc = "0011"
    elif ins=="ahs":
        opc = "0100"
    elif ins=="or":
        opc = "0101"
    elif ins=="bcw":
        opc = "0110"
    elif ins=="maxws":
        opc = "0111"
    elif ins=="minws":
        opc = "1000"
    elif ins=="mlhu":
        opc = "1001"
    elif ins=="mlhss":
        opc = "1010"
    elif ins=="and":
        opc = "1011"
    elif ins=="invb":
        opc = "1100"
    elif ins=="rotw":
        opc = "1101"
    elif ins=="sfwu":
        opc = "1110"
    elif ins=="sfhs":
        opc = "1111"
    else:
        opc = "0000"
    
    machine_code = "11" + "0000" + opc + rs2_bin + rs1_bin + rd_bin
    return machine_code


asm = open("C:/Users/haora/Desktop/asm.txt", "r")
instructions_lines = asm.readlines()
asm.close()

instructions = open("C:/Users/haora/Desktop/instructions.txt", "w")

for line in instructions_lines:
    mc = convert(line)
    instructions.write(mc)
    instructions.write("\n")

instructions.close()