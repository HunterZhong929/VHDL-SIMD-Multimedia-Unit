library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; 
use work.all;

entity ALU_TB is
end ALU_TB;

architecture Behavioral of ALU_TB is
    component ALU is
        Port ( 
               instruction : in  std_logic_vector(24 downto 0);
               input1 : in  std_logic_vector(127 downto 0);
               input2 : in  std_logic_vector(127 downto 0);
               input3 : in  std_logic_vector(127 downto 0);
               output : out  std_logic_vector(127 downto 0)
             );
    end component;

    signal instruction : std_logic_vector(24 downto 0);
    signal input1 : std_logic_vector(127 downto 0) := (others => '0');
    signal input2 : std_logic_vector(127 downto 0) := (others => '0');
    signal input3 : std_logic_vector(127 downto 0) := (others => '0');
    signal output : std_logic_vector(127 downto 0);

begin

    uut: ALU port map (
        instruction => instruction,
        input1 => input1,
        input2 => input2,
        input3 => input3,		   
        output => output
    );

    process
    begin
        -- Add testing code here
 --       wait for 10 ns;
        -- Example values for testing
 --       instruction <= "1000000000000000000000000"; 
 --       input1 <= (others => '0');																					   																
--		input2 <= "00000000000000000000000000000111100000000000000000000000000000111100000000000000000000000000011110000000000000000000000000001111";
--		input3 <= "00000000000000000000000000000111100000000000000000000000000000111100000000000000000000000000011110000000000000000000000000001111";
		
		
---------------------------------------------------------------------------------------------------
		input1 <= (others => '0');
		input2 <= (others => '1'); 
		input3 <= (others => '1');



---R4 000
		wait for 10 ns;
		input1 <= (others => '0');
		input2 <= (others => '1'); 
		input3 <= (others => '1');
		
        instruction <= "1000000000000000000000000";
		wait for 10 ns;
		assert (output = "00000000000000000000000000000001000000000000000000000000000000010000000000000000000000000000000100000000000000000000000000000001") 
		report "Error at opcode = R4 000 "& to_string(output) severity warning; 

---R4 001
		--wait for 10 ns;
--		input1 <= (others => '0');
--		input2 <= (others => '1'); 
--		input3 <= (others => '1');
		wait for 10 ns;
		input1 <= (others => '0');
		input2 <= (others => '1'); 
		input3 <= (others => '1');	
        instruction <= "1000100000000000000000000";
		wait for 10 ns;
		assert (output = "00000000000000000000000000000001000000000000000000000000000000010000000000000000000000000000000100000000000000000000000000000001") 
		report "Error at opcode = R4 001 "& to_string(output) severity warning; 
		
---R4 010
		wait for 10 ns;
		input1 <= (others => '0');
		input2 <= (others => '1'); 
		input3 <= (others => '1');	
        instruction <= "1001000000000000000000000"; 
		wait for 10 ns;
		assert (output = "11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111") 
		report "Error at opcode = R4 010 "& to_string(output) severity warning; 
---R4 011
		wait for 10 ns;
		input1 <= (others => '0');
		input2 <= (others => '1'); 
		input3 <= (others => '1');	
        instruction <= "1001100000000000000000000"; 
		wait for 10 ns;
		assert (output = "11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111") 
		report "Error at opcode = R4 011 "& to_string(output) severity warning;
		
---R4 100
		wait for 10 ns;
		input1 <= (others => '0');
		input2 <= (others => '1'); 
		input3 <= (others => '1');	
        instruction <= "1010000000000000000000000"; 
		wait for 10 ns;
		assert (output = "00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001") 
		report "Error at opcode = R4 100 "& to_string(output) severity warning;


---R4 101
		wait for 10 ns;
		input1 <= (others => '0');
		input2 <= (others => '1'); 
		input3 <= (others => '1');	
        instruction <= "1010100000000000000000000"; 
		wait for 10 ns;
		assert (output = "00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001") 
		report "Error at opcode = R4 101 " & to_string(output) severity warning;
---R4 110
		wait for 10 ns;
		input1 <= (others => '0');
		input2 <= (others => '1'); 
		input3 <= (others => '1');	
        instruction <= "1011000000000000000000000"; 
		wait for 10 ns;
		report "Test at opcode = R4 110 "& to_string(output);
		assert (output = "11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111") 
		report "Error at opcode = R4 110 "& to_string(output) severity warning;
		
