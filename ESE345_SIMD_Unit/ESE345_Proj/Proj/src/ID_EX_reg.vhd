library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ID_EX_reg is
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
end entity ID_EX_reg;

architecture Behavioral of ID_EX_reg is
    signal reg_r1_data      : std_logic_vector(127 downto 0) := (others => '0');
    signal reg_r2_data      : std_logic_vector(127 downto 0) := (others => '0');
    signal reg_r3_data      : std_logic_vector(127 downto 0) := (others => '0');
    signal reg_instruction  : std_logic_vector(24 downto 0) := (others => '0');
    signal reg_r1_index     : std_logic_vector(4 downto 0) := (others => '0');
    signal reg_r2_index     : std_logic_vector(4 downto 0) := (others => '0');
    signal reg_r3_index     : std_logic_vector(4 downto 0) := (others => '0');
    signal reg_w1_index     : std_logic_vector(4 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            reg_r1_data     <= (others => '0');
            reg_r2_data     <= (others => '0');
            reg_r3_data     <= (others => '0');
            reg_instruction <= (others => '0');
            reg_r1_index    <= (others => '0');
            reg_r2_index    <= (others => '0');
            reg_r3_index    <= (others => '0');
            reg_w1_index    <= (others => '0');
        elsif rising_edge(clk) then
            reg_r1_data     <= r1_data;
            reg_r2_data     <= r2_data;
            reg_r3_data     <= r3_data;
            reg_instruction <= instruction;
            reg_r1_index    <= r1_index;
            reg_r2_index    <= r2_index;
            reg_r3_index    <= r3_index;
            reg_w1_index    <= w1_index;
        end if;
    end process;

    r1_data_out      <= reg_r1_data;
    r2_data_out      <= reg_r2_data;
    r3_data_out      <= reg_r3_data;
    r1_index_out     <= reg_r1_index;
    r2_index_out     <= reg_r2_index;
    r3_index_out     <= reg_r3_index;
    w1_index_out     <= reg_w1_index;
    instruction_out  <= reg_instruction;
end architecture Behavioral;
