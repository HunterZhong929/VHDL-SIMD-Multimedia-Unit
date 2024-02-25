library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
library work;
use work.all;
use work.Instruction_Buffer_Array.all;
use work.register_file_data_types.all;
entity CPU is
    Port (
	clk : in std_logic;
	rst : in std_logic;
	load_en_cpu : in std_logic;
	instruction_input : in instruction_buffer_array;
	
	reg_content: out register_set;
	reg_content_en: in std_logic
    );
end entity CPU; 
------------IF-------------
architecture structural of CPU is
signal IF_ID_in  :std_logic_vector(24 downto 0);
signal IF_ID_out :std_logic_vector(24 downto 0);

--------------------ID--------------------------

signal ID_out : std_logic_vector(24 downto 0);
signal read1_data_buffer : std_logic_vector(127 downto 0);
signal read2_data_buffer : std_logic_vector(127 downto 0);
signal read3_data_buffer : std_logic_vector(127 downto 0);
signal read_index_out1_buffer : std_logic_vector(4 downto 0);
signal read_index_out2_buffer : std_logic_vector(4 downto 0);
signal read_index_out3_buffer : std_logic_vector(4 downto 0);
signal write_index_out_buffer : std_logic_vector(4 downto 0);




----------------ID_EX_reg------------------------------------
    signal ID_EX_r1_data: std_logic_vector(127 downto 0);
    signal ID_EX_r2_data : std_logic_vector(127 downto 0);
    signal ID_EX_r3_data : std_logic_vector(127 downto 0);
    signal ID_EX_r1_index : std_logic_vector(4 downto 0);
    signal ID_EX_r2_index : std_logic_vector(4 downto 0);
    signal ID_EX_r3_index : std_logic_vector(4 downto 0);
    signal ID_EX_w1_index: std_logic_vector(4 downto 0);
    signal ID_EX_instruction_out : std_logic_vector(24 downto 0);




-----------------------EX stage wires---------------------

signal ALU_out_buffer : std_logic_vector(127 downto 0);
signal EX_WB_index : std_logic_vector(4 downto 0);
signal EX_instruction_out: std_logic_vector(24 downto 0);



---------data forwarding unit---------------------------- 

signal alu_sel1_buffer : std_logic;
signal alu_sel2_buffer : std_logic;
signal alu_sel3_buffer : std_logic;

-------------------EX_WB_reg------------------------------



signal EX_WB_data_out    : std_logic_vector(127 downto 0);
signal EX_WB_reg_index_out: std_logic_vector(4 downto 0);
signal EX_WB_instruction_out: std_logic_vector(24 downto 0);

--------------write_en-----------------
signal write_en_logic : std_logic;


component Instruction_Buffer
    Port (
      clk : in std_logic;
      rst : in std_logic;
	  load_IB: in instruction_buffer_array;
	  load_en: in std_logic;
      IF_ID_Register : out std_logic_vector(24 downto 0)
	  
    );
end component;

component IF_ID_reg
    Port (
      clk : in std_logic;
      reset : in std_logic;
      data_in : in std_logic_vector(24 downto 0);
      data_out : out std_logic_vector(24 downto 0)
    );
  end component;


component ID_stage
    Port (
      clk              : in std_logic;
      rst              : in std_logic;
      write_en         : in std_logic;
      input_instruction: in std_logic_vector(24 downto 0);
      write_index_in   : in std_logic_vector(4 downto 0);
      write_data       : in std_logic_vector(127 downto 0);
      read1_data       : out std_logic_vector(127 downto 0);
      read2_data       : out std_logic_vector(127 downto 0);
      read3_data       : out std_logic_vector(127 downto 0);
      read_index_out1  : out std_logic_vector(4 downto 0);
      read_index_out2  : out std_logic_vector(4 downto 0);
      read_index_out3  : out std_logic_vector(4 downto 0);
	  output_instruction : out std_logic_vector(24 downto 0);
      write_index_out  : out std_logic_vector(4 downto 0);
	  reg_content_en: in std_logic;
	  reg_content: out register_set
    );
  end component;

component ID_EX_reg
        Port (
            clk            : in std_logic;
            reset          : in std_logic;
            r1_data        : in std_logic_vector(127 downto 0);
            r2_data        : in std_logic_vector(127 downto 0);
            r3_data        : in std_logic_vector(127 downto 0);
            instruction    : in std_logic_vector(24 downto 0);
            r1_index       : in std_logic_vector(4 downto 0);
            r2_index       : in std_logic_vector(4 downto 0);
            r3_index       : in std_logic_vector(4 downto 0);
            w1_index       : in std_logic_vector(4 downto 0);

            r1_data_out    : out std_logic_vector(127 downto 0);
            r2_data_out    : out std_logic_vector(127 downto 0);
            r3_data_out    : out std_logic_vector(127 downto 0);
            r1_index_out   : out std_logic_vector(4 downto 0);
            r2_index_out   : out std_logic_vector(4 downto 0);
            r3_index_out   : out std_logic_vector(4 downto 0);
            w1_index_out   : out std_logic_vector(4 downto 0);
            instruction_out: out std_logic_vector(24 downto 0)
        );
    end component;
  
  
  
   component EX_stage
        Port (
            ID_data1        : in std_logic_vector(127 downto 0);
            ID_data2        : in std_logic_vector(127 downto 0);
            ID_data3        : in std_logic_vector(127 downto 0);
            fwd_data        : in std_logic_vector(127 downto 0);
            sel0            : in std_logic;
            sel1            : in std_logic;
            sel2            : in std_logic;
            instruction     : in std_logic_vector(24 downto 0);
            write_index_in  : in std_logic_vector(4 downto 0);
            ALU_out         : out std_logic_vector(127 downto 0);
			instruction_out : out std_logic_vector(24 downto 0);
            write_index_out : out std_logic_vector(4 downto 0)
        );
   end component;
   
   
   
   
   
   component data_forwarding
        Port(
            r1          : in std_logic_vector(4 downto 0);
            r2          : in std_logic_vector(4 downto 0);
            r3          : in std_logic_vector(4 downto 0);
            w1          : in std_logic_vector(4 downto 0); 
            instruction : in std_logic_vector(24 downto 0);
			instruction_EX : in std_logic_vector(24 downto 0);
            alu_sel1    : out std_logic;
            alu_sel2    : out std_logic;
            alu_sel3    : out std_logic
        );
   end component;
   
   
   component EX_WB_reg
        Port (
            clk           : in std_logic;
            reset         : in std_logic;
            instruction_in: in std_logic_vector(24 downto 0);
            data_in       : in std_logic_vector(127 downto 0);
            register_out  : out std_logic_vector(4 downto 0);
			instruction_out : out std_logic_vector(24 downto 0);
            data_out      : out std_logic_vector(127 downto 0)
        );
    end component;


