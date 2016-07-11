-----------------------------------------------------------------------------
--! @file
--! @copyright Copyright 2015 GNSS Sensor Ltd. All right reserved.
--! @author    Sergey Khabarov - sergeykhbr@gmail.com
--! @brief  	  Testbench file for the SoC top-level impleemntation
------------------------------------------------------------------------------
--! @details   File was automatically generated by C++ simulation software
------------------------------------------------------------------------------
--! @warning
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
library commonlib;
use commonlib.types_util.all;
library rocketlib;
--use rocketlib.types_rocket.all;
library ddrlib;
use ddrlib.types_ddr.all;

entity rocket_soc_tb is
  constant INCR_TIME : time := 3571 ps;--100 ns;--3571 ps;
end rocket_soc_tb;

architecture behavior of rocket_soc_tb is
   constant EDCL_START_CLK : integer := 1000;
   constant EDCL_WRITE_LEN : integer := 178;
   constant EDCL_WRITE : std_logic_vector(EDCL_WRITE_LEN*4-1 downto 0) := 
   X"5d207098001032badcacefebeb800000e300450000000029bf11000c8a00a00c8a00f07788556600a2ab86000000200100014000000000deef1000deef2000deef3000deef4000deef5000deef6000deef7000deef9701d69f";
   

   constant EDCL_START_CLK2 : integer := 1500;
   constant EDCL_START_CLK3 : integer := 15000;
   constant EDCL_WR_MRESET_LEN : integer := 130;
   -- write 1 to mreset reg:
   constant EDCL_WR_MRESET1 : std_logic_vector(4*EDCL_WR_MRESET_LEN-1 downto 0):= 
   -- idx = 1 
   --X"5d207098001032badcacefebeb80000062004500000000293e11000c8a00a00c8a00f07788556600219673000000604000088087021000000000000000134d4ae5";
   -- edcl_idx = 0
   X"5d207098001032badcacefebeb80000062004500000000293e11000c8a00a00c8a00f077885566002196b3000000204000088087021000000000000000531a1143";
   -- write 0 to mreset reg:
   constant EDCL_WR_MRESET0 : std_logic_vector(4*EDCL_WR_MRESET_LEN-1 downto 0):= 
   X"5d207098001032badcacefebeb80000062004500000000293e11000c8a00a00c8a00f0778855660021a67300000060400008808702000000000000000056997ad3";

  -- input/output signals:
  signal i_rst : std_logic := '1';
  signal i_sclk_p : std_logic;
  signal i_sclk_n : std_logic;
  signal i_clk_adc : std_logic := '0';
  signal i_int_clkrf : std_logic;
  signal i_dip : std_logic_vector(3 downto 1);
  signal o_led : std_logic_vector(7 downto 0);
  signal i_uart1_ctsn : std_logic := '0';
  signal i_uart1_rd : std_logic := '1';
  signal o_uart1_td : std_logic;
  signal o_uart1_rtsn : std_logic;
  
  signal i_gps_ld    : std_logic := '0';--'1';
  signal i_glo_ld    : std_logic := '0';--'1';
  signal o_max_sclk  : std_logic;
  signal o_max_sdata : std_logic;
  signal o_max_ncs   : std_logic_vector(1 downto 0);
  signal i_antext_stat   : std_logic := '0';
  signal i_antext_detect : std_logic := '0';
  signal o_antext_ena    : std_logic;
  signal o_antint_contr  : std_logic;

  signal o_emdc    : std_logic;
  signal io_emdio  : std_logic;
  signal i_rxd  : std_logic_vector(3 downto 0) := "0000";
  signal i_rxdv : std_logic := '0';
  signal o_txd  : std_logic_vector(3 downto 0);
  signal o_txdv : std_logic;

  signal uart_wr_str : std_logic;
  signal uart_instr : string(1 to 256);
  signal uart_busy : std_logic;
  
  signal o_ddr3_reset_n : std_logic;
  signal o_ddr3_phy_init_done : std_logic;
  signal io_ddr3_dq   : std_logic_vector(CFG_DDR_DQ_WIDTH-1 downto 0);
  signal o_ddr3_addr  : std_logic_vector(CFG_DDR_ROW_WIDTH-1 downto 0);
  signal o_ddr3_ba    : std_logic_vector(CFG_DDR_BANK_WIDTH-1 downto 0);
  signal o_ddr3_ras_n : std_logic;
  signal o_ddr3_cas_n : std_logic;
  signal o_ddr3_we_n  : std_logic;
  signal o_ddr3_cs_n    : std_logic_vector((CFG_DDR_CS_WIDTH*CFG_DDR_nCS_PER_RANK)-1 downto 0);
  signal o_ddr3_odt     : std_logic_vector((CFG_DDR_CS_WIDTH*CFG_DDR_nCS_PER_RANK)-1 downto 0);
  signal o_ddr3_cke     : std_logic_vector(CFG_DDR_CKE_WIDTH-1 downto 0);
  signal o_ddr3_dm      : std_logic_vector(CFG_DDR_DM_WIDTH-1 downto 0);
  signal io_ddr3_dqs_p  : std_logic_vector(CFG_DDR_DQS_WIDTH-1 downto 0);
  signal io_ddr3_dqs_n  : std_logic_vector(CFG_DDR_DQS_WIDTH-1 downto 0);
  signal o_ddr3_ck_p    : std_logic_vector(CFG_DDR_CK_WIDTH-1 downto 0);
  signal o_ddr3_ck_n    : std_logic_vector(CFG_DDR_CK_WIDTH-1 downto 0);

  signal adc_cnt : integer := 0;
  signal clk_cur: std_logic := '1';
  signal check_clk_bus : std_logic := '0';
  signal iClkCnt : integer := 0;
  signal iErrCnt : integer := 0;
  signal iErrCheckedCnt : integer := 0;
  signal iEdclCnt : integer := 0;
  signal clk_ref : std_logic := '1';
  
  constant REFCLK_FREQ           : real := 200.0;
  constant REFCLK_HALF_PERIOD : time := (1000000.0/(2.0*REFCLK_FREQ)) * 1 ps;

  
