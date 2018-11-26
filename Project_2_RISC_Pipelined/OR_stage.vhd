library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity R7 is
Generic (NUM_BITS : INTEGER := 16);
  port (EN, reset, CLK: in std_logic;
        ip: in std_logic_vector(NUM_BITS-1 downto 0);
        op: out std_logic_vector(NUM_BITS-1 downto 0)
      );
end entity;

architecture reg_arch of R7 is
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
------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity OR_interface_reg is
Generic (NUM_BITS : INTEGER := 100);
  port (EN, reset, CLK: in std_logic;
        ip: in std_logic_vector(NUM_BITS-1 downto 0);
        op: out std_logic_vector(NUM_BITS-1 downto 0)
      );
end entity;

architecture reg_arch of OR_interface_reg is
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

-------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SE9 is
port (
    ip : in std_logic_vector (8 downto 0);
    op : out std_logic_vector (15 downto 0)
  );
end entity SE9;

architecture SignedExtender of SE9 is
begin
  op(8 downto 0) <= ip;
  process(ip)
  begin
  if ip(8) = '1' then
  op(15 downto 9) <= (others=>'1');
  else
  op(15 downto 9) <= (others=>'0');
end if;
end process;
end SignedExtender;

------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SE6 is
port (
    ip : in std_logic_vector (5 downto 0);
    op : out std_logic_vector (15 downto 0)
  );
end entity SE6;

architecture SignedExtender of SE6 is
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

----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity priority_encoder2 is
-- Generic (CLK_BITS : INTEGER := 11)
port (
    ip : in std_logic_vector (7 downto 0);
    op_addr : out std_logic_vector (2 downto 0);
    update : out std_logic_vector (7 downto 0)
  );
end entity priority_encoder2;

architecture PriorityEncoder of priority_encoder2 is
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


entity RegFile is
Generic (NUM_BITS : INTEGER := 16);
port (
    CLK ,reset: in std_logic;
    rf_a1, rf_a2, rf_a3 : in std_logic_vector (2 downto 0);
    rf_d3 : in std_logic_vector(NUM_BITS - 1 downto 0);
    rf_d1, rf_d2 : out std_logic_vector(NUM_BITS - 1 downto 0);
    rf_wr: in std_logic
  );
end entity RegFile;

architecture Register_file of RegFile is


component reg is
Generic (NUM_BITS : INTEGER := 16);
  port (EN, reset, CLK: in std_logic;
        ip: in std_logic_vector(NUM_BITS-1 downto 0);
        op: out std_logic_vector(NUM_BITS-1 downto 0)
      );
end component;


type rin is array(0 to 6) of std_logic_vector(NUM_BITS - 1 downto 0);
signal reg_in,reg_out : rin;
--signal r_in: std_logic_vector(15 downto 0);
signal wr_enable,wr_enable_final: std_logic_vector(6 downto 0);

begin

rf_d1 <= reg_out(to_integer(unsigned(rf_a1)));
rf_d2 <= reg_out(to_integer(unsigned(rf_a2)));

with rf_a3 select
 wr_enable <=   "0000001" when "000",
          "0000010" when "001",
          "0000100" when "010",
          "0001000" when "011",
          "0010000" when "100",
          "0100000" when "101",
          "1000000" when "110",
          "0000000" when others;

  reg_in(0) <= rf_d3;
  reg_in(1) <= rf_d3;
  reg_in(2) <= rf_d3;
  reg_in(3) <= rf_d3;
  reg_in(4) <= rf_d3;
  reg_in(5) <= rf_d3;
  reg_in(6) <= rf_d3;


wr_enable_final(0) <= wr_enable(0) and rf_wr;
wr_enable_final(1) <= wr_enable(1) and rf_wr;
wr_enable_final(2) <= wr_enable(2) and rf_wr;
wr_enable_final(3) <= wr_enable(3) and rf_wr;
wr_enable_final(4) <= wr_enable(4) and rf_wr;
wr_enable_final(5) <= wr_enable(5) and rf_wr;
wr_enable_final(6) <= wr_enable(6) and rf_wr; 

  R : for n in 0 to 6 generate
      Rn: reg port map(EN =>wr_enable_final(n),reset => reset,CLK => CLK,ip=>reg_in(n),op=>reg_out(n));
  end generate R;

end Register_file;

-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_3 is
  port(
      alu_a: in std_logic_vector(15 downto 0);
      alu_b: in std_logic_vector(15 downto 0);
      alu_out: out std_logic_vector(15 downto 0));
