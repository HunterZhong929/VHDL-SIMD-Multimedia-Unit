library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

package Instruction_Buffer_Array is
  type instruction_buffer_array is array (0 to 63) of std_logic_vector(24 downto 0);
end package Instruction_Buffer_Array;

package body Instruction_Buffer_Array is
end package body Instruction_Buffer_Array;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.Instruction_Buffer_Array.all; 
entity Instruction_Buffer is
  Port (
    clk : in std_logic;                           -- Clock input
    rst : in std_logic;
	load_IB: in instruction_buffer_array;
	load_en: in std_logic;
	
	-- Reset input
    IF_ID_Register : out std_logic_vector(24 downto 0)
	
	
	-- Output instruction
  );
end entity Instruction_Buffer;

architecture Behavioral of Instruction_Buffer is
   -- Import the package

  signal buffer_array : instruction_buffer_array;	 
  signal pc  : natural range 0 to 63 := 0;
begin
  process(clk, rst)
  begin
    if rst = '1' then
      -- Reset the buffer to zeros
      buffer_array <= (others => (others => '0'));
    elsif rising_edge(clk) then
      -- Fetch the instruction based on the program counter
      IF_ID_Register <= buffer_array(pc);
      
      -- Increment the program counter
      pc <= (pc + 1) mod 64;
    end if;	 
	
	if load_en = '1' then
		buffer_array <= load_IB;
	end if;
  end process;
  
--  init: process(load_en, load_IB)
--  begin
--	  if load_en = '1' then
--		  buffer_array <= load_IB;
--	  end if;
--end process;
end architecture Behavioral;
