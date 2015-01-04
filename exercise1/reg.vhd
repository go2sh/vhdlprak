library ieee;
use ieee.std_logic_1164.all;

entity reg is
  port (
  clk : in std_logic;
  reset : in std_logic;
  i_d : in std_logic;
  o_q : out std_logic
  );
end entity;

architecture rtl of comb_logic is
begin
  reg_proc : process(clock)
  begin
    if rising_edge(clock) then
      if reset = '1' then
        o_q <= '0';
      else
        o_q <= i_q;
      end if;
    end if;
  end process;
end architecture;
