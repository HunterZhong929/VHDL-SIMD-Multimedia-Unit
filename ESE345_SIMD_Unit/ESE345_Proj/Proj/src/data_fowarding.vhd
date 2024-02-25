library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity data_forwarding is
    Port(
        r1          : in std_logic_vector(4 downto 0);
        r2          : in std_logic_vector(4 downto 0);
        r3          : in std_logic_vector(4 downto 0);
        w1          : in std_logic_vector(4 downto 0); 
        instruction : in std_logic_vector(24 downto 0);
		instruction_EX: in std_logic_vector(24 downto 0);
        alu_sel1    : out std_logic;
        alu_sel2    : out std_logic;
        alu_sel3    : out std_logic
    );
end entity data_forwarding;

architecture dataflow of data_forwarding is
begin
--    process(instruction, r1, r2, r3, w1)  
    process(instruction, instruction_EX)
    begin
		if instruction_EX(24 downto 23) = "11" and instruction(18 downto 15) = "0000" then 
			alu_sel1 <= '0';
            alu_sel2 <= '0';
            alu_sel3 <= '0';
		
        elsif instruction(24) = '0' then --and instruction_EX(24) = '0' then
            -- Compare only r1 with w1		
			
			alu_sel1 <= '1' when r1 = w1 else '0';	  
            alu_sel2 <= '0';
            alu_sel3 <= '0';
        elsif instruction(24 downto 23) = "10" then
            -- Compare all three registers with w1
            alu_sel1 <= '1' when r1 = w1 else '0';
            alu_sel2 <= '1' when r2 = w1 else '0';
            alu_sel3 <= '1' when r3 = w1 else '0';
        elsif instruction(24 downto 23) = "11" then
            -- Compare only the first two registers with w1	 
			if instruction(18 downto 15) = "0000" then --nop
				alu_sel1 <= '0';
            	alu_sel2 <= '0';
            	alu_sel3 <= '0';
			elsif instruction(18 downto 15) = ("0001" or "0011" or "0110" or "1100") then --SHRHI, CNT1H, BCW, INVB
				alu_sel1 <= '1' when r1 = w1 else '0';
            	alu_sel2 <= '0';
            	alu_sel3 <= '0'; 
			else
	            alu_sel1 <= '1' when r1 = w1 else '0';
	            alu_sel2 <= '1' when r2 = w1 else '0';
	            alu_sel3 <= '0'; 
			end if;
        else
            -- Handle other cases as needed
            alu_sel1 <= '0';
            alu_sel2 <= '0';
            alu_sel3 <= '0';
        end if;
    end process;
end architecture dataflow;
