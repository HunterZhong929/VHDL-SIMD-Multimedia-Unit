library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity EX_WB_reg is
    Port (
        clk           : in std_logic;
        reset         : in std_logic;
        instruction_in  : in std_logic_vector(24 downto 0);
        data_in  : in std_logic_vector(127 downto 0);
		register_out    : out std_logic_vector(4 downto 0);
		instruction_out  : out std_logic_vector(24 downto 0);
        data_out : out std_logic_vector(127 downto 0)
    );
end entity EX_WB_reg;

architecture Behavioral of EX_WB_reg is
signal reg_data  : std_logic_vector(127 downto 0) := (others => '0');
signal reg_index : std_logic_vector(4 downto 0) := (others => '0');
signal instruct  : std_logic_vector(24 downto 0) := (others => '0'); 
begin
    process(clk, reset)
    begin	
        if reset = '1' then
            reg_data <= (others => '0');
			instruct <= (others => '0');-- Clear the register on reset
        elsif rising_edge(clk) then
            instruct <= instruction_in;
           	reg_data <= data_in; -- Write new data on rising edge of the clock when write_enable is asserted
            reg_index <= instruction_in(4 downto 0);
        end if;
    end process;

    data_out <= reg_data;
	register_out <= reg_index;
	instruction_out <= instruct;
end architecture Behavioral;
