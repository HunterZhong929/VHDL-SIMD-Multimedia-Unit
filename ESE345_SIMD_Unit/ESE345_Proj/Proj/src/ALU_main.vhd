library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;



entity ALU is
    Port ( 
           instruction : in  std_logic_vector(24 downto 0);
           input1 : in  std_logic_vector(127 downto 0);
           input2 : in  std_logic_vector(127 downto 0);
           input3 : in  std_logic_vector(127 downto 0);
           output : out  std_logic_vector(127 downto 0)
         );
end ALU;

architecture Behavioral of ALU is
  
	function saturate_value_int(input_val : integer; bit_width : integer) return std_logic_vector is 
        constant int_min_value : integer := -2147483648; -- -2^31
        constant int_max_value : integer := 2147483647;  -- 2^31 - 1
    begin
        -- Check if the value falls below the minimum value
        if input_val < int_min_value then
            return std_logic_vector(to_signed(int_min_value, bit_width)); -- Set the value to the minimum value
        -- Check if the value exceeds the maximum value
        elsif input_val > int_max_value then
            return std_logic_vector(to_signed(int_max_value, bit_width)); -- Set the value to the maximum value
        else
            return std_logic_vector(to_signed(input_val, bit_width)); -- Return the original value
        end if;
    end function saturate_value_int;

begin
    process(instruction,input1,input2,input3)
		variable result_temp : std_logic_vector(127 downto 0);
    	variable operation_type : std_logic_vector(1 downto 0);
    	variable operation_R3 : std_logic_vector(3 downto 0);
    	variable operation_R4 : std_logic_vector(2 downto 0);
		variable temp_rs2, temp_rs3	 : std_logic_vector(15 downto 0);
		variable temp_rs1 : signed(31 downto 0);
		variable long_rs2, long_rs3	 : std_logic_vector(31 downto 0);
		variable long_rs1 : signed(63 downto 0); 	
		
		constant zeroi : signed(31 downto 0) := (others => '0');
		constant zerol : signed(63 downto 0) := (others => '0');   
		constant max_signed_int : signed(31 downto 0) := "01111111111111111111111111111111";
		constant min_signed_int : signed(31 downto 0) := "10000000000000000000000000000000"; 
		constant max_signed_long : signed(63 downto 0) := "0111111111111111111111111111111111111111111111111111111111111111";
		constant min_signed_long : signed(63 downto 0) := "1000000000000000000000000000000000000000000000000000000000000000";
		
		
		variable tmp_3bit : std_logic_vector(2 downto 0);
		variable tmp_reg : std_logic_vector(127 downto 0); 
		variable zero_word : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');  
		variable tmp_4bit : std_logic_vector(3 downto 0);
		variable tmp_int : integer; 
		variable tmp_5bit : std_logic_vector(4 downto 0);
		variable tmp_HW1 : std_logic_vector(15 downto 0);
		variable tmp_HW2 : std_logic_vector(15 downto 0);
		variable tmp_W1 : std_logic_vector(31 downto 0);
		variable tmp_W2	: std_logic_vector(31 downto 0);
	begin
        -- Extract operation type based on the first two bits of the instruction
        operation_type := instruction(24 downto 23);
        -- Extract operation code based on the instruction format
        case operation_type is
            when "00" => -- Load Immediate
			-- Handle the load immediate operation based on the instruction format	
				tmp_reg(127 downto 0) := input1(127 downto 0);
				tmp_3bit(2 downto 0) := instruction(23 downto 21);
				tmp_int := to_integer(unsigned(tmp_3bit));	
				tmp_HW1 := instruction(20 downto 5);
				tmp_reg(16*tmp_int+15 downto 16*tmp_int) := tmp_HW1(15 downto 0);
				result_temp(127 downto 0) := tmp_reg(127 downto 0); 
			
			when "01" => -- Load Immediate
			-- Handle the load immediate operation based on the instruction format	
				tmp_reg(127 downto 0) := input1(127 downto 0);
				tmp_4bit(3 downto 0) := "0" & instruction(23 downto 21);
				tmp_int := to_integer(unsigned(tmp_4bit));	
				tmp_HW1 := instruction(20 downto 5);
				tmp_reg(16*tmp_int+15 downto 16*tmp_int) := tmp_HW1(15 downto 0);
				result_temp(127 downto 0) := tmp_reg(127 downto 0);

            when "10" => -- Operation based on bits 22:20
                operation_R4 := instruction(22 downto 20);
                -- Perform the required operation using the extracted operation code and input data
                case operation_R4 is
                    when "000" =>
                        for i in 0 to 3 loop
                            temp_rs2 := input2((32*i+15) downto (32*i));   
                            temp_rs3 := input3((32*i+15) downto (32*i));   
                            temp_rs1 := signed(temp_rs2) * signed(temp_rs3);
							if (temp_rs1 > zeroi) and (max_signed_int - temp_rs1 < signed(input1(32*i+31 downto 32*i)))	then  
								result_temp(32*i+31 downto 32*i) := std_logic_vector(min_signed_int); 
							elsif(temp_rs1 < zeroi) and (min_signed_int + temp_rs1 > signed(input1(32*i+31 downto 32*i))) then
								result_temp(32*i+31 downto 32*i) := std_logic_vector(max_signed_int);
							else
								result_temp(32*i+31 downto 32*i) := std_logic_vector(signed(input1((32*i+31) downto (32*i))) + temp_rs1);
							end if;
  --                          result_temp(32*i+31 downto 32*i) := std_logic_vector(signed(input1((32*i+31) downto (32*i))) + temp_rs1);
                        end loop;
                    when "001" =>
                        for i in 0 to 3 loop
                            temp_rs2 := input2((32*i+31) downto (32*i+16));   
                            temp_rs3 := input3((32*i+31) downto (32*i+16));   
                            temp_rs1 := signed(temp_rs2) * signed(temp_rs3);
							if (temp_rs1 > zeroi) and (max_signed_int - temp_rs1 < signed(input1(32*i+31 downto 32*i)))	then  
								result_temp(32*i+31 downto 32*i) := std_logic_vector(min_signed_int); 
							elsif(temp_rs1 < zeroi) and (min_signed_int + temp_rs1 > signed(input1(32*i+31 downto 32*i))) then
								result_temp(32*i+31 downto 32*i) := std_logic_vector(max_signed_int);
							else
								result_temp(32*i+31 downto 32*i) := std_logic_vector(signed(input1((32*i+31) downto (32*i))) + temp_rs1);
							end if;