end entity;

architecture al of ALU_3 is

begin

  process( alu_a, alu_b)
  variable a_a, a_b : std_logic_vector(15 downto 0);
  variable a_o : std_logic_vector(15 downto 0);
  
   begin
    
    a_a(15 downto 0) := alu_a;
    a_b(15 downto 0) := alu_b;
    a_o := std_logic_vector(unsigned(a_a) + unsigned(a_b));
    alu_out <= a_o(15 downto 0);
  end process;
end architecture al;

---------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity OR_stage is
    port(ID_reg_op: in std_logic_vector (51 downto 0);
    PC_ex,alu2_out_mem,memd_out,PC_mem,left_shifted,alu2_forward,memd_forward,EX_reg_op_ALU2,mem_reg_op_ALU2,mem_reg_memd: in std_logic_vector (15 downto 0);
    memi35_mem,memi911_mem,PE1_dest: in std_logic_vector (2 downto 0);
    nullify_ex,clock,reset,mem_rf_en,nullify_control_OR,PE1_mux_control: in std_logic;
    PE1_ip: in std_logic_vector (7 downto 0); 
    OR_reg_op: out std_logic_vector (99 downto 0);
    PE2_op: out std_logic_vector (7 downto 0);
    RF_d1_mux_control,RF_d2_mux_control: std_logic_vector(2 downto 0);
    ALU3_op,RF_d2_or:out std_logic_vector (15 downto 0)
    );
end entity; 

architecture Behave of OR_stage is

component R7 is
Generic (NUM_BITS : INTEGER := 16);
  port (EN, reset, CLK: in std_logic;
        ip: in std_logic_vector(NUM_BITS-1 downto 0);
        op: out std_logic_vector(NUM_BITS-1 downto 0)
      );
end component;

component OR_interface_reg is
Generic (NUM_BITS : INTEGER := 100);
  port (EN, reset, CLK: in std_logic;
        ip: in std_logic_vector(NUM_BITS-1 downto 0);
        op: out std_logic_vector(NUM_BITS-1 downto 0)
      );
end component;

component SE9 is
port (
    ip : in std_logic_vector (8 downto 0);
    op : out std_logic_vector (15 downto 0)
  );
end component SE9;

component SE6 is
port (
    ip : in std_logic_vector (5 downto 0);
    op : out std_logic_vector (15 downto 0)
  );
end component SE6;

component priority_encoder2 is
-- Generic (CLK_BITS : INTEGER := 11)
port (
    ip : in std_logic_vector (7 downto 0);
    op_addr : out std_logic_vector (2 downto 0);
    update : out std_logic_vector (7 downto 0)
  );
end component priority_encoder2;

component RegFile is
Generic (NUM_BITS : INTEGER := 16);
port (
    CLK ,reset: in std_logic;
    rf_a1, rf_a2, rf_a3 : in std_logic_vector (2 downto 0);
    rf_d3 : in std_logic_vector(NUM_BITS - 1 downto 0);
    rf_d1, rf_d2 : out std_logic_vector(NUM_BITS - 1 downto 0);
    rf_wr: in std_logic
  );
end component RegFile;

component ALU_3 is
  port(
      alu_a: in std_logic_vector(15 downto 0);
      alu_b: in std_logic_vector(15 downto 0);
      alu_out: out std_logic_vector(15 downto 0));
end component;

signal SE6_op,SE9_op,SE_mux_op,RF_D3_sig,alu3_op,R7_op,rf_d1_sig,rf_d2_sig,rf_d1_mux_sig,rf_d2_mux_sig: std_logic_vector (15 downto 0);
signal RF_a3_sig,RF_a2_sig,op_PE2: std_logic_vector (2 downto 0);
signal PE1_mux_op: std_logic_vector(7 downto 0);

begin

