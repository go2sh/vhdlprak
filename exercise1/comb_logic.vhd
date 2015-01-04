library ieee;
use ieee.std_logic_1164.all;

entity comb_logic is
  port (
  i_a : in std_logic;
  i_b : in std_logic;
  o_c : out std_logic
  );
end entity;

architecture rtl of comb_logic is
begin
  o_c <= i_a and ( not i_b);
end architecture;
