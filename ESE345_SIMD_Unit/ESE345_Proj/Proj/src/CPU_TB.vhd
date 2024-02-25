library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
library work;
use work.all;
use work.Instruction_Buffer_Array.all;
use work.register_file_data_types.all;



entity CPU_TB is
end CPU_TB;

architecture tb_arch of CPU_TB is
	constant period : time := 1 ns;
    signal clk, rst, load_en_cpu: std_logic := '0';
    signal instruction_input: instruction_buffer_array;
    signal reg_content_en: std_logic;
    signal reg_content: register_set;

    constant CLOCK_PERIOD : time := 10 ns; -- Example clock period (adjust as needed)

begin

    -- Clock process
    clk_process: process
    begin
        while now < 5000 ns loop
            clk <= not clk;
            wait for CLOCK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    TB_CPU_process: process	 
	file input, output: text;
	variable L, reg_line: line;	 
	variable instruction : std_logic_vector(24 downto 0);	-- variable to read the instruction into. read only allows to write to a variable, not a signal
	variable reg : std_logic_vector(127 downto 0);
	variable instruction_num: integer := 0;
	variable errors: integer := 0;
	begin
		-- synchronous reset
		rst <= '1';
		wait for period;
		rst <= '0';
		
		-- load instruction buffer contents
		FILE_OPEN(input, "instructions.txt", READ_MODE); 
		load_en_cpu <= '1';
		while not endfile(input) and instruction_num < 64 loop
			-- read the next instruction and put it in IB_instruction
			readline(input, L);
			read(L, instruction);
			instruction_input(instruction_num) <= instruction; 			  
			
			wait for period;	   								 
			instruction_num := instruction_num + 1;
		end loop;	
		wait for period * 3;
		load_en_cpu <= '0';	
			
		for i in 0 to 9*instruction_num + 3 loop	-- let the PC load through each instruction and let the last instruction go through the pipeline
			-- let the thing do the thing
			wait for period;
		end loop;
		
		
		FILE_OPEN(output, "register_file_results.txt", WRITE_MODE);	 
		
		reg_content_en <= '1';	  
		for i in 0 to 31 loop  
			wait for period;
			reg := reg_content(i);
			write(reg_line, reg);
			writeline(output, reg_line);
			report "Write content: "& to_string(reg);
		end loop;
		reg_content_en <= '0';
		
		std.env.finish;
	end process TB_CPU_process;

    -- Instantiate the CPU unit
    CPU_Instance: entity work.CPU
    port map (
        clk => clk,
        rst => rst,
        load_en_cpu => load_en_cpu,
        instruction_input => instruction_input,
        reg_content_en => reg_content_en,
        reg_content => reg_content
    );

end tb_arch;
