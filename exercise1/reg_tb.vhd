library ieee;
use ieee.std_logic_1164.all;

entity reg_tb is
end entity;

architecture sim of reg_tb is
  signal clock : std_logic := '0';
  signal reset : std_logic := '1';
  signal i_d,o_q : std_logic;
begin

  reg_0 : entity work.reg
  port map (
  clock => clock,
  reset => reset,
  i_d => i_d,
  o_q => o_q
  );

  -- Generate clock
  clock <= not clock after 10 ns;

  -- Stiumulus process
  stimulus : process
  begin
    wait until rising_edge(clock);
    reset <= '0';
    wait until rising_edge(clock);
    i_d <= '1';
    wait until rising_edge(clock);
    i_d <= '0';
    wait until rising_edge(clock);
    i_d <= '1';
    wait until rising_edge(clock);
    reset <= '1';
    exit;
  end process;

end architecture;
