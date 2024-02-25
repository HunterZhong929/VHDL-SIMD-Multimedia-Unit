architecture Behavioral of Register_File is
  --type Register_Array_Type is array (0 to 31) of std_logic_vector(127 downto 0);
  signal registers : register_set;


begin

    read: process(read1, read2, read3, write,write_data)
    begin
        if write_en = '1' then
            if(read1 = write) then
                read1_data <= write_data;

            else
                 read1_data <= registers(to_integer(unsigned(read1)));

            end if;
            if(read2 = write) then
                read2_data <= write_data; 
            else
                read2_data <= registers(to_integer(unsigned(read2)));
            end if;

            if(read3 = write) then
                read3_data <= write_data;
            else
                read3_data <= registers(to_integer(unsigned(read3)));
            end if;
        end if;

    end process;

  process(clk, rst,write_en)
  begin



    if rst = '1' then
      -- Reset the registers to zeros
      registers <= (others => (others => '0'));
    elsif rising_edge(clk) then



      -- Write data to a register if the write signal is valid
      if write_en = '1' then
        registers(to_integer(unsigned(write))) <= write_data;







      end if;
    end if;
  end process;

  output_to_file:process(reg_content_en, reg_content)
  begin
      if reg_content_en = '1' then
          reg_content <= registers;
    end if;
    end process;

end architecture Behavioral;