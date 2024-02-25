library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
library work;
use work.all;
use work.Instruction_Buffer_Array.all;

entity Instruction_BufferTB is
end Instruction_BufferTB;

architecture Instruction_BufferTB of Instruction_BufferTB is

  signal instruction_input : instruction_buffer_array;
  signal clk : std_logic := '0';
  signal instruction_out : std_logic_vector(24 downto 0);
  signal load_en_tb :std_logic;
  
  --signal PC_in, PC_out : integer;

  constant CLOCK_PERIOD : time := 10 ns; -- Example clock period (adjust as needed)

  -- Signal for driving load_IB port
  --signal load_IB_signal : instruction_buffer_array; 
  component Instruction_Buffer
    Port (
      clk : in std_logic;
      rst : in std_logic;
	  load_IB: in instruction_buffer_array;
	  load_en: in std_logic;
      IF_ID_Register : out std_logic_vector(24 downto 0)
    );
	end component;

begin

  -- Clock process
  clk_process: process
  begin
    while now < 1000 ns loop
      clk <= not clk;
      wait for CLOCK_PERIOD / 2;
    end loop;  
    wait;
  end process;

  -- Stimulus process
  stimulus_process: process
  begin																  
	load_en_tb <= '1';
    wait for 20 ns; -- Wait for a few cycles before applying inputs
    instruction_input(0) <= "0110010000001111111100110";
    instruction_input(1) <= "1000000101000100000100111";
    instruction_input(2) <= "1100000001010100101101100";
    instruction_input(3) <= "1100000011010000001100100"; 
	

    -- Assign values to load_IB_signal
    --load_IB_signal <= instruction_input;

    wait;
  end process;

  -- Instantiate the UUT
  UUT: entity work.Instruction_Buffer
    port map (
      clk => clk,
      rst => '0',  -- Assuming reset is active low
      --load_IB => load_IB_signal, -- Connect to the separate signal
	  load_IB =>  instruction_input,
	  load_en =>  load_en_tb,
      IF_ID_Register => instruction_out
    );

end Instruction_BufferTB;