---R4 111
		wait for 10 ns;
		input1 <= (others => '0');
		input2 <= (others => '1'); 
		input3 <= (others => '1');	
        instruction <= "1011100000000000000000000"; 
		wait for 10 ns;
		report "Test at opcode = R4 111 "& to_string(output);
		assert (output = "11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111") 
		report "Error at opcode = R4 111 "& to_string(output) severity warning;
		
		






				input1 <= (others => '0'); 
		input2 <= (others => '0');	
        instruction <= "1100000000000000000000000";  
		wait for 10 ns;
				   
		input1 <= (others => '1'); 
		input2 <= (others => '0');
        instruction <= "1100000001010000000000000"; 
		wait for 10 ns;
		assert (output(127 downto 0) = "00000000111111110000000011111111000000001111111100000000111111110000000011111111000000001111111100000000111111110000000011111111")	
		report "Error at opcode = 0001, output is " & to_string(output(127 downto 0)) severity warning;
		
		input1 <= "00000000111111110000000011111111000000001111111100000000111111110000000011111111000000001111111100000000111111110000000011111111"; 
		input2 <= "11111111000000001111111100000000111111110000000011111111000000001111111100000000111111110000000011111111000000001111111100000000";
        instruction <= "1100000010000000000000000"; 
		wait for 10 ns;	
		assert (output = "11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111")
		report "Error at opcode = 0010, output is " & to_string(output(127 downto 0)) severity warning;  
					 
		input1 <= (others => '1'); 
		input2 <= (others => '0');	
        instruction <= "1100000011000000000000000";   
		wait for 10 ns;
		assert (output = "00000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000")	
		report "Error at opcode = 0011" severity warning;
			   
		input1 <= "10000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000"; 
		input2 <= "01111111111111110111111111111111011111111111111101111111111111110111111111111111011111111111111101111111111111110111111111111111";
        instruction <= "1100000100000000000000000"; 
		wait for 10 ns;
		assert (output = "11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111") 
		report "Error at opcode = 0100" severity warning; 
		
		input1 <= (others => '1'); 
		input2 <= (others => '0');
        instruction <= "1100000101000000000000000";
		wait for 10 ns;	
		assert (output = "11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111") 
		report "Error at opcode = 0101" severity warning; 
		
        input1 <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111"; 
		input2 <= (others => '0');
		instruction <= "1100000110000000000000000";	
		wait for 10 ns;
		assert (output = "11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111") 
		report "Error at opcode = 0110" severity warning; 
				  
		input1 <= "10000000000000000000000000000000100000000000000000000000000000001000000000000000000000000000000010000000000000000000000000000000"; 
		input2 <= "01111111111111111111111111111111011111111111111111111111111111110111111111111111111111111111111101111111111111111111111111111111";
        instruction <= "1100000111000000000000000"; 	 
		wait for 10 ns;
		assert (output = "01111111111111111111111111111111011111111111111111111111111111110111111111111111111111111111111101111111111111111111111111111111") 
		report "Error at opcode = 0111" severity warning;
			 
		input1 <= "10000000000000000000000000000000100000000000000000000000000000001000000000000000000000000000000010000000000000000000000000000000"; 
		input2 <= "01111111111111111111111111111111011111111111111111111111111111110111111111111111111111111111111101111111111111111111111111111111";
        instruction <= "1100001000000000000000000"; 
		wait for 10 ns;
		assert (output = "10000000000000000000000000000000100000000000000000000000000000001000000000000000000000000000000010000000000000000000000000000000") 
		report "Error at opcode = 1000" severity warning;
		
        input1 <= "00000000000000001000000000000000000000000000000010000000000000000000000000000000100000000000000000000000000000001000000000000000"; 
		input2 <= "00000000000000000000000000000010000000000000000000000000000000100000000000000000000000000000001000000000000000000000000000000010";	
		instruction <= "1100001001000000000000000"; 
		wait for 10 ns;
		assert (output = "00000000000000010000000000000000000000000000000100000000000000000000000000000001000000000000000000000000000000010000000000000000") 
		report "Error at opcode = 1001" severity warning;
							
		input1 <= "01111111111111110111111111111111011111111111111101111111111111110111111111111111011111111111111101111111111111110111111111111111";
		input2 <= "00000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010";
        instruction <= "1100001010000000000000000"; 		 
		wait for 10 ns;
		assert (output = "01111111111111110111111111111111011111111111111101111111111111110111111111111111011111111111111101111111111111110111111111111111") 
		report "Error at opcode = 1010" severity warning;
		
        input1 <= (others => '1'); 
		input2 <= (others => '0');
		instruction <= "1100001011000000000000000";
		wait for 10 ns;
		assert (output = "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000") 
		report "Error at opcode = 1011" severity warning;
		 
		input1 <= (others => '1'); 
		input2 <= (others => '0');
        instruction <= "1100001100000000000000000"; 
		wait for 10 ns;
		assert (output = "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000") 
		report "Error at opcode = 1100" severity warning;
			 
		input1 <= "11111111111111110000000000000000111111111111111100000000000000001111111111111111000000000000000011111111111111110000000000000000"; 
		input2 <= "00000000000000000000000000010000000000000000000000000000000100000000000000000000000000000001000000000000000000000000000000010000";
        instruction <= "1100001101000000000000000";
		wait for 10 ns;
		assert (output = "00000000000000001111111111111111000000000000000011111111111111110000000000000000111111111111111100000000000000001111111111111111") 
		report "Error at opcode = 1101" severity warning;  
				 	
		input1 <= "00000000000000000000000000000001000000000000000000000000000000010000000000000000000000000000000100000000000000000000000000000001";
		input2 <= (others => '0');
        instruction <= "1100001110000000000000000";
		wait for 10 ns;
		assert (output = "11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111") 
		report "Error at opcode = 1110" severity warning;
								   
		input1 <= "01111111111111110111111111111111011111111111111101111111111111110111111111111111011111111111111101111111111111110111111111111111"; 
		input2 <= "11000000000000001100000000000000110000000000000011000000000000001100000000000000110000000000000011000000000000001100000000000000";
        instruction <= "1100001111000000000000000"; 	
		wait for 10 ns;
		assert (output = "10000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000") 
		report "Error at opcode = 1111" severity warning;
		
        wait for 10 ns;
		wait;
    end process;

end Behavioral;