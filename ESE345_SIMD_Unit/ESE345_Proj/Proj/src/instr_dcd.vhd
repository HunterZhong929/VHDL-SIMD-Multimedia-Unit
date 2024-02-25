library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Instruction_Decoder is
    Port (
        input_instruction : in std_logic_vector(24 downto 0);
        reg_index1        : out std_logic_vector(4 downto 0);
        reg_index2        : out std_logic_vector(4 downto 0);
        reg_index3        : out std_logic_vector(4 downto 0);
		write_index		  :	out std_logic_vector(4 downto 0)
    );
end entity Instruction_Decoder;

architecture Behavioral of Instruction_Decoder is
begin
    process(input_instruction)
    begin
        case input_instruction(24 downto 23) is
            when "00" =>
                reg_index1 <= input_instruction(4 downto 0);
                reg_index2 <= (others => '0');
                reg_index3 <= (others => '0');
				write_index <= input_instruction(4 downto 0);
				
            when "01" =>
                reg_index1 <= input_instruction(4 downto 0);
                reg_index2 <= (others => '0');
                reg_index3 <= (others => '0');
				write_index <= input_instruction(4 downto 0);
            when "10" =>
                reg_index3 <= input_instruction(19 downto 15);
                reg_index2 <= input_instruction(14 downto 10);
                reg_index1 <= input_instruction(9 downto 5);
				write_index <= input_instruction(4 downto 0);
				
			when "11" =>
				reg_index2 <= input_instruction(14 downto 10);
                reg_index1 <= input_instruction(9 downto 5);
                reg_index3 <= (others => '0');
				write_index <= input_instruction(4 downto 0);
				
				
            when others =>
                reg_index1 <= (others => '0');
                reg_index2 <= (others => '0');
                reg_index3 <= (others => '0');
				write_index <= input_instruction(4 downto 0);
        end case;
    end process;
end architecture Behavioral;
