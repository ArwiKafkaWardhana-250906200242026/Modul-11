----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2026 12:01:48 PM
-- Design Name: 
-- Module Name: checkerboard_pattern - Behavioral
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

entity checkerboard_pattern is
    Port (
        h_count : in  integer range 0 to 799;
        v_count : in  integer range 0 to 524;
        rgb     : out std_logic_vector(11 downto 0)
    );
end checkerboard_pattern;

architecture Behavioral of checkerboard_pattern is
    signal h_u : unsigned(9 downto 0);
    signal v_u : unsigned(9 downto 0);
begin

    h_u <= to_unsigned(h_count, 10);
    v_u <= to_unsigned(v_count, 10);

    process(h_u, v_u)
    begin
        -- Kombinasi XOR bit ke-5 menghasilkan kotak papan catur 32x32 piksel
        if (h_u(5) xor v_u(5)) = '0' then
            rgb <= x"FFF"; -- Putih
        else
            rgb <= x"00F"; -- Biru
        end if;
    end process;

end Behavioral;