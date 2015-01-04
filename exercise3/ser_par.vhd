library ieee;
use ieee.std_logic_1164.all;

entity ser_par is
  port (
  clk : in std_logic;
  ncl : in std_logic;
  reset : in std_logic;
  i_enable : in std_logic;
  i_serial_in : in std_logic;
  o_parallel_out : out std_logic_vector (25 downto 0);
  o_conv_complete : out std_logic
  );
end entity;

architecture beh of ser_par is
  signal shift_reg : std_logic_vector(26 downto 0);
begin
  o_conv_complete <= shift_reg(shift_reg'high);
  o_parallel_out <= shift_reg(25 downto 0);

  shift_reg_pro : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        shift_reg <= (others => '0');
      else
        if i_enable = '1' then
          shift_reg <= shift_reg(25 downto 1) & i_serial_in;
        end if;
      end if;
    end if;
  end process;
end architecture;
