library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity IF_ID_reg is
    Port (
        clk           : in std_logic;
        reset         : in std_logic;
        data_in       : in std_logic_vector(24 downto 0);
        
        data_out      : out std_logic_vector(24 downto 0)
    );
end entity IF_ID_reg;

architecture Behavioral of IF_ID_reg is
    signal reg_data : std_logic_vector(24 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            reg_data <= (others => '0'); -- Clear the register on reset
        elsif rising_edge(clk) then
            
           	reg_data <= data_in; -- Write new data on rising edge of the clock when write_enable is asserted
            
        end if;
    end process;

    data_out <= reg_data;
end architecture Behavioral;
