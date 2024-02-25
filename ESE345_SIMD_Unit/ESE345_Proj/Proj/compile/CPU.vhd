-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : Proj
-- Author      : haoran.yuan@stonybrook.edu
-- Company     : Stony Brook University
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\haora\Desktop\ESE345_Proj\Proj\compile\CPU.vhd
-- Generated   : Sun Dec  3 13:19:22 2023
-- From        : C:\Users\haora\Desktop\ESE345_Proj\Proj\src\CPU.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
-- Design unit header --
library proj;
use proj.Instruction_Buffer_Array.all;
use proj.register_file_data_types.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

entity CPU is
  port(
       clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       load_en_cpu : in STD_LOGIC;
       instruction_input : in instruction_buffer_array(0 to 63);
       reg_content : out register_set;
       reg_content_en : in STD_LOGIC
  );
end CPU;

architecture structural of CPU is

---- Component declarations -----

component data_forwarding
  port(
       r1 : in STD_LOGIC_VECTOR(4 downto 0);
       r2 : in STD_LOGIC_VECTOR(4 downto 0);
       r3 : in STD_LOGIC_VECTOR(4 downto 0);
       w1 : in STD_LOGIC_VECTOR(4 downto 0);
       instruction : in STD_LOGIC_VECTOR(24 downto 0);
       instruction_EX : in STD_LOGIC_VECTOR(24 downto 0);
       alu_sel1 : out STD_LOGIC;
       alu_sel2 : out STD_LOGIC;
       alu_sel3 : out STD_LOGIC
  );
end component;
component EX_stage
  port(
       ID_data1 : in STD_LOGIC_VECTOR(127 downto 0);
       ID_data2 : in STD_LOGIC_VECTOR(127 downto 0);
       ID_data3 : in STD_LOGIC_VECTOR(127 downto 0);
       fwd_data : in STD_LOGIC_VECTOR(127 downto 0);
       sel0 : in STD_LOGIC;
       sel1 : in STD_LOGIC;
       sel2 : in STD_LOGIC;
       instruction : in STD_LOGIC_VECTOR(24 downto 0);
       write_index_in : in STD_LOGIC_VECTOR(4 downto 0);
       ALU_out : out STD_LOGIC_VECTOR(127 downto 0);
       instruction_out : out STD_LOGIC_VECTOR(24 downto 0);
       write_index_out : out STD_LOGIC_VECTOR(4 downto 0)
  );
end component;
component EX_WB_reg
  port(
       clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       instruction_in : in STD_LOGIC_VECTOR(24 downto 0);
       data_in : in STD_LOGIC_VECTOR(127 downto 0);
       register_out : out STD_LOGIC_VECTOR(4 downto 0);
       instruction_out : out STD_LOGIC_VECTOR(24 downto 0);
       data_out : out STD_LOGIC_VECTOR(127 downto 0)
  );
end component;
component ID_EX_reg
  port(
       clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       r1_data : in STD_LOGIC_VECTOR(127 downto 0);
       r2_data : in STD_LOGIC_VECTOR(127 downto 0);
       r3_data : in STD_LOGIC_VECTOR(127 downto 0);
       instruction : in STD_LOGIC_VECTOR(24 downto 0);
       r1_index : in STD_LOGIC_VECTOR(4 downto 0);
       r2_index : in STD_LOGIC_VECTOR(4 downto 0);
       r3_index : in STD_LOGIC_VECTOR(4 downto 0);
       w1_index : in STD_LOGIC_VECTOR(4 downto 0);
       r1_data_out : out STD_LOGIC_VECTOR(127 downto 0);
       r2_data_out : out STD_LOGIC_VECTOR(127 downto 0);
       r3_data_out : out STD_LOGIC_VECTOR(127 downto 0);
       r1_index_out : out STD_LOGIC_VECTOR(4 downto 0);
       r2_index_out : out STD_LOGIC_VECTOR(4 downto 0);
       r3_index_out : out STD_LOGIC_VECTOR(4 downto 0);
       w1_index_out : out STD_LOGIC_VECTOR(4 downto 0);
       instruction_out : out STD_LOGIC_VECTOR(24 downto 0)
  );