--                            result_temp(32*i+31 downto 32*i) := std_logic_vector(signed(input1((32*i+31) downto (32*i))) + temp_rs1);
                        end loop;
                    when "010" =>
                        for i in 0 to 3 loop
                            temp_rs2 := input2((32*i+15) downto (32*i));   
                            temp_rs3 := input3((32*i+15) downto (32*i));   
                            temp_rs1 := signed(temp_rs2) * signed(temp_rs3);		
							if (temp_rs1 > zeroi) and (min_signed_int + temp_rs1 > signed(input1(32*i+31 downto 32*i)))	then  
								result_temp(32*i+31 downto 32*i) := std_logic_vector(min_signed_int); 
							elsif(temp_rs1 < zeroi) and (max_signed_int - temp_rs1 < signed(input1(32*i+31 downto 32*i))) then
								result_temp(32*i+31 downto 32*i) := std_logic_vector(max_signed_int);
							else
								result_temp(32*i+31 downto 32*i) := std_logic_vector(signed(input1((32*i+31) downto (32*i))) - temp_rs1);
							end if;
                        end loop;
                    when "011" =>
                        for i in 0 to 3 loop
                            temp_rs2 := input2((32*i+31) downto (32*i+16));   
                            temp_rs3 := input3((32*i+31) downto (32*i+16));   
                            temp_rs1 := signed(temp_rs2) * signed(temp_rs3);  
							if (temp_rs1 > zeroi) and (min_signed_int + temp_rs1 > signed(input1(32*i+31 downto 32*i)))	then  
								result_temp(32*i+31 downto 32*i) := std_logic_vector(min_signed_int); 
							elsif(temp_rs1 < zeroi) and (max_signed_int - temp_rs1 < signed(input1(32*i+31 downto 32*i))) then
								result_temp(32*i+31 downto 32*i) := std_logic_vector(max_signed_int);
							else
								result_temp(32*i+31 downto 32*i) := std_logic_vector(signed(input1((32*i+31) downto (32*i))) - temp_rs1);
							end if;
                        end loop;
                    when "100" =>
                        for i in 0 to 1 loop
                            long_rs2 := input2((64*i+31) downto (64*i));   
                            long_rs3 := input3((64*i+31) downto (64*i));   
                            long_rs1 := signed(long_rs2) * signed(long_rs3); 
							if (long_rs1 > zerol) and (max_signed_long - long_rs1 < signed(input1(64*i+63 downto 64*i))) then  
								result_temp(64*i+63 downto 64*i) := std_logic_vector(min_signed_long); 
							elsif(long_rs1 < zerol) and (min_signed_long + long_rs1 > signed(input1(64*i+63 downto 64*i))) then
								result_temp(64*i+63 downto 64*i) := std_logic_vector(max_signed_long);
							else
								result_temp(64*i+63 downto 64*i) := std_logic_vector(signed(input1((64*i+63) downto (64*i))) + long_rs1);
							end if;
                        end loop;
                    when "101" =>
                        for i in 0 to 1 loop
                            long_rs2 := input2((64*i+63) downto (64*i+32));   
                            long_rs3 := input3((64*i+63) downto (64*i+32));   
                            long_rs1 := signed(long_rs2) * signed(long_rs3);
                            if (long_rs1 > zerol) and (max_signed_long - long_rs1 < signed(input1(64*i+63 downto 64*i))) then  
								result_temp(64*i+63 downto 64*i) := std_logic_vector(min_signed_long); 
							elsif(long_rs1 < zerol) and (min_signed_long + long_rs1 > signed(input1(64*i+63 downto 64*i))) then
								result_temp(64*i+63 downto 64*i) := std_logic_vector(max_signed_long);
							else
								result_temp(64*i+63 downto 64*i) := std_logic_vector(signed(input1((64*i+63) downto (64*i))) + long_rs1);
							end if;
                        end loop;
                    when "110" =>
                        for i in 0 to 1 loop
                            long_rs2 := input2((64*i+31) downto (64*i));   
                            long_rs3 := input3((64*i+31) downto (64*i));   
                            long_rs1 := signed(long_rs2) * signed(long_rs3);   
							if (long_rs1 > zerol) and (min_signed_long + long_rs1 > signed(input1(64*i+63 downto 64*i))) then  
								result_temp(64*i+63 downto 64*i) := std_logic_vector(min_signed_long); 
							elsif(long_rs1 < zerol) and (max_signed_long - long_rs1 < signed(input1(64*i+63 downto 64*i))) then
								result_temp(64*i+63 downto 64*i) := std_logic_vector(max_signed_long);
							else
								result_temp(64*i+63 downto 64*i) := std_logic_vector(signed(input1((64*i+63) downto (64*i))) - long_rs1);
							end if;