component rocket_soc is port 
( 
  i_rst     : in std_logic; -- button "Center"
  i_sclk_p  : in std_logic;
  i_sclk_n  : in std_logic;
  i_clk_adc : in std_logic;
  i_int_clkrf : in std_logic;
  i_dip     : in std_logic_vector(3 downto 1);
  o_led     : out std_logic_vector(7 downto 0);
  -- uart1
  i_uart1_ctsn : in std_logic;
  i_uart1_rd   : in std_logic;
  o_uart1_td   : out std_logic;
  o_uart1_rtsn : out std_logic;
  -- ADC samples
  i_gps_I  : in std_logic_vector(1 downto 0);
  i_gps_Q  : in std_logic_vector(1 downto 0);
  i_glo_I  : in std_logic_vector(1 downto 0);
  i_glo_Q  : in std_logic_vector(1 downto 0);
  -- rf front-end
  i_gps_ld    : in std_logic;
  i_glo_ld    : in std_logic;
  o_max_sclk  : out std_logic;
  o_max_sdata : out std_logic;
  o_max_ncs   : out std_logic_vector(1 downto 0);
  i_antext_stat   : in std_logic;
  i_antext_detect : in std_logic;
  o_antext_ena    : out std_logic;
  o_antint_contr  : out std_logic;
  i_gmiiclk_p : in    std_ulogic;
  i_gmiiclk_n : in    std_ulogic;
  o_egtx_clk  : out   std_ulogic;
  i_etx_clk   : in    std_ulogic;
  i_erx_clk   : in    std_ulogic;
  i_erxd      : in    std_logic_vector(3 downto 0);
  i_erx_dv    : in    std_ulogic;
  i_erx_er    : in    std_ulogic;
  i_erx_col   : in    std_ulogic;
  i_erx_crs   : in    std_ulogic;
  i_emdint    : in std_ulogic;
  o_etxd      : out   std_logic_vector(3 downto 0);
  o_etx_en    : out   std_ulogic;
  o_etx_er    : out   std_ulogic;
  o_emdc      : out   std_ulogic;
  io_emdio    : inout std_logic;
  o_erstn     : out   std_ulogic;
  --! @name DDR3 signals
  o_ddr3_reset_n  : out std_logic;
  o_ddr3_phy_init_done : out std_logic;
  io_ddr3_dq   : inout std_logic_vector(CFG_DDR_DQ_WIDTH-1 downto 0);
  o_ddr3_addr  : out std_logic_vector(CFG_DDR_ROW_WIDTH-1 downto 0);
  o_ddr3_ba    : out std_logic_vector(CFG_DDR_BANK_WIDTH-1 downto 0);
  o_ddr3_ras_n : out std_logic;
  o_ddr3_cas_n : out std_logic;
  o_ddr3_we_n  : out std_logic;
  o_ddr3_cs_n    : out std_logic_vector((CFG_DDR_CS_WIDTH*CFG_DDR_nCS_PER_RANK)-1 downto 0);
  o_ddr3_odt     : out std_logic_vector((CFG_DDR_CS_WIDTH*CFG_DDR_nCS_PER_RANK)-1 downto 0);
  o_ddr3_cke     : out std_logic_vector(CFG_DDR_CKE_WIDTH-1 downto 0);
  o_ddr3_dm      : out std_logic_vector(CFG_DDR_DM_WIDTH-1 downto 0);
  io_ddr3_dqs_p  : inout std_logic_vector(CFG_DDR_DQS_WIDTH-1 downto 0);
  io_ddr3_dqs_n  : inout std_logic_vector(CFG_DDR_DQS_WIDTH-1 downto 0);
  o_ddr3_ck_p    : out std_logic_vector(CFG_DDR_CK_WIDTH-1 downto 0);
  o_ddr3_ck_n    : out std_logic_vector(CFG_DDR_CK_WIDTH-1 downto 0)
);
end component;