end component;
component ID_stage
  port(
       clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       write_en : in STD_LOGIC;
       input_instruction : in STD_LOGIC_VECTOR(24 downto 0);
       write_index_in : in STD_LOGIC_VECTOR(4 downto 0);
       write_data : in STD_LOGIC_VECTOR(127 downto 0);
       reg_content_en : in STD_LOGIC;
       read1_data : out STD_LOGIC_VECTOR(127 downto 0);
       read2_data : out STD_LOGIC_VECTOR(127 downto 0);
       read3_data : out STD_LOGIC_VECTOR(127 downto 0);
       read_index_out1 : out STD_LOGIC_VECTOR(4 downto 0);
       read_index_out2 : out STD_LOGIC_VECTOR(4 downto 0);
       read_index_out3 : out STD_LOGIC_VECTOR(4 downto 0);
       output_instruction : out STD_LOGIC_VECTOR(24 downto 0);
       reg_content : out register_set;
       write_index_out : out STD_LOGIC_VECTOR(4 downto 0)
  );
end component;
component IF_ID_reg
  port(
       clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       data_in : in STD_LOGIC_VECTOR(24 downto 0);
       data_out : out STD_LOGIC_VECTOR(24 downto 0)
  );
end component;
component Instruction_Buffer
  port(
       clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       load_IB : in instruction_buffer_array(0 to 63);
       load_en : in STD_LOGIC;
       IF_ID_Register : out STD_LOGIC_VECTOR(24 downto 0)
  );
end component;

----     Constants     -----
constant DANGLING_INPUT_CONSTANT : STD_LOGIC := 'Z';

---- Signal declarations used on the diagram ----

signal alu_sel1_buffer : STD_LOGIC;
signal alu_sel2_buffer : STD_LOGIC;
signal alu_sel3_buffer : STD_LOGIC;
signal write_en_logic : STD_LOGIC;
signal ALU_out_buffer : STD_LOGIC_VECTOR(127 downto 0);
signal EX_instruction_out : STD_LOGIC_VECTOR(24 downto 0);
signal EX_WB_data_out : STD_LOGIC_VECTOR(127 downto 0);
signal EX_WB_index : STD_LOGIC_VECTOR(4 downto 0);
signal EX_WB_instruction_out : STD_LOGIC_VECTOR(24 downto 0);
signal EX_WB_reg_index_out : STD_LOGIC_VECTOR(4 downto 0);
signal ID_EX_instruction_out : STD_LOGIC_VECTOR(24 downto 0);
signal ID_EX_r1_data : STD_LOGIC_VECTOR(127 downto 0);
signal ID_EX_r1_index : STD_LOGIC_VECTOR(4 downto 0);
signal ID_EX_r2_data : STD_LOGIC_VECTOR(127 downto 0);
signal ID_EX_r2_index : STD_LOGIC_VECTOR(4 downto 0);
signal ID_EX_r3_data : STD_LOGIC_VECTOR(127 downto 0);
signal ID_EX_r3_index : STD_LOGIC_VECTOR(4 downto 0);
signal ID_EX_w1_index : STD_LOGIC_VECTOR(4 downto 0);
signal ID_out : STD_LOGIC_VECTOR(24 downto 0);
signal IF_ID_in : STD_LOGIC_VECTOR(24 downto 0);
signal IF_ID_out : STD_LOGIC_VECTOR(24 downto 0);
signal read1_data_buffer : STD_LOGIC_VECTOR(127 downto 0);
signal read2_data_buffer : STD_LOGIC_VECTOR(127 downto 0);
signal read3_data_buffer : STD_LOGIC_VECTOR(127 downto 0);
signal read_index_out1_buffer : STD_LOGIC_VECTOR(4 downto 0);
signal read_index_out2_buffer : STD_LOGIC_VECTOR(4 downto 0);
signal read_index_out3_buffer : STD_LOGIC_VECTOR(4 downto 0);
signal write_index_out_buffer : STD_LOGIC_VECTOR(4 downto 0);

---- Declaration for Dangling input ----
signal Dangling_Input_Signal : STD_LOGIC;

