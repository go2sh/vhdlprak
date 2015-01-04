library ieee;
use ieee.std_logic_1164.all;

entity mealy_fsm is
  clk : in std_logic;
  reset : in std_logic;
  i_a : in std_logic;
  i_b : in std_logic;
  o_c : out std_logic;
  o_d : out std_logic
end entity;

architecture beh of mealy_fsm is
  type fsm_state_type is (STATE_ONE,STATE_TWO,STATE_THREE);
  signal fsm_state : fsm_state_type;
begin
  fsm_proc : process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        o_c <= '0';
        o_d <= '0';
        fsm_state <= STATE_ONE;s
      else
        case fsm_state is
          STATE_ONE =>
          o_c <= '0';
          o_d <= '1';
          fsm_state <= STATE_TWO;

          STATE_TWO =>
          if i_a = '1' and i_b = '1' then
            o_c <= '0';
            o_d <= '1';
            fsm_state <= STATE_THREE;
          end if;
          if i_a = '0' and i_b = '1' then
            o_c <= '0';
            o_d <= '0';
            fsm_state <= STATE_THREE;
          end if;
          o_c <= '1';
          o_d <= '0';

          STATE_THREE =>
          if i_a = '1' and i_b = '0' then
            o_c <= '1';
            o_d <= '1';
            fsm_state <= STATE_ONE;
          end if;
          if i_b = '0' then
            o_c <= '0';
            o_d <= '1';
            fsm_state <= STATE_TWO;
          end if;
          o_c <= '1';
          o_d <= '1';
        end case;
      end if;
    end if;
  end process;
end architecture;