component uart_sim is 
  generic (
    clock_rate : integer := 10
  ); 
  port (
    rst : in std_logic;
    clk : in std_logic;
    wr_str : in std_logic;
    instr : in string;
    td  : in std_logic;
    rtsn : in std_logic;
    rd  : out std_logic;
    ctsn : out std_logic;
    busy : out std_logic
  );
end component;

component ddr_sim is port (
   i_rstn          : in std_logic;
   i_phy_init_done : in std_logic;

   ddr3_dq_fpga : inout std_logic_vector(CFG_DDR_DQ_WIDTH-1 downto 0);
   ddr3_addr_fpga : in std_logic_vector(CFG_DDR_ROW_WIDTH-1 downto 0);
   ddr3_ba_fpga : in std_logic_vector(CFG_DDR_BANK_WIDTH-1 downto 0);
   ddr3_ras_n_fpga : in std_logic;
   ddr3_cas_n_fpga : in std_logic;
   ddr3_we_n_fpga : in std_logic;
   ddr3_cs_n_fpga : in std_logic_vector((CFG_DDR_CS_WIDTH*CFG_DDR_nCS_PER_RANK)-1 downto 0);
   ddr3_odt_fpga : in std_logic_vector((CFG_DDR_CS_WIDTH*CFG_DDR_nCS_PER_RANK)-1 downto 0);
   ddr3_cke_fpga : in std_logic_vector(CFG_DDR_CKE_WIDTH-1 downto 0);
   ddr3_dm_fpga : in std_logic_vector(CFG_DDR_DM_WIDTH-1 downto 0);
   ddr3_dqs_p_fpga : inout std_logic_vector(CFG_DDR_DQS_WIDTH-1 downto 0);
   ddr3_dqs_n_fpga : inout std_logic_vector(CFG_DDR_DQS_WIDTH-1 downto 0);
   ddr3_ck_p_fpga : in std_logic_vector(CFG_DDR_CK_WIDTH-1 downto 0);
   ddr3_ck_n_fpga : in std_logic_vector(CFG_DDR_CK_WIDTH-1 downto 0)
  );
end component;


begin


  -- Process of reading
--  procReadingFile : process
--    variable clk_next: std_logic;
--  begin

--    wait for INCR_TIME;
--    if (adc_cnt + 26000000) >= 70000000 then
--      adc_cnt <= (adc_cnt + 26000000) - 70000000;
--      i_clk_adc <= not i_clk_adc;
--    else
--      adc_cnt <= (adc_cnt + 26000000);
--    end if;

