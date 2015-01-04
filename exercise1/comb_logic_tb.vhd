library ieee;
use ieee.std_logic_1164.all;

entity comb_logic_tb is
end entity;

architecture sim of comb_logic_tb is
  signal i_a,i_b,o_c : std_logic := '0';
begin

  comb_logic_0 : entity work.comb_logic
  port map (
    i_a => i_a,
    i_b => i_b,
    o_c => o_c
  );

  stimulus : process
  begin
    wait for 10 ns;
    i_a <= '1';
    wait for 10 ns;
    i_a <= '0';
    i_b <= '1';
    wait for 10 ns;
    i_a <= '1';
    i_b <= '1';
    exit;
  end process;

end architecture;