begin
process(rst, EX_WB_instruction_out)
  begin
    if rst = '1' then
      -- Reset condition
      write_en_logic <= '0';
    else
      -- Your pipeline stage detection logic goes here
      if EX_WB_instruction_out(24 downto 23) = "11" and EX_WB_instruction_out(18 downto 15) = "0000" then --NOP statement
        write_en_logic <= '0';
      else
        write_en_logic <= '1';
      end if;
    end if;
end process;
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	Instruction_Buffer_Instance: Instruction_Buffer
    port map (
      clk => clk,
      rst => rst,				
	  load_en =>  load_en_cpu,
      load_IB => instruction_input,
      IF_ID_Register => IF_ID_in
    );
	
	IF_ID_reg_Instance: IF_ID_reg
    port map (
      clk => clk,
      reset => rst,
      data_in => IF_ID_in,
      data_out => IF_ID_out
    );
	
	ID_stage_Instance: ID_stage
    port map (
      clk               => clk,
      rst               => rst,
      write_en          => write_en_logic,
      input_instruction => IF_ID_out,
      write_index_in    => EX_WB_reg_index_out,
      write_data        => EX_WB_data_out,
	  
	  ----output
      read1_data        => read1_data_buffer,
      read2_data        => read2_data_buffer,
      read3_data        => read3_data_buffer,
      read_index_out1   => read_index_out1_buffer,
      read_index_out2   => read_index_out2_buffer,
      read_index_out3   => read_index_out3_buffer,
      write_index_out   => write_index_out_buffer,
	  output_instruction   => ID_out,
	  
	  reg_content_en => reg_content_en, 
	  reg_content  	=> 	reg_content
    );
	
	
	
	
	
	
	
	ID_EX_reg_Instance: ID_EX_reg
        port map (
            clk            => clk,
            reset          => rst,
            r1_data        => read1_data_buffer,
            r2_data        => read2_data_buffer,
            r3_data        => read3_data_buffer,
            instruction    => ID_out,
            r1_index       => read_index_out1_buffer,
            r2_index       => read_index_out2_buffer,
            r3_index       => read_index_out3_buffer,
            w1_index       => write_index_out_buffer,
			
			
			-----output
            r1_data_out    => ID_EX_r1_data,
            r2_data_out    => ID_EX_r2_data,
            r3_data_out    => ID_EX_r3_data,
            r1_index_out   => ID_EX_r1_index,
            r2_index_out   => ID_EX_r2_index,
            r3_index_out   => ID_EX_r3_index,
            w1_index_out   => ID_EX_w1_index,
            instruction_out => ID_EX_instruction_out
        );
	
	
	
	
	
	
	
	
	EX_stage_Instance: EX_stage
    port map (
			----FROM ID_EX-------------
            ID_data1        => ID_EX_r1_data,
            ID_data2        => ID_EX_r2_data,
            ID_data3        => ID_EX_r3_data,
            instruction     => ID_EX_instruction_out,
			write_index_in  => ID_EX_w1_index,
			fwd_data 		=> EX_WB_data_out,
			
			----FROM data forwarding-----------
            sel0            => alu_sel1_buffer,
            sel1            => alu_sel2_buffer,
            sel2            => alu_sel3_buffer,
            
			----------output
            
            ALU_out         => ALU_out_buffer,
			instruction_out => EX_instruction_out,
            write_index_out => EX_WB_index
        );
	data_forwarding_Instance: data_forwarding
        port map (
            r1          => ID_EX_r1_index,
            r2          => ID_EX_r2_index,
            r3          => ID_EX_r3_index,
            w1          => EX_WB_reg_index_out,
            instruction => ID_EX_instruction_out,
			instruction_EX => EX_WB_instruction_out,
            alu_sel1    => alu_sel1_buffer,
            alu_sel2    => alu_sel2_buffer,
            alu_sel3    => alu_sel3_buffer
        );
		
		
	   EX_WB_reg_Instance: EX_WB_reg
        port map (
            clk            => clk,
            reset          => rst,
            instruction_in => EX_instruction_out,
            data_in        => ALU_out_buffer,
			
			instruction_out => EX_WB_instruction_out,
            register_out    => EX_WB_reg_index_out,
            data_out        => EX_WB_data_out
        );
		
		
		
	
	end structural;