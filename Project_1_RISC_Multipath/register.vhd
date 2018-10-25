library ieee;
use ieee.std_logic_1164.all;

entity reg is
Generic (NUM_BITS : INTEGER := 16);
  port (EN, CLK: in std_logic;
        ip: in std_logic_vector(NUM_BITS-1 downto 0);
        op: out std_logic_vector(NUM_BITS-1 downto 0)
		  );
end entity;

architecture reg_arch of reg is
begin
reg1 : process(ip)
begin
  if CLK'event and CLK = '1' then
    if EN = '1' then
      op <= ip;
    end if;
  end if;
end process;

end reg_arch;
