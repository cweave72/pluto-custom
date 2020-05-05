--------------------------------------------------------------------------------
-- File   : system_top.vhd
-- Author : Craig D. Weaver
-- Created: 04-28-2020
--
-- Description: Top level
--
--------------------------------------------------------------------------------
-- Revision history    :
-- 04-28-2020 : cdw
-- Initial coding.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity System_top is
    port(
        Test_Gpio : out std_logic_vector(2 downto 0)
    );
end entity;

architecture rtl of System_top is

    signal Clk     : std_logic;
    signal Reset_n : std_logic;
    signal PL_Gpio : std_logic_vector(5 downto 0);

    component system_wrapper is
      port (
        DDR_addr          : inout STD_LOGIC_VECTOR ( 14 downto 0 );
        DDR_ba            : inout STD_LOGIC_VECTOR ( 2 downto 0 );
        DDR_cas_n         : inout STD_LOGIC;
        DDR_ck_n          : inout STD_LOGIC;
        DDR_ck_p          : inout STD_LOGIC;
        DDR_cke           : inout STD_LOGIC;
        DDR_cs_n          : inout STD_LOGIC;
        DDR_dm            : inout STD_LOGIC_VECTOR ( 1 downto 0 );
        DDR_dq            : inout STD_LOGIC_VECTOR ( 15 downto 0 );
        DDR_dqs_n         : inout STD_LOGIC_VECTOR ( 1 downto 0 );
        DDR_dqs_p         : inout STD_LOGIC_VECTOR ( 1 downto 0 );
        DDR_odt           : inout STD_LOGIC;
        DDR_ras_n         : inout STD_LOGIC;
        DDR_reset_n       : inout STD_LOGIC;
        DDR_we_n          : inout STD_LOGIC;
        FCLK_CLK0         : out STD_LOGIC;
        FCLK_CLK1         : out STD_LOGIC;
        FCLK_RESET0_N     : out STD_LOGIC;
        FCLK_RESET1_N     : out STD_LOGIC;
        FIXED_IO_ddr_vrn  : inout STD_LOGIC;
        FIXED_IO_ddr_vrp  : inout STD_LOGIC;
        FIXED_IO_mio      : inout STD_LOGIC_VECTOR ( 31 downto 0 );
        FIXED_IO_ps_clk   : inout STD_LOGIC;
        FIXED_IO_ps_porb  : inout STD_LOGIC;
        FIXED_IO_ps_srstb : inout STD_LOGIC;
        In0               : in STD_LOGIC_VECTOR ( 0 to 0 );
        gpio_rtl_0_tri_o  : out STD_LOGIC_VECTOR ( 5 downto 0 )
      );
    end component;

begin

    Test_Gpio <= PL_Gpio(2 downto 0);

    U_system_wrapper: system_wrapper
        port map(
            DDR_addr          => open,
            DDR_ba            => open,
            DDR_cas_n         => open,
            DDR_ck_n          => open,
            DDR_ck_p          => open,
            DDR_cke           => open,
            DDR_cs_n          => open,
            DDR_dm            => open,
            DDR_dq            => open,
            DDR_dqs_n         => open,
            DDR_dqs_p         => open,
            DDR_odt           => open,
            DDR_ras_n         => open,
            DDR_reset_n       => open,
            DDR_we_n          => open,
            FCLK_CLK0         => Clk,
            FCLK_CLK1         => open,
            FCLK_RESET0_N     => Reset_n,
            FCLK_RESET1_N     => open,
            FIXED_IO_ddr_vrn  => open,
            FIXED_IO_ddr_vrp  => open,
            FIXED_IO_mio      => open,
            FIXED_IO_ps_clk   => open,
            FIXED_IO_ps_porb  => open,
            FIXED_IO_ps_srstb => open,
            In0               => "0",
            gpio_rtl_0_tri_o  => PL_Gpio
        );

end architecture;
