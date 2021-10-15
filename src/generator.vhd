LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;

ENTITY generator IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        firselect                         :   IN    std_logic_vector(1 DOWNTO 0);  -- sfix14_En13
        enb_gen                               :   IN    std_logic;
        write_address_gen                     :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
--      write_enable                      :   OUT   std_logic;
        coeffs_single_out                 :   OUT   std_logic_vector(13 DOWNTO 0)  -- sfix14_En13 [7]
        );
END generator;

architecture rtl of generator is
	signal counter				:std_logic_vector(2 downto 0);
	signal coeffs				:std_logic_vector(97 downto 0); 
	signal hold					:std_logic;
	signal coeffs_temp      :std_logic_vector (97 downto 0);
--	signal firselect_signal :std_logic_vector(1 downto 0);

	
	
begin 
coeffs_assign_process: PROCESS (clk,reset) 
BEGIN
IF reset = '1' THEN
		coeffs	<= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
--IF clk'EVENT AND clk = '1' THEN
ELSIF clk'EVENT AND clk = '1' THEN
CASE firselect IS
--					when "00"	=> coeffs  <= "11111110100110111011111001111110001011110001011100011101111000101111001110111110011111111110100110";
--					--when "01"	=> coeffs  <= "00001101111001001000111110110011101100100001000101000110001110110010000010001111101100001101111001"; --*****
--					when "01"   => coeffs  <= "11111011000010000011100011000100100000000001101100010010010010000000000000111000110011111011000010"; --10KHz FC lowpass coeffs
--					when "10"	=> coeffs  <= "11110111101000101111110010000000100001100001111111001100000010000110001011111100100011110111101000"; --*****
--					when "11"	=> coeffs  <= "00000110011000000111110111101111100110100001000010011101111110011010000001111101111000000110011000"; --*****
--					when others	=> coeffs  <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
--					
					when "00"	=> coeffs  <= "00000101100111111101111011101101101111101001001100010000110110111110101111011110111000000101100111";
					--when "01"	=> coeffs  <= "00001101111001001000111110110011101100100001000101000110001110110010000010001111101100001101111001"; --*****
					when "01"   => coeffs  <= "11111011000010000011100011000100100000000001101100010010010010000000000000111000110011111011000010"; --10KHz FC lowpass coeffs
					when "10"	=> coeffs  <= "11100001101101110011111010110001110101100101100001010010000111010110011100111110101111100001101101"; --*****
					when "11"	=> coeffs  <= "00010110001111001010001111011110100111101001110011000101111010011110100010100011110100010110001111"; --*****
					when others	=> coeffs  <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
					
END CASE;
-- with firselect select
--	coeffs_temp	 <="00000101100111111101111011101101101111101001001100010000110110111110101111011110111000000101100111" when  "00",		--HP
--						"11111011000010000011100011000100100000000001101100010010010010000000000000111000110011111011000010" when  "01",		--LP
--						"11100001101101110011111010110001110101100101100001010010000111010110011100111110101111100001101101" when  "10",		--BP
--						"00010110001111001010001111011110100111101001110011000101111010011110100010100011110100010110001111" when  "11",		--BS
--						"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" when others;
--						coeffs <= coeffs_temp when enb_gen='1' else (others=>'0');
----		firselect_signal <= "00";
--
END IF;
END PROCESS coeffs_assign_process;
  coeffs_generate_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
		counter	<= "000";
     ELSIF clk'EVENT AND clk = '1' THEN
      IF enb_gen = '1' THEN
			IF counter = "111" THEN
				coeffs_single_out <= coeffs(13 DOWNTO 0);
				write_address_gen	<=	"00000" & counter;
--				firselect<=firselect_signal;
				counter <= "000";
			ELSE	
				CASE (counter) IS
					when "000"	=> coeffs_single_out <= coeffs(97 DOWNTO 84);
					when "001"	=> coeffs_single_out <= coeffs(83 DOWNTO 70);
					when "010"	=> coeffs_single_out <= coeffs(69 DOWNTO 56);
					when "011"	=> coeffs_single_out <= coeffs(55 DOWNTO 42);
					when "100"	=> coeffs_single_out <= coeffs(41 DOWNTO 28);
					when "101"	=> coeffs_single_out <= coeffs(27 DOWNTO 14);
					when "110"	=> coeffs_single_out <= coeffs(13 DOWNTO 0);
					when others =>	coeffs_single_out <= "00000000000000";
				END CASE;
				
				write_address_gen	<=	"00000" & counter;
				counter <= std_logic_vector( unsigned(counter) + 1 );
			END IF;
      END IF;
    END IF;
  END PROCESS coeffs_generate_process;
  

END rtl;
						
	
	