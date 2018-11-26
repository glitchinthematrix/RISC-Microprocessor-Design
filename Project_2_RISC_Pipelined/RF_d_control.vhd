library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RF_d1_control is
port(
RS_id1,RD_or,RD_ex,RD_mem: in std_logic_vector(2 downto 0);
ID_opcode: in std_logic_vector(3 downto 0);
EX_opcode,OR_opcode,mem_opcode: in std_logic_vector(5 downto 0);
cflag_ex,cflag_mem,zflag_ex,zflag_mem,nullify_or,nullify_id,nullify_ex,nullify_mem,user_cflag,user_zflag: in std_logic;
RF_d1_mux_control: out std_logic_vector(2 downto 0)
);

end entity;

architecture Behave of RF_d1_control is
begin
process(RS_id1,RD_or,RD_ex,RD_mem,ID_opcode,EX_opcode,OR_opcode,mem_opcode,cflag_ex,cflag_mem,zflag_ex,zflag_mem,nullify_or,nullify_id,nullify_ex,nullify_mem)

if(((ID_opcode = "0000") or (ID_opcode = "0001") or (ID_opcode = "0010")) and (nullify_id  = '0')) then
	if((((OR_opcode(5 downto 2) = "0000") or (OR_opcode(5 downto 2) = "0001") or (OR_opcode(5 downto 2) = "0010")) and (nullify_or  = '0')) and (RS_id1 = RD_or)) then

		if((OR_opcode(1 downto 0) = "00") or (OR_opcode(5 downto 2) = "0001")) then
			RF_d1_mux_control<="001";
		elsif(((OR_opcode(1 downto 0) = "10") and (cflag_ex = '1')) or ((OR_opcode(1 downto 0) = "01") and (zflag_ex = '1')) ) then
			RF_d1_mux_control<="001";
		else
			RF_d1_mux_control<="000";

		end if;

	elsif((((EX_opcode(5 downto 2) = "0000") or (EX_opcode(5 downto 2) = "0001") or (EX_opcode(5 downto 2) = "0010") or (EX_opcode(5 downto 2) = "0100")) and (nullify_ex  = '0')) and (RS_id1 = RD_ex)) then
		if((EX_opcode(1 downto 0) = "00") or (EX_opcode(5 downto 2) = "0001")) then
			RF_d1_mux_control<="011";
		elsif(((EX_opcode(1 downto 0) = "10") and (cflag_mem = '1')) or ((EX_opcode(1 downto 0) = "01") and (zflag_mem = '1')) ) then
			RF_d1_mux_control<="011";
		elsif(EX_opcode(5 downto 2) = "0100") then
			RF_d1_mux_control<="010";
		else
			RF_d1_mux_control<="000";
		end if;

	elsif((((mem_opcode(5 downto 2) = "0000") or (mem_opcode(5 downto 2) = "0001") or (mem_opcode(5 downto 2) = "0010") or (mem_opcode(5 downto 2) = "0100") or (mem_opcode(5 downto 2) = "0110")) and (nullify_mem  = '0')) and (RS_id1 = RD_mem)) then
		if((mem_opcode(1 downto 0) = "00") or (mem_opcode(5 downto 2) = "0001")) then
			RF_d1_mux_control<="100";
		elsif(((mem_opcode(1 downto 0) = "10") and (user_cflag = '1')) or ((mem_opcode(1 downto 0) = "01") and (user_zflag = '1')) ) then
			RF_d1_mux_control<="100";
		elsif((mem_opcode(5 downto 2) = "0100") or (mem_opcode(5 downto 2) = "0110") ) then
			RF_d1_mux_control<="101";
		else
			RF_d1_mux_control<="000";
		end if;
	else
		RF_d1_mux_control<="000";
	end if;
else
	RF_d1_mux_control<="000";
end if;

end process;
end Behave;