a: SE6 port map (ip=>ID_reg_op(25 downto 20),op=>SE6_op);
b: SE9 port map (ip=>ID_reg_op(28 downto 20),op=>SE9_op);
c: ALU_3 port map (alu_a=>SE_mux_op,alu_b=>ID_reg_op(51 downto 36),alu_out=>alu3_op);
d: RegFile port map(CLK => clock, reset=>reset,rf_a1=>ID_reg_op(31 downto 29),rf_a2 => RF_a2_sig, rf_a3 =>RF_a3_sig,rf_d3=>RF_d3_sig,rf_d1=>rf_d1_sig,rf_d2=>rf_d2_sig,rf_wr =>mem_rf_en );
e: R7 port map(EN=>not(nullify_ex),ip=>PC_ex,op=>R7_op);
f: priority_encoder2 port map(ip=>ID_reg_op(7 downto 0), op_addr=>op_PE2, update=> PE2_op);
g: OR_interface_reg port map(EN=>'1',reset=>reset,CLK=>clock,ip(99 downto 84)=>ID_reg_op(51 downto 36),ip(83 downto 68)=>ID_reg_op(35 downto 20),ip(67 downto 52)=>rf_d1_mux_sig,ip(51 downto 34)=>rf_d2_mux_sig,ip(35 downto 20)=>alu3_op,ip(19 downto 9)=>ID_reg_op(19 downto 9),ip(8)=>nullify_control_OR,ip(7 downto 0)=>PE1_mux_op);

RF_d2_or<=rf_d2_sig;
process(ID_reg_op)
begin
if (ID_reg_op(35 downto 32) ="1000") then
  SE_mux_op <= SE9_op;
elsif (ID_reg_op(35 downto 32) ="1100") then
  SE_mux_op <= SE6_op;
else
  SE_mux_op <= SE6_op;
end if;
end process;

process(ID_reg_op,op_PE2)
begin
if (ID_reg_op(35 downto 32) = "0111" and not(ID_reg_op(8))) then
  rf_a2 <= op_PE2;
else
  rf_a2 <= ID_reg_op(28 downto 26);
end if;
end process;

process(ID_reg_op)
begin
if(ID_reg_op(14 downto 13) = "00") then
  RF_a3_sig <= ID_reg_op(25 downto 23);
elsif(ID_reg_op(14 downto 13) = "01") then
  RF_a3_sig <= ID_reg_op(31 downto 29);
elsif(ID_reg_op(14 downto 13) = "10") then
  RF_a3_sig <= PE1_dest;
else
  RF_a3_sig <= ID_reg_op(25 downto 23);
end if;
end process;

process(ID_reg_op)
begin
if (ID_reg_op(12 downto 11) = "00") then
  RF_d3_sig <= left_shifted;
elsif (ID_reg_op(12 downto 11) = "01") then
  RF_d3_sig <= alu2_out_mem; 
elsif (ID_reg_op(12 downto 11) = "10") then
  RF_d3_sig <= PC_mem;
elsif (ID_reg_op(12 downto 11) = "11") then
  RF_d3_sig <= memd_out;
else
  RF_d3_sig <= left_shifted;
end if;
end process;

process( PE1_ip,PE1_mux_control);
    if(PE1_mux_control = '1') then
      PE1_mux_op<=PE1_ip;
    else
      PE1_mux_op<=ID_reg_op(27 downto 20);
    end if;
  end process;

process( RF_d1_mux_control,alu2_forward,memd_forward,rf_d1_sig)
begin
if(RF_d1_mux_control = "000") then
  rf_d1_mux_sig<=rf_d1_sig;
elsif(RF_d1_mux_control = "001") then
  rf_d1_mux_sig<=alu2_forward;
elsif(RF_d1_mux_control = "010") then
  rf_d1_mux_sig<=memd_forward;
elsif(RF_d1_mux_control = "011") then
  rf_d1_mux_sig<=EX_reg_op_ALU2;
elsif(RF_d1_mux_control = "100") then
  rf_d1_mux_sig<=mem_reg_op_ALU2;
elsif(RF_d1_mux_control = "101") then
  rf_d1_mux_sig<=mem_reg_memd;
else
  rf_d1_mux_sig<=rf_d1_sig;
end if;
end process;

process( RF_d2_mux_control,alu2_forward,memd_forward,rf_d2_sig)
begin
if(RF_d2_mux_control = "000") then
  rf_d2_mux_sig<=rf_d2_sig;
elsif(RF_d2_mux_control = "001") then
  rf_d2_mux_sig<=alu2_forward;
elsif(RF_d2_mux_control = "010") then
  rf_d2_mux_sig<=memd_forward;
elsif(RF_d2_mux_control = "011") then
  rf_d2_mux_sig<=EX_reg_op_ALU2;
elsif(RF_d2_mux_control = "100") then
  rf_d2_mux_sig<=mem_reg_op_ALU2;
elsif(RF_d2_mux_control = "101") then
  rf_d2_mux_sig<=mem_reg_memd;
else
  rf_d2_mux_sig<=rf_d2_sig;
end if;
end process;

end Behave;