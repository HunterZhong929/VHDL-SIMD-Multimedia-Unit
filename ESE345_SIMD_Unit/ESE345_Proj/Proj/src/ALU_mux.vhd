library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity ALU_mux is
    Port (
        ID_r1_data  : in std_logic_vector(127 downto 0);
        EX_r1_data  : in std_logic_vector(127 downto 0);
        ID_r2_data  : in std_logic_vector(127 downto 0);
        EX_r2_data  : in std_logic_vector(127 downto 0);
        ID_r3_data  : in std_logic_vector(127 downto 0);
        EX_r3_data  : in std_logic_vector(127 downto 0);
        ctrl_0       : in std_logic;
        ctrl_1       : in std_logic;
        ctrl_2       : in std_logic;
        data_out_0   : out std_logic_vector(127 downto 0);
        data_out_1   : out std_logic_vector(127 downto 0);
        data_out_2   : out std_logic_vector(127 downto 0)
    );
end entity ALU_mux;

architecture Behavioral of ALU_mux is
    signal mux_out_0, mux_out_1, mux_out_2 : std_logic_vector(127 downto 0);
begin
    mux_inst_0: entity work.mux_128bit
        port map (
            data_in_0 => ID_r1_data,
            data_in_1 => EX_r1_data,
            ctrl      => ctrl_0,
            data_out  => mux_out_0
        );

    mux_inst_1: entity work.mux_128bit
        port map (
            data_in_0 => ID_r2_data,
            data_in_1 => EX_r2_data,
            ctrl      => ctrl_1,
            data_out  => mux_out_1
        );

    mux_inst_2: entity work.mux_128bit
        port map (
            data_in_0 => ID_r3_data,
            data_in_1 => EX_r3_data,
            ctrl      => ctrl_2,
            data_out  => mux_out_2
        );

    data_out_0 <= mux_out_0;
    data_out_1 <= mux_out_1;
    data_out_2 <= mux_out_2;
end architecture Behavioral;
