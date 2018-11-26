library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_2 is
  port(alu_op: in std_logic_vector(1 downto 0);
      alu_a: in std_logic_vector(15 downto 0);
      alu_b: in std_logic_vector(15 downto 0);
      alu_c: out std_logic;
      alu_z: out std_logic;
      alu_out: out std_logic_vector(15 downto 0));
end entity;

architecture al of ALU_2 is

begin

  process(alu_op, alu_a, alu_b)
  variable a_a, a_b : std_logic_vector(16 downto 0);
  variable a_o : std_logic_vector(16 downto 0);
  
	 begin
    
    a_a(15 downto 0) := alu_a;
    a_a(16) := '0';
    a_b(15 downto 0) := alu_b;
    a_b(16) := '0';

	 case (alu_op) is
		when "00" =>
			a_o := std_logic_vector(unsigned(a_a) + unsigned(a_b));
		when "10" =>
			a_o(15 downto 0) := std_logic_vector(unsigned(a_a(15 downto 0)) - unsigned(a_b(15 downto 0)));
			a_o(16) := '0';
		when "01" =>
			a_o(15 downto 0) := a_a(15 downto 0) nand a_b(15 downto 0);
			a_o(16) := '0';
		when others =>
			a_o(16 downto 0) :=  std_logic_vector(unsigned(a_a) + 1);
    end case;
    alu_out <= a_o(15 downto 0);
    alu_c <= a_o(16);
    alu_z <= not (a_o(15) or a_o(14) or a_o(13) or a_o(12) or a_o(11) or a_o(10) or a_o(9) or a_o(8) or a_o(7) or a_o(6) or a_o(5) or a_o(4) or a_o(3) or a_o(2) or a_o(1) or a_o(0));
  end process;
end architecture al;

----------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity priority_encoder1 is
-- Generic (CLK_BITS : INTEGER := 11)
port (
    ip : in std_logic_vector (7 downto 0);
    op_addr : out std_logic_vector (2 downto 0);
    update : out std_logic_vector (7 downto 0)
  );
end entity priority_encoder1;

architecture PriorityEncoder of priority_encoder1 is
begin
process(ip)
  begin
  if ip(0) = '1' then
    op_addr <= "000";
    update(7 downto 1) <= ip(7 downto 1);
    update(0) <= '0';
  elsif ip(1) = '1' then
    op_addr <= "001";
    update(7 downto 2) <= ip(7 downto  2);
    update(1 downto 0) <= "00";
  elsif ip(2) = '1' then
    op_addr <= "010";
    update(7 downto 3) <= ip(7 downto 3);
    update(2 downto 0) <= "000";
  elsif ip(3) = '1' then
    op_addr <= "011";
    update(7 downto 4) <= ip(7 downto 4);
    update(3 downto 0) <= "0000";
  elsif ip(4) = '1' then
    op_addr <= "100";
    update(7 downto 5) <= ip(7 downto 5);
    update(4 downto 0) <= "00000";
  elsif ip(5) = '1' then
    op_addr <= "101";
    update(7 downto 6) <= ip(7 downto 6);
    update(5 downto 0) <= "000000";
  elsif ip(6) = '1' then
    op_addr <= "110";
    update(7) <= ip(7);
    update(6 downto 0) <= "0000000";
  elsif ip(7) = '1' then
    op_addr <= "111";
    update <= "00000000";
  else
   op_addr <= (others => '0');
   update <= (others => '0');
  end if;
end process;
end PriorityEncoder;

---------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX_interface_reg is
Generic (NUM_BITS : INTEGER := 94);
  port (EN, reset, CLK: in std_logic;
        ip: in std_logic_vector(NUM_BITS-1 downto 0);
        op: out std_logic_vector(NUM_BITS-1 downto 0)
      );
end entity;

architecture reg_arch of EX_interface_reg is
begin
reg1 : process(CLK, EN, ip)
begin
  if CLK'event and CLK = '1' then
    if reset = '1' then
      op(NUM_BITS-1 downto 0) <= (others=>'0');
    elsif EN = '1' then
      op <= ip;
    end if;
  end if;
end process;

end reg_arch;

----------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SE6_ex is
port (
    ip : in std_logic_vector (5 downto 0);
    op : out std_logic_vector (15 downto 0)
  );
end entity SE6_ex;

architecture SignedExtender of SE6_ex is
begin
  op(5 downto 0) <= ip;
  --op(15 downto 6) <= ip(5);
  process(ip)
  begin
  if ip(5) = '1' then
  op(15 downto 6) <= (others=>'1');
  else
  op(15 downto 6) <= (others=>'0');
