library ieee;
use ieee.std_logic_1164.all;

entity seq_logic is
  port (
  clk : in std_logic;
  reset : in std_logic;
  i_a : in std_logic;
  i_b : in std_logic
  );
end entity;

architecture beh of seq_logic is
  signal o_c,o_q : std_logic;
begin

  com_logic_0 : entity work.comp_logic
  port map (
  i_a => i_a,
  i_b => i_b,
  o_c => o_c
  );

  reg_0 : entity work.reg
  port map (
  clk => clk,
  reset => reset,
  i_d => o_c,
  o_q => o_q
  );

end architecture;
