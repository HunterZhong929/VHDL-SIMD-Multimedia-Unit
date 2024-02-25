library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity mux_128bit is
    Port (
		
        data_in_0    : in std_logic_vector(127 downto 0);
        data_in_1    : in std_logic_vector(127 downto 0);
        ctrl         : in std_logic;
        data_out     : out std_logic_vector(127 downto 0)
    );
end entity mux_128bit;

architecture Behavioral of mux_128bit is
begin
    process(data_in_0, data_in_1, ctrl)
    begin
        if ctrl = '0' then
            data_out <= data_in_0;
        else
            data_out <= data_in_1;
         end if;
    end process;
end architecture Behavioral;