begin

---- Processes ----

process (rst,EX_WB_instruction_out)
                       begin
                         if rst = '1' then
                            write_en_logic <= '0';
                         else 
                            if EX_WB_instruction_out(24 downto 23) = "11" and EX_WB_instruction_out(18 downto 15) = "0000" then
                               write_en_logic <= '0';
                            else 
                               write_en_logic <= '1';
                            end if;
                         end if;
                       end process;
                      

----  Component instantiations  ----

EX_WB_reg_Instance : EX_WB_reg
  port map(
       clk => clk,
       reset => Dangling_Input_Signal,
       instruction_in => EX_instruction_out,
       data_in => ALU_out_buffer,
       register_out => EX_WB_reg_index_out,
       instruction_out => EX_WB_instruction_out,
       data_out => EX_WB_data_out
  );

EX_stage_Instance : EX_stage
  port map(
       ID_data1 => ID_EX_r1_data,
       ID_data2 => ID_EX_r2_data,
       ID_data3 => ID_EX_r3_data,
       fwd_data => EX_WB_data_out,
       sel0 => alu_sel1_buffer,
       sel1 => alu_sel2_buffer,
       sel2 => alu_sel3_buffer,
       instruction => ID_EX_instruction_out,
       write_index_in => ID_EX_w1_index,
       ALU_out => ALU_out_buffer,
       instruction_out => EX_instruction_out,
       write_index_out => EX_WB_index
  );

ID_EX_reg_Instance : ID_EX_reg
  port map(
       clk => clk,
       reset => Dangling_Input_Signal,
       r1_data => read1_data_buffer,
       r2_data => read2_data_buffer,
       r3_data => read3_data_buffer,
       instruction => ID_out,
       r1_index => read_index_out1_buffer,
       r2_index => read_index_out2_buffer,
       r3_index => read_index_out3_buffer,
       w1_index => write_index_out_buffer,
       r1_data_out => ID_EX_r1_data,
       r2_data_out => ID_EX_r2_data,
       r3_data_out => ID_EX_r3_data,
       r1_index_out => ID_EX_r1_index,
       r2_index_out => ID_EX_r2_index,
       r3_index_out => ID_EX_r3_index,
       w1_index_out => ID_EX_w1_index,
       instruction_out => ID_EX_instruction_out
  );

ID_stage_Instance : ID_stage
  port map(
       clk => clk,
       rst => Dangling_Input_Signal,
       write_en => write_en_logic,
       input_instruction => IF_ID_out,
       write_index_in => EX_WB_reg_index_out,
       write_data => EX_WB_data_out,
       reg_content_en => reg_content_en,
       read1_data => read1_data_buffer,
       read2_data => read2_data_buffer,
       read3_data => read3_data_buffer,
       read_index_out1 => read_index_out1_buffer,
       read_index_out2 => read_index_out2_buffer,
       read_index_out3 => read_index_out3_buffer,
       output_instruction => ID_out,
       reg_content => reg_content,
       write_index_out => write_index_out_buffer
  );

IF_ID_reg_Instance : IF_ID_reg
  port map(
       clk => clk,
       reset => Dangling_Input_Signal,
       data_in => IF_ID_in,
       data_out => IF_ID_out
  );

Instruction_Buffer_Instance : Instruction_Buffer
  port map(
       clk => clk,
       rst => Dangling_Input_Signal,
       load_IB => instruction_input,
       load_en => load_en_cpu,
       IF_ID_Register => IF_ID_in
  );

data_forwarding_Instance : data_forwarding
  port map(
       r1 => ID_EX_r1_index,
       r2 => ID_EX_r2_index,
       r3 => ID_EX_r3_index,
       w1 => EX_WB_index,
       instruction => ID_EX_instruction_out,
       instruction_EX => EX_WB_instruction_out,
       alu_sel1 => alu_sel1_buffer,
       alu_sel2 => alu_sel2_buffer,
       alu_sel3 => alu_sel3_buffer
  );


---- Dangling input signal assignment ----

Dangling_Input_Signal <= DANGLING_INPUT_CONSTANT;

end structural;