--    while true loop
--      clk_next := not clk_cur;
--      if (clk_next = '1' and clk_cur = '0') then
--        check_clk_bus <= '1';
--      elsif (clk_next = '0' and clk_cur = '1') then
--        if iClkCnt >= EDCL_START_CLK and iClkCnt < (EDCL_START_CLK + EDCL_WRITE_LEN) then
--           i_rxd <= EDCL_WRITE(4*(EDCL_WRITE_LEN - (iClkCnt-EDCL_START_CLK))-1 downto 4*(EDCL_WRITE_LEN - (iClkCnt-EDCL_START_CLK))-4);
--           --i_rxdv <= '1';
--        elsif iClkCnt >= EDCL_START_CLK2 and iClkCnt < (EDCL_START_CLK2 + EDCL_WR_MRESET_LEN) then
--           i_rxd <= EDCL_WR_MRESET1(4*(EDCL_WR_MRESET_LEN - (iClkCnt-EDCL_START_CLK2))-1 downto 4*(EDCL_WR_MRESET_LEN - (iClkCnt-EDCL_START_CLK2))-4);
--           i_rxdv <= '1'; -- RESET CPU
--        elsif iClkCnt >= EDCL_START_CLK3 and iClkCnt < (EDCL_START_CLK3 + EDCL_WR_MRESET_LEN) then
--           i_rxd <= EDCL_WR_MRESET0(4*(EDCL_WR_MRESET_LEN - (iClkCnt-EDCL_START_CLK3))-1 downto 4*(EDCL_WR_MRESET_LEN - (iClkCnt-EDCL_START_CLK3))-4);
--           i_rxdv <= '1'; -- RESET CPU
--        else
--           i_rxd <= "0000";
--           i_rxdv <= '0';
--        end if;
--      end if;

--      wait for 1 ps;
--      check_clk_bus <= '0';
--      clk_cur <= clk_next;

 --     wait for INCR_TIME;
 --     if clk_cur = '1' then
 --       iClkCnt <= iClkCnt + 1;
 --     end if;
 --     if (adc_cnt + 26000000) >= 70000000 then
 --       adc_cnt <= (adc_cnt + 26000000) - 70000000;
 --       i_clk_adc <= not i_clk_adc;
 --     else
 --       adc_cnt <= (adc_cnt + 26000000);
 --     end if;

--    end loop;
--    report "Total clocks checked: " & tost(iErrCheckedCnt) & " Errors: " & tost(iErrCnt);
--    wait for 1 sec;
--  end process procReadingFile;


  --i_sclk_p <= clk_cur;
  --i_sclk_n <= not clk_cur;
  clk_ref <= not clk_ref after (REFCLK_HALF_PERIOD);
  i_sclk_p <= clk_ref;
  i_sclk_n <= not clk_ref;
  
  i_rst <= '0' after 120000 ps;


--  procSignal : process (i_sclk_p, iClkCnt)

--  begin
--    if rising_edge(i_sclk_p) then
      
      --! @note to make sync. reset  of the logic that are clocked by
      --!       htif_clk which is clock/512 by default.
