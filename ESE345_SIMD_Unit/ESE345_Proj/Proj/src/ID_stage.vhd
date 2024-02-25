library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
library work;
use work.all;
use work.register_file_data_types.all;
entity ID_stage is
  Port (
    clk              : in std_logic;
    rst              : in std_logic;
    write_en         : in std_logic;
    input_instruction: in std_logic_vector(24 downto 0);
	write_index_in	 : in std_logic_vector(4 downto 0);
    write_data       : in std_logic_vector(127 downto 0);
	reg_content_en   : in std_logic;
	
    read1_data       : out std_logic_vector(127 downto 0);
    read2_data       : out std_logic_vector(127 downto 0);
    read3_data       : out std_logic_vector(127 downto 0);
	read_index_out1  : out std_logic_vector(4 downto 0);
	read_index_out2  : out std_logic_vector(4 downto 0);
	read_index_out3  : out std_logic_vector(4 downto 0);
	output_instruction : out std_logic_vector(24 downto 0);
	reg_content      : out register_set;
    write_index_out  : out std_logic_vector(4 downto 0)
  );
end entity ID_stage;

architecture Behavioral of ID_stage is
  signal reg_read1_data : std_logic_vector(127 downto 0);
  signal reg_read2_data : std_logic_vector(127 downto 0);
  signal reg_read3_data : std_logic_vector(127 downto 0);
  signal reg_index1: std_logic_vector(4 downto 0);
  signal reg_index2: std_logic_vector(4 downto 0);
  signal reg_index3: std_logic_vector(4 downto 0);

  component Register_File
    Port (
      clk         : in std_logic;
      rst         : in std_logic;
      write_en    : in std_logic;
      read1       : in std_logic_vector(4 downto 0);
      read2       : in std_logic_vector(4 downto 0);
      read3       : in std_logic_vector(4 downto 0);
      write       : in std_logic_vector(4 downto 0);
      write_data  : in std_logic_vector(127 downto 0);
      read1_data  : out std_logic_vector(127 downto 0);
      read2_data  : out std_logic_vector(127 downto 0);
      read3_data  : out std_logic_vector(127 downto 0);
	  reg_content_en: in std_logic;
	  reg_content: out register_set
    );
  end component;

  component Instruction_Decoder
    Port (
      input_instruction : in std_logic_vector(24 downto 0);
      reg_index1        : out std_logic_vector(4 downto 0);
      reg_index2        : out std_logic_vector(4 downto 0);
      reg_index3        : out std_logic_vector(4 downto 0);
      write_index       : out std_logic_vector(4 downto 0)
    );
  end component;

begin
  register_file_instance: Register_File
    port map (
      clk         => clk,
      rst         => rst,
      write_en    => write_en,
      read1       => reg_index1,
      read2       => reg_index2,
      read3       => reg_index3,
      write       => write_index_in,
      write_data  => write_data, -- Connect write_data to the new input
      read1_data  => reg_read1_data,
      read2_data  => reg_read2_data,
      read3_data  => reg_read3_data,
	  reg_content_en => reg_content_en,
	  reg_content => reg_content
	  
    );

  instruction_decoder_instance: Instruction_Decoder
    port map (
      input_instruction => input_instruction,
      reg_index1        => reg_index1,
      reg_index2        => reg_index2,
      reg_index3        => reg_index3,
      write_index       => write_index_out
    );

  -- Output signals
  read1_data      <= reg_read1_data;
  read2_data      <= reg_read2_data;
  read3_data      <= reg_read3_data;
  read_index_out1  <= reg_index1;
  read_index_out2  <= reg_index2;
  read_index_out3  <= reg_index3;
  output_instruction <= input_instruction;

end architecture Behavioral;
