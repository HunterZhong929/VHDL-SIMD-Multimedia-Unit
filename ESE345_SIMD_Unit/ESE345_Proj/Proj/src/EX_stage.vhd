library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity EX_stage is
    Port (
        ID_data1        : in std_logic_vector(127 downto 0);
        ID_data2        : in std_logic_vector(127 downto 0);
        ID_data3        : in std_logic_vector(127 downto 0);
        fwd_data        : in std_logic_vector(127 downto 0);
        --data_in_4        : in std_logic_vector(127 downto 0);
        --data_in_5        : in std_logic_vector(127 downto 0);
        sel0  : in std_logic;
        sel1  : in std_logic;
        sel2  : in std_logic;
        instruction      : in std_logic_vector(24 downto 0);
        write_index_in   : in std_logic_vector(4 downto 0);
		
        ALU_out          : out std_logic_vector(127 downto 0);
		instruction_out  : out std_logic_vector(24 downto 0);
        write_index_out  : out std_logic_vector(4 downto 0)
    );
end entity EX_stage;

architecture Behavioral of EX_stage is
signal mux_out0 : std_logic_vector(127 downto 0);
signal mux_out1 : std_logic_vector(127 downto 0);
signal mux_out2 : std_logic_vector(127 downto 0);
signal data_fwd : std_logic_vector(127 downto 0);
    component ALU
        Port ( 
            instruction : in  std_logic_vector(24 downto 0);
            input1      : in  std_logic_vector(127 downto 0);
            input2      : in  std_logic_vector(127 downto 0);
            input3      : in  std_logic_vector(127 downto 0);
            output      : out  std_logic_vector(127 downto 0)
        );
    end component;

    component ALU_mux
        Port (
            ID_r1_data  : in std_logic_vector(127 downto 0);
            EX_r1_data  : in std_logic_vector(127 downto 0);
            ID_r2_data  : in std_logic_vector(127 downto 0);
            EX_r2_data  : in std_logic_vector(127 downto 0);
            ID_r3_data  : in std_logic_vector(127 downto 0);
            EX_r3_data  : in std_logic_vector(127 downto 0);
            ctrl_0      : in std_logic;
            ctrl_1      : in std_logic;
            ctrl_2      : in std_logic;
            data_out_0  : out std_logic_vector(127 downto 0);
            data_out_1  : out std_logic_vector(127 downto 0);
            data_out_2  : out std_logic_vector(127 downto 0)
        );
    end component;
	
begin
    ALU_inst: ALU
        port map (
            instruction => instruction,
            input1      => mux_out0,
            input2      => mux_out1,
            input3      => mux_out2,
            output      => ALU_out
        );

    ALU_mux_inst: ALU_mux
        port map (
            ID_r1_data  => ID_data1,
            EX_r1_data  => data_fwd,
            ID_r2_data  => ID_data2,
            EX_r2_data  => data_fwd,
            ID_r3_data  => ID_data3,
            EX_r3_data  => data_fwd,
            ctrl_0      => sel0,
            ctrl_1      => sel1,
            ctrl_2      => sel2,
            data_out_0  => mux_out0,
            data_out_1  => mux_out1,
            data_out_2  => mux_out2
        );

 
        write_index_out <= write_index_in;
		data_fwd <= fwd_data; --dataforward may be a confusing name here, but the wire is shared
		instruction_out <= instruction;

end Behavioral;