--      if iClkCnt = 15 then
--        i_rst <= '0';
--      end if;
--    end if;
--  end process procSignal;

  i_dip <= "000";
  i_int_clkrf <= '1';

  udatagen0 : process (i_sclk_n, iClkCnt)
  begin
    if rising_edge(i_sclk_n) then
        uart_wr_str <= '0';
        if iClkCnt = 82000 then
           uart_wr_str <= '1';
           uart_instr(1 to 4) <= "ping";
           uart_instr(5) <= cr;
           uart_instr(6) <= lf;
        elsif iClkCnt = 108000 then
           uart_wr_str <= '1';
           uart_instr(1 to 3) <= "pnp";
           uart_instr(4) <= cr;
           uart_instr(5) <= lf;
        end if;
    end if;
  end process;


  uart0 : uart_sim generic map (
    clock_rate => 2*20
  ) port map (
    rst => i_rst,
    clk => i_sclk_p,
    wr_str => uart_wr_str,
    instr => uart_instr,
    td  => o_uart1_td,
    rtsn => o_uart1_rtsn,
    rd  => i_uart1_rd,
    ctsn => i_uart1_ctsn,
    busy => uart_busy
  );

  simd0 : ddr_sim  port map (
   i_rstn          => o_ddr3_reset_n,
   i_phy_init_done => o_ddr3_phy_init_done,

   ddr3_dq_fpga => io_ddr3_dq,
   ddr3_addr_fpga => o_ddr3_addr,
   ddr3_ba_fpga  => o_ddr3_ba,
   ddr3_ras_n_fpga => o_ddr3_ras_n,
   ddr3_cas_n_fpga => o_ddr3_cas_n,
   ddr3_we_n_fpga => o_ddr3_we_n,
   ddr3_cs_n_fpga => o_ddr3_cs_n,
   ddr3_odt_fpga => o_ddr3_odt,
   ddr3_cke_fpga => o_ddr3_cke,
   ddr3_dm_fpga => o_ddr3_dm,
   ddr3_dqs_p_fpga => io_ddr3_dqs_p,
   ddr3_dqs_n_fpga => io_ddr3_dqs_n,
   ddr3_ck_p_fpga => o_ddr3_ck_p,
   ddr3_ck_n_fpga => o_ddr3_ck_n
  );


  -- signal parsment and assignment
  tt : rocket_soc port map
  (
    i_rst     => i_rst,
    i_sclk_p  => i_sclk_p,
    i_sclk_n  => i_sclk_n,
    i_clk_adc => '0',--i_clk_adc,
    i_int_clkrf => i_int_clkrf,
    i_dip     => i_dip,
    o_led     => o_led,
    i_uart1_ctsn => i_uart1_ctsn,
    i_uart1_rd   => i_uart1_rd,
    o_uart1_td   => o_uart1_td,
    o_uart1_rtsn => o_uart1_rtsn,
    i_gps_I  => "01",
    i_gps_Q  => "11",
    i_glo_I  => "11",
    i_glo_Q  => "01",
    i_gps_ld    => i_gps_ld,
    i_glo_ld    => i_glo_ld,
    o_max_sclk  => o_max_sclk,
    o_max_sdata => o_max_sdata,
    o_max_ncs   => o_max_ncs,
    i_antext_stat   => i_antext_stat,
    i_antext_detect => i_antext_detect,
    o_antext_ena    => o_antext_ena,
    o_antint_contr  => o_antint_contr,
    i_gmiiclk_p => '0',
    i_gmiiclk_n => '1',
    o_egtx_clk  => open,
    i_etx_clk   => i_sclk_p,
    i_erx_clk   => i_sclk_p,
    i_erxd      => i_rxd,
    i_erx_dv    => i_rxdv,
    i_erx_er    => '0',
    i_erx_col   => '0',
    i_erx_crs   => '0',
    i_emdint    => '0',
    o_etxd      => o_txd,
    o_etx_en    => o_txdv,
    o_etx_er    => open,
    o_emdc      => o_emdc,
    io_emdio    => io_emdio,
    o_erstn     => open,
    -- DDR3
    o_ddr3_reset_n       => o_ddr3_reset_n,
    o_ddr3_phy_init_done => o_ddr3_phy_init_done,
    io_ddr3_dq      => io_ddr3_dq,
    o_ddr3_addr     => o_ddr3_addr,
    o_ddr3_ba       => o_ddr3_ba,
    o_ddr3_ras_n    => o_ddr3_ras_n,
    o_ddr3_cas_n    => o_ddr3_cas_n,
    o_ddr3_we_n     => o_ddr3_we_n,
    o_ddr3_cs_n     => o_ddr3_cs_n,
    o_ddr3_odt      => o_ddr3_odt,
    o_ddr3_cke      => o_ddr3_cke,
    o_ddr3_dm       => o_ddr3_dm,
    io_ddr3_dqs_p   => io_ddr3_dqs_p,
    io_ddr3_dqs_n   => io_ddr3_dqs_n,
    o_ddr3_ck_p     => o_ddr3_ck_p,
    o_ddr3_ck_n     => o_ddr3_ck_n
 );

  procCheck : process (i_rst, check_clk_bus)
  begin
    if rising_edge(check_clk_bus) then
      if i_rst = '0' then
        iErrCheckedCnt <= iErrCheckedCnt + 1;
      end if;
    end if;
  end process procCheck;

end;