--                            result_temp(64*i+63 downto 64*i) := saturate_value_int(to_integer(signed(input1((64*i+63) downto (64*i))) - long_rs1), 64);
                        end loop;
                    when "111" =>
                        for i in 0 to 1 loop
                            long_rs2 := input2((64*i+63) downto (64*i+32));   
                            long_rs3 := input3((64*i+63) downto (64*i+32));   
                            long_rs1 := signed(long_rs2) * signed(long_rs3);	  
							if (long_rs1 > zerol) and (min_signed_long + long_rs1 > signed(input1(64*i+63 downto 64*i))) then  
								result_temp(64*i+63 downto 64*i) := std_logic_vector(min_signed_long); 
							elsif(long_rs1 < zerol) and (max_signed_long - long_rs1 < signed(input1(64*i+63 downto 64*i))) then
								result_temp(64*i+63 downto 64*i) := std_logic_vector(max_signed_long);
							else
								result_temp(64*i+63 downto 64*i) := std_logic_vector(signed(input1((64*i+63) downto (64*i))) - long_rs1);
							end if;
--                            result_temp(64*i+63 downto 64*i) := saturate_value_int(to_integer(signed(input1((64*i+63) downto (64*i))) - long_rs1), 64);
                        end loop;
                    when others =>
                        null;
                end case;
            when "11" => -- Operation based on bits 22:15
                operation_R3 := instruction(18 downto 15);
                
				case operation_R3 is 
					when "0000" =>
						null; 
					when "0001" =>
						tmp_4bit := instruction(13 downto 10);
						tmp_int := to_integer(unsigned(tmp_4bit)); 
						if(tmp_int = 0) then
							result_temp(127 downto 0) := input1(127 downto 0);
						else
			 				for i in 0 to 7 loop
								result_temp(16*i+15 downto 16*i) := zero_word(tmp_int-1 downto 0) & input1(16*i+15 downto 16*i+tmp_int);
							end loop;
						end if;
					when "0010" =>
						for i in 0 to 3 loop
							tmp_W1 := input1(32*i+31 downto 32*i);
							tmp_W2 := input2(32*i+31 downto 32*i);   
							result_temp(32*i+31 downto 32*i) := std_logic_vector(unsigned(tmp_W1) + unsigned(tmp_W2));
						end loop;
					when "0011" =>
						for i in 0 to 7 loop 
							tmp_int := 0;
							for j in 0 to 15 loop  
								if(input1(16*i+j) = '1') then
									tmp_int := tmp_int + 1;
								end if;
							end loop;	
							result_temp(16*i+15 downto 16*i) := std_logic_vector(to_unsigned(tmp_int, 16));
						end loop;
					when "0100" => 
						for i in 0 to 7 loop
							tmp_HW1 := input1(16*i+15 downto 16*i);
							tmp_HW2 := input2(16*i+15 downto 16*i);  
							tmp_int := to_integer(signed(tmp_HW1)) + to_integer(signed(tmp_HW2));
							if(tmp_int < -(2**15)) then
								tmp_int := -(2**15);
							elsif(tmp_int >= (2**15)-1) then
								tmp_int := (2**15)-1;
							end if;
							result_temp(16*i+15 downto 16*i) := std_logic_vector(to_signed(tmp_int,16));
						end loop;
					when "0101" => 
						result_temp(127 downto 0) := input1(127 downto 0) or input2(127 downto 0);
					when "0110" =>
						for i in 0 to 3 loop
							result_temp(32*i+31 downto 32*i) := input1(31 downto 0);
						end loop;
					when "0111" =>
						for i in 0 to 3 loop
							tmp_W1 := input1(32*i+31 downto 32*i);
							tmp_W2 := input2(32*i+31 downto 32*i);
							if(signed(tmp_W1) > signed(tmp_W2)) then
								result_temp(32*i+31 downto 32*i) := tmp_W1;
							else
								result_temp(32*i+31 downto 32*i) := tmp_W2; 
							end if;
						end loop;
					when "1000" =>
						for i in 0 to 3 loop
							tmp_W1 := input1(32*i+31 downto 32*i);
							tmp_W2 := input2(32*i+31 downto 32*i);
							if(signed(tmp_W1) < signed(tmp_W2)) then
								result_temp(32*i+31 downto 32*i) := tmp_W1;
							else
								result_temp(32*i+31 downto 32*i) := tmp_W2; 
							end if;
						end loop;
					when "1001" => 
						for i in 0 to 3 loop
							tmp_W1 := zero_word(15 downto 0) & input1(32*i+15 downto 32*i);
							tmp_W2 := zero_word(15 downto 0) & input2(32*i+15 downto 32*i);  
							tmp_int := to_integer(unsigned(tmp_W1) * unsigned(tmp_W2));	 
							result_temp(32*i+31 downto 32*i) := std_logic_vector(to_unsigned(tmp_int,32));
						end loop;  
					when "1010"	=>
						for i in 0 to 7 loop
							tmp_HW1 := input1(16*i+15 downto 16*i);
							tmp_HW2 := input2(16*i+15 downto 16*i);  
							tmp_int := to_integer(signed(tmp_HW1)) * to_integer(signed(tmp_HW2));
							if(tmp_int < -(2**15)) then
								tmp_int := -(2**15);
							elsif(tmp_int >= (2**15)-1) then
								tmp_int := (2**15)-1;
							end if;
							result_temp(16*i+15 downto 16*i) := std_logic_vector(to_signed(tmp_int,16)); 
						end loop;	   
					when "1011" =>
						result_temp(127 downto 0) := input1(127 downto 0) and input2(127 downto 0);
					when "1100" =>
						result_temp(127 downto 0) := not input1(127 downto 0);	
					when "1101" =>
						for i in 0 to 3 loop
							tmp_5bit := input2(32*i+4 downto 32*i);  
							tmp_int := to_integer(unsigned(tmp_5bit));
							if(tmp_int = 0) then
								result_temp(32*i+31 downto 32*i) := input1(32*i+31 downto 32*i);
							else
								result_temp(32*i+31 downto 32*i) := input1(32*i+tmp_int-1 downto 32*i) & input1(32*i+31 downto 32*i+tmp_int);
							end if;
						end loop; 
					when "1110" =>
						for i in 0 to 3 loop
							tmp_W1 := input1(32*i+31 downto 32*i);
							tmp_W2 := input2(32*i+31 downto 32*i);  
							result_temp(32*i+31 downto 32*i) := std_logic_vector(unsigned(tmp_W2) - unsigned(tmp_W1));
						end loop; 
					when "1111" => 
						for i in 0 to 7 loop
							tmp_HW1 := input1(16*i+15 downto 16*i);
							tmp_HW2 := input2(16*i+15 downto 16*i);  
							tmp_int := to_integer(signed(tmp_HW2)) - to_integer(signed(tmp_HW1));
							if(tmp_int < -(2**15)) then
								tmp_int := -(2**15);
							elsif(tmp_int >= (2**15)) then
								tmp_int := (2**15);
							end if;
							result_temp(16*i+15 downto 16*i) := std_logic_vector(to_signed(tmp_int,16));
						end loop;
					when others =>
						null;
				end case;
            when others =>
                null;
        end case;
		output <= result_temp;
    end process;
	
	


end Behavioral;