end if;
end process;
end SignedExtender;
---------------------------------------------------------------
entity EX_stage is 
port (OR_reg_op: in std_logic_vector(99 downto 0);
	 flag_z_mux_control,load_flag_z: in std_logic;
	 PE1_op: out std_logic_vector (7 downto 0);
	 nullify_control_ex,reset,clock:in std_logic;
	 EX_reg_op: out std_logic_vector(93 downto 0);
	 alu2_out,PCtoR7: out std_logic_vector(15 downto 0);
	 nullify_ex: out std_logic;

);
end entity;

architecture Behave of EX_stage is
	
	component ALU_2 is
port(alu_op: in std_logic_vector(1 downto 0);
      alu_a: in std_logic_vector(15 downto 0);
      alu_b: in std_logic_vector(15 downto 0);
      alu_c: out std_logic;
      alu_z: out std_logic;
      alu_out: out std_logic_vector(15 downto 0));
end component;

component priority_encoder1 is
-- Generic (CLK_BITS : INTEGER := 11)
port (
    ip : in std_logic_vector (7 downto 0);
    op_addr : out std_logic_vector (2 downto 0);
    update : out std_logic_vector (7 downto 0)
  );
end component priority_encoder1;

component flag_z is
Generic (NUM_BITS : INTEGER := 1);
  port (EN, reset, CLK: in std_logic;
        ip: in std_logic_vector(NUM_BITS-1 downto 0);
        op: out std_logic_vector(NUM_BITS-1 downto 0)
      );
end component;

component flag_c is
Generic (NUM_BITS : INTEGER := 1);
  port (EN, reset, CLK: in std_logic;
        ip: in std_logic_vector(NUM_BITS-1 downto 0);
        op: out std_logic_vector(NUM_BITS-1 downto 0)
      );
end component;

component EX_interface_reg is
Generic (NUM_BITS : INTEGER := 94);
  port (EN, reset, CLK: in std_logic;
        ip: in std_logic_vector(NUM_BITS-1 downto 0);
        op: out std_logic_vector(NUM_BITS-1 downto 0)
      );
end component;

component SE6_ex is
port (
    ip : in std_logic_vector (5 downto 0);
    op : out std_logic_vector (15 downto 0)
  );
end component SE6_ex;

signal alu_a_ip,alu2_out_sig: std_logic_vector,se6_ex_op: std_logic_vector(15 downto 0);
signal alu_flagz_sig, alu_flagc_sig,flagz_mux_op: std_logic;
signal PE1_addr_sig: std_logic_vector(2 downto 0);
signal EX_reg_op_sig: std_logic_vector(99 downto 0);

begin

a: ALU_2 port map(alu_op=>OR_reg_op(17 downto 16),alu_a=>alu_a_ip,alu_b=>OR_reg_op(51 downto 36),alu_c=>alu_flagc_sig,alu_z=>alu_flagz_sig,alu_out=>alu2_out_sig );

b: priority_encoder1 port map (ip=>OR_reg_op(7 downto 0),op_addr=>PE1_addr_sig,update=>PE1_op);

c: SE6_ex port map (ip=>OR_reg_op(73 downto 68),op=>se6_ex_op);

d: EX_interface_reg port map(EN=>'1',CLK=>clock,reset=>reset,ip(93 downto 78)=>OR_reg_op(99 downto 84),ip(77 downto 62)=>OR_reg_op(83 downto 68),ip(53 downto 38)=>alu2_out_sig,ip(37 downto 22)=>OR_reg_op(67 downto 52),ip(21 downto 6)=>OR_reg_op(51 downto 36),ip(5 downto 3)=>PE1_addr_sig,ip(2)=>alu_flagc_sig,ip(1)=>flagz_mux_op,ip(0)=>nullify_control_ex,ip(61 downto 60)=>OR_reg_op(19 downto 18),ip(59 downto 54)=>OR_reg_op(14 downto 9),op=>EX_reg_op_sig);

PCtoR7 <= EX_reg_op_sig(93 downto 78);
nullify_ex <= EX_reg_op_sig(0);
EX_reg_op <= EX_reg_op_sig;

process(OR_reg_op)
begin
if(OR_reg_op(15) = '0') then
 alu_a_ip<=OR_reg_op(67 downto 52);
else
 alu_a_ip<=se6_ex_op;
end if;
end process;

process(flag_z_mux_control)
begin
if(flag_z_mux_control = '1') then
	flagz_mux_op<=alu_flagz_sig;
else
	flagz_mux_op<=load_flag_z;
end if;
end process;
end Behave;	




