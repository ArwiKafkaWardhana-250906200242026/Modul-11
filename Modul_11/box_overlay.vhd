----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2026 12:09:38 PM
-- Design Name: 
-- Module Name: box_overlay - Behavioral
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

entity box_overlay is
    Port (
        h_count : in  integer range 0 to 799;
        v_count : in  integer range 0 to 524;
        sw      : in  std_logic_vector(3 downto 0);
        bg_rgb  : in  std_logic_vector(11 downto 0);
        rgb_out : out std_logic_vector(11 downto 0)
    );
end box_overlay;

architecture Behavioral of box_overlay is
    constant BOX_W : integer := 64;
    constant BOX_H : integer := 64;
    constant BOX_Y : integer := 208; -- posisi vertikal kotak (di sekitar tengah 480)
begin

    process(h_count, v_count, sw, bg_rgb)
        variable sw_val : integer;
        variable box_x  : integer;
        variable in_box : boolean;
    begin
        sw_val := to_integer(unsigned(sw));
        box_x  := sw_val * 36; -- makin besar sw, posisi horizontal makin ke kanan

        in_box := (h_count >= box_x) and (h_count < box_x + BOX_W) and
                  (v_count >= BOX_Y) and (v_count < BOX_Y + BOX_H);

        if in_box then
            rgb_out <= x"F00"; -- Warna kotak: Merah
        else
            rgb_out <= bg_rgb; -- Warna latar (checkerboard / color bar)
        end if;
    end process;

end Behavioral;
