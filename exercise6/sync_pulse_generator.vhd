library ieee;
use ieee.std_logic_1164.all;

entity sync_pulse_generator is
  generic(
  G_H_PIXEL_NUMBER : integer := 800;
  G_H_RESOLUTION : integer := 640;
  G_H_FRONT_PORCH : integer := 16;
  G_H_BACK_PORCH : integer := 16;
  G_H_SYNC_LENGTH : integer := 96;
  G_H_SYNC_ACTIVE : integer := 1;
  G_V_ROW_NUMBER : integer := 525;
  G_V_RESOLUTION : integer := 480;
  G_V_FRONT_PORCH : integer := 10;
  G_V_BACK_PORCH : integer := 33;
  G_V_SYNC_LENGTH : integer := 2;
  G_V_SYNC_ACTIVE : integer := 1
  );
  port (
  clk : in std_logic;
  reset : in std_logic;
  o_h_sync : out std_logic := '1';
  o_v_sync : out std_logic := '1';
  o_in_active_region : out std_logic
  );
end entity;

architecture beh of sync_pulse_generator is
  signal pixel_counter : std_logic_vector(12 downto 0) := x"001";
  signal row_counter : std_logic_vector(12 downto 0) := x"001";
  signal v_video_active : std_logic := '0';

  constant C_H_FRONT_PORCH_END : integer := G_H_FRONT_PORCH;
  constant C_H_SYNC_END : integer := C_H_FRONT_PORCH_END + G_H_SYNC_LENGTH;
  constant C_H_BACK_PORCH_END : integer := C_H_SYNC_END + G_H_BACK_PORCH;

  constant C_V_FRONT_PORCH_END : integer := G_V_FRONT_PORCH;
  constant C_V_SYNC_END : integer := C_V_FRONT_PORCH_END + G_V_SYNC_LENGTH;
  constant C_V_BACK_PORCH_END : integer := C_V_SYNC_END + G_V_BACK_PORCH;

begin

gen_sync_proc : process(clk)
begin
  if rising_edge(clk) then
    if reset = '1' then
      o_h_sync = not G_H_SYNC_ACTIVE;
      o_v_sync = not G_V_SYNC_ACTIVE;
      o_in_active_region = 0;
      row_fsm <= FRONT_PORCH;
      col_fsm <= FRONT_PORCH;
      pixel_counter <= x"001";
      row_counter <= x"001";
    else
      pixel_counter <= std_logic_vector(unsigned(pixel_counter)+1);
      if unsigned(pixel_counter) = C_H_FRONT_PORCH_END then
        o_h_sync = G_H_SYNC_ACTIVE;
      end if;
      if unsigned(pixel_counter) = C_H_SYNC_END then
        o_h_sync = not G_H_SYNC_ACTIVE;
      end if;
      if unsigned(pixel_counter) = C_H_BACK_PORCH_END then
        o_in_active_region <= '1' and v_video_active;
      end if;
      if unsigned(pixel_counter) = G_H_PIXEL_NUMBER then
        pixel_counter <= x"001";
        o_in_active_region <= '0';
        row_counter <= std_logic_vector(unsigned(row_counter)+1);
        if unsigned(row_counter) = C_V_FRONT_PORCH_END then
          o_v_sync <= G_V_SYNC_ACTIVE;
        end if;
        if unsigned(row_counter) = C_V_SYNC_END then
          o_v_sync <= not G_V_SYNC_ACTIVE;
        end if;
        if unsigned(row_counter) = C_V_BACK_PORCH_END then
          v_video_active <= '1';
        end if;
        if unsigned(row_counter) = G_V_ROW_NUMBER then
          row_counter <= x"001";
          v_video_active <= '0';
        end if;
      end if;
    end if;
  end if;
end process;
end architecture;
