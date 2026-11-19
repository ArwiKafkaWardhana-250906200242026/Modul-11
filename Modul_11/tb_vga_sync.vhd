----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2026 11:28:24 AM
-- Design Name: 
-- Module Name: tb_vga_sync - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_vga_sync is
end tb_vga_sync;

architecture sim of tb_vga_sync is
    constant CLK_PERIOD : time := 40 ns; -- 25 MHz

    signal pclk     : std_logic := '0';
    signal rst      : std_logic := '1';
    signal hsync    : std_logic;
    signal vsync    : std_logic;
    signal video_on : std_logic;
    signal h_count  : integer range 0 to 799;
    signal v_count  : integer range 0 to 524;
begin

    uut : entity work.vga_sync
        port map (
            pclk     => pclk,
            rst      => rst,
            hsync    => hsync,
            vsync    => vsync,
            video_on => video_on,
            h_count  => h_count,
            v_count  => v_count
        );

    -- Bangkitkan clock 25 MHz
    pclk <= not pclk after CLK_PERIOD / 2;

    stim_proc : process
        variable h_low_cycles : integer := 0;
        variable v_low_cycles : integer := 0;
    begin
        -- Reset awal
        rst <= '1';
        wait for 5 * CLK_PERIOD;
        rst <= '0';

        -- Pantau selama 2 frame penuh (2 * 800 * 525 = 840.000 clock)
        for i in 1 to 2 * 800 * 525 loop
            wait until rising_edge(pclk);

            if hsync = '0' then
                h_low_cycles := h_low_cycles + 1;
            elsif h_low_cycles > 0 then
                assert h_low_cycles = 96
                    report "Lebar pulsa hsync tidak sesuai (diharapkan 96 clock)"
                    severity error;
                h_low_cycles := 0;
            end if;

            if vsync = '0' then
                v_low_cycles := v_low_cycles + 1;
            elsif v_low_cycles > 0 then
                assert v_low_cycles = 2 * 800
                    report "Lebar pulsa vsync tidak sesuai (diharapkan 1600 clock / 2 baris)"
                    severity error;
                v_low_cycles := 0;
            end if;
        end loop;

        report "Simulasi 2 frame selesai tanpa error assert." severity note;
        wait;
    end process;

end sim;