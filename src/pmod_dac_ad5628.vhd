--------------------------------------------------------------------------------
--
--   FileName:         pmod_dac_ad5628.vhd
--   Dependencies:     spi_master.vhd
--   Design Software:  Quartus Prime Version 17.0.0 Build 595 SJ Lite Edition
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 06/17/2020 Scott Larson
--     Initial Public Release
--    
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY pmod_dac_ad5628 IS
  GENERIC(
    clk_freq    : INTEGER := 50;  --system clock frequency in MHz
--	 d_width : INTEGER := 32; --data bus width
    spi_clk_div : INTEGER := 1);  --spi_clk_div = clk_freq/100 (answer rounded up)
	 
  PORT(
    clk        : IN      STD_LOGIC;                      --system clock
    reset_n    : IN      STD_LOGIC;                      --active low asynchronous reset
    dac_tx_ena : IN      STD_LOGIC;                      --enable transaction with DAC
    dac_cmd    : IN      STD_LOGIC_VECTOR(3 DOWNTO 0);   --command to send to DAC
    dac_addr   : IN      STD_LOGIC_VECTOR(3 DOWNTO 0);   --address to send to DAC
    dac_data   : IN      STD_LOGIC_VECTOR(11 DOWNTO 0);  --data value to send to DAC
    busy       : OUT     STD_LOGIC;                      --indicates when transactions with DAC can be initiated
    mosi       : OUT     STD_LOGIC;                      --SPI bus to DAC: master out, slave in (DIN)
    sclk       : BUFFER  STD_LOGIC;                      --SPI bus to DAC: serial clock (SCLK)
--	 rx_data    : OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0); --data received
--	 spi_tx_data_dac: OUT STD_LOGIC_VECTOR(31 downto 0);
    ss_n       : BUFFER  STD_LOGIC_VECTOR(0 DOWNTO 0));  --SPI bus to DAC: slave select (~SYNC)
END pmod_dac_ad5628;

ARCHITECTURE behavior OF pmod_dac_ad5628 IS
  TYPE machine IS(start, configure, pause, ready, send_data); --needed states
  SIGNAL state         : machine := start;                    --state machine
  SIGNAL spi_busy_prev : STD_LOGIC;                           --previous value of the SPI component's busy signal
  SIGNAL spi_busy      : STD_LOGIC;                           --busy signal from SPI component
  SIGNAL spi_ena       : STD_LOGIC;                           --enable for SPI component
  SIGNAL spi_tx_data   : STD_LOGIC_VECTOR(31 DOWNTO 0);       --transmit data for SPI component

  --declare SPI Master component
  COMPONENT spi_master IS
    GENERIC(
      slaves  : INTEGER := 1;   --number of spi slaves
      d_width : INTEGER := 32); --data bus width
    PORT(
      clock   : IN     STD_LOGIC;                             --system clock
      reset_n : IN     STD_LOGIC;                             --asynchronous reset
      enable  : IN     STD_LOGIC;                             --initiate transaction
      cpol    : IN     STD_LOGIC;                             --spi clock polarity
      cpha    : IN     STD_LOGIC;                             --spi clock phase
      cont    : IN     STD_LOGIC;                             --continuous mode command
      clk_div : IN     INTEGER;                               --system clock cycles per 1/2 period of 
      addr    : IN     INTEGER;                               --address of slave
      tx_data : IN     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit
      miso    : IN     STD_LOGIC;                             --master in, slave out
      sclk    : BUFFER STD_LOGIC;                             --spi clock
      ss_n    : BUFFER STD_LOGIC_VECTOR(slaves-1 DOWNTO 0);   --slave select
      mosi    : OUT    STD_LOGIC;                             --master out, slave in
      busy    : OUT    STD_LOGIC;                             --busy / data ready signal
      rx_data : OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0)); --data received
  END COMPONENT spi_master;

BEGIN

  --instantiate the SPI Master component
  spi_master_0:  spi_master
    GENERIC MAP(slaves => 1, d_width => 32)
    PORT MAP(clock => clk, reset_n => reset_n, enable => spi_ena, cpol => '1', cpha => '0',
             cont => '0', clk_div => spi_clk_div, addr => 0, tx_data => spi_tx_data, miso => '0',
             sclk => sclk, ss_n => ss_n, mosi => mosi, busy => spi_busy, rx_data => open);
       
  PROCESS(clk, reset_n)
    VARIABLE count : INTEGER RANGE 0 TO clk_freq*100 := 0; --counter
  BEGIN
  
    IF(reset_n = '0') THEN              --reset activated
      spi_ena <= '0';                     --clear SPI component enable
      spi_tx_data <= (OTHERS => '0');     --clear SPI component transmit data
      busy <= '1';                        --indication component is unavailable
      state <= start;                     --restart state machine
    ELSIF(clk'EVENT AND clk = '1') THEN --rising edge of system clock

      spi_busy_prev <= spi_busy;          --collect previous spi_busy
   
      CASE state IS                       --state machine

        --entry state, give DAC 100us to power up before communicating
        WHEN start =>
          busy <= '1';                     --component is busy, DAC not yet available
          IF(count < clk_freq*100) THEN    --100us not yet reached
            count := count + 1;              --increment counter
          ELSE                             --100us reached
            count := 0;                      --clear counter
            state <= configure;              --advance to configure the DAC
          END IF;

        --perform SPI transaction to turn on internal voltage reference  
        WHEN configure =>
          IF(spi_busy = '0' AND spi_busy_prev = '0') THEN      --no command sent
            spi_ena <= '1';                                      --enable transaction with DAC
            spi_tx_data <= "00001000000000000000000000000001";   --send data to turn on internal voltage reference
          ELSIF(spi_busy = '1') THEN                           --transaction underway
            spi_ena <= '0';                                      --clear transaction enable
          ELSE                                                 --transaction complete
            state <= pause;                                      --advance to pause state
          END IF;       
          
        --pauses 20ns between SPI transactions
        WHEN pause =>
          IF(count < clk_freq/50) THEN   --less than 20ns
            count := count + 1;            --increment counter
          ELSE                           --20ns has elapsed
            count := 0;                    --clear counter
            busy <= '0';                   --indicate component is ready for a transaction
            state <= ready;                --advance to ready state 
          END IF;
        
        --wait for a new transaction and latch it in
        WHEN ready =>
          IF(dac_tx_ena = '1') THEN                                            --transaction to DAC requested
            spi_tx_data <= "0000" & dac_cmd & dac_addr & dac_data & "00000000";  --latch in data stream to send
            busy <= '1';                                                         --indicate transaction is in progress
            state <= send_data;                                                  --advance to sending transaction
          END IF;

        --performs SPI transaction to DAC  
        WHEN send_data =>
          IF(spi_busy = '0' AND spi_busy_prev = '0') THEN  --transaction not started
            spi_ena <= '1';                                  --enable SPI transaction
          ELSIF(spi_busy = '1') THEN                       --transaction underway
            spi_ena <= '0';                                  --clear enable                            
          ELSE                                             --transaction complete
            state <= pause;                                  --return to pause state
          END IF;

        --default to start state
        WHEN OTHERS => 
          state <= start;

      END CASE;      
    END IF;
  END PROCESS;
--spi_tx_data_dac<=spi_tx_data;  
END behavior;