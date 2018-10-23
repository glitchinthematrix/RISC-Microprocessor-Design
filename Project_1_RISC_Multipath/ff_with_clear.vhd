library ieee;
use ieee.std_logic_1164.all;

entity ff_with_clear is
  port (D, CLEAR, EN, CLK: in std_logic; Q: out std_logic);
end entity;

architecture ff_with_clear_arch of T2 is
signal temp: std_logic;
begin

   process (CLK, CLEAR, EN)
   begin
	 if CLK'event and (CLK = '1') then
      if(EN==1) then
        temp <=D;
	     Q <= temp and (not CLEAR);
     else
      Q <= temp;
	 end if;
   end process;

end ff_with_clear_arch;
