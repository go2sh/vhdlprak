library ieee;
use ieee.std_logic_1164.all;

entity mu is
  port (
  i_a : in std_logic;
  i_b : in std_logic;
  i_c : in std_logic;
  i_s : in std_logic;
  o_a : out std_logic;
  o_b : out std_logic;
  o_c : out std_logic;
  o_s : out std_logic
  );
end entity;

architecture beh of mu is
  signal adder_b : std_logic;
  signal adder_a_xor_b : std_logic;
begin
  -- Intermidiate logic
  adder_b <= i_a and i_b;
  adder_a_xor_b <= i_s xor adder_b;
  -- Ouput logic
  o_a <= i_a;
  o_b <= i_b;
  o_c <= (i_s and adder_b) or (adder_a_xor_b and i_c);
  o_s <= adder_a_xor_b xor i_c;

end architecture;



entity multiplier_4x4 is
  port (
  clk : in std_logic;
  reset : in std_logic;
  i_a : in std_logic_vector (3 downto 0);
  i_b : in std_logic_vector (3 downto 0);
  o_p : out std_logic_vector (7 downto 0)
  );
end entity;

architecture beh of multiplier_4x4 is
  signal a_reg,b_reg : std_logic_vector(3 downto 0);
  signal a_int,c_int : std_logic_vector(0 to 3,4 downto 0);
  signal b_int : std_logic_vector(0 to 4,3 downto 0);
  signal s_int : std_logic_vector(0 to 4,4 downto 0);
begin
  b_int(0) <= b_reg;
  s_int(0) <= (others => '0');
  gen_s_int : for i in 1 to 3 generate
    s_int(i,4) <= c_int(i-1,4);
  end generate;

  gen_c_int : for i in 0 to 3 generate
    c_int(i,0) <= '0';
    a_int(i,0) <= reg_a(i)
  end generate;


  gen_mu_row : for r in 0 to 3 generate
    gen_mu_col : for c in 0 to 3 generate
      mu : entity work.mu
      port map (
      i_a <= a_int(r,c),
      i_b <= b_int(r,c),
      i_c <= c_int(r,c),
      i_s <= s_int(r,c+1),
      o_a <= a_int(r,c+1),
      o_b <= b_int(r+1,c),
      o_c <= c_int(r,c+1),
      o_s <= s_int(r+1,c)
      );
    end generate;
  end generate;

  reg_proc : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        o_p <= (others <= '0');
        a_reg <= (others <= '0');
        b_reg <= (others <= '0');
      else
        o_p <= c_int(3,5) & s_int(4,3 downto 0) & s_int(3,0) & s_int(2,0) & s_int(1,0);
        a_reg <= i_a;
        b_reg <= i_b;
      end if;
    end if;
  end process;
end architecture;
