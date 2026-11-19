----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2026 11:55:09 AM
-- Design Name: 
-- Module Name: js11_top - Behavioral
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

entity js11_top is
    Port (
        clk      : in  STD_LOGIC; -- clock 100 MHz Basys 3
        rst      : in  STD_LOGIC; -- tombol reset
        hsync    : out STD_LOGIC;
        vsync    : out STD_LOGIC;
        vgaRed   : out STD_LOGIC_VECTOR(3 downto 0);
        vgaGreen : out STD_LOGIC_VECTOR(3 downto 0);
        vgaBlue  : out STD_LOGIC_VECTOR(3 downto 0)
    );
end js11_top;

architecture Behavioral of js11_top is

    component clk_wiz_0
        port (
            clk_out1 : out STD_LOGIC;
            reset    : in  STD_LOGIC;
            locked   : out STD_LOGIC;
            clk_in1  : in  STD_LOGIC
        );
    end component;

    signal pclk     : STD_LOGIC;
    signal locked   : STD_LOGIC;
    signal video_on : STD_LOGIC;
    signal h_count  : integer range 0 to 799;
    signal v_count  : integer range 0 to 524;
    signal rgb_pat  : std_logic_vector(11 downto 0);
    signal rgb_out  : std_logic_vector(11 downto 0);

begin

    -- 1. Pembangkit pixel clock 25 MHz dari 100 MHz
    u_clk_wiz : clk_wiz_0
        port map (
            clk_out1 => pclk,
            reset    => rst,
            locked   => locked,
            clk_in1  => clk
        );

    -- 2. Pembangkit sinkronisasi VGA 640x480@60Hz
    u_vga_sync : entity work.vga_sync
        port map (
            pclk     => pclk,
            rst      => rst,
            hsync    => hsync,
            vsync    => vsync,
            video_on => video_on,
            h_count  => h_count,
            v_count  => v_count
        );

    -- 3. Pembangkit pola batang warna vertikal
    u_color_bar : entity work.color_bar_pattern
        port map (
            h_count => h_count,
            rgb     => rgb_pat
        );

    -- 4. Paksa RGB menjadi hitam saat di luar area tampilan aktif (video_on = '0')
    rgb_out <= rgb_pat when video_on = '1' else (others => '0');

    -- Pisahkan ke kanal warna 4-bit Basys 3
    vgaRed   <= rgb_out(11 downto 8);
    vgaGreen <= rgb_out(7 downto 4);
    vgaBlue  <= rgb_out(3 downto 0);

end Behavioral;