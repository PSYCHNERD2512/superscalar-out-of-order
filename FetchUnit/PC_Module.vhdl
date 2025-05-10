library ieee;
use ieee.std_logic_1164.all;

entity PC_Module is
    port(
        reset    : in std_logic;
        clk      : in std_logic;
        pc_input : in std_logic_vector(15 downto 0);
        pc_value : out std_logic_vector(15 downto 0)
    );
end entity PC_Module;

architecture counter of PC_Module is
    signal pc_internal : std_logic_vector(15 downto 0) := (others => '0');
begin

    process(clk, reset)
    begin
        if reset = '1' then
            pc_internal <= (others => '0');
        elsif rising_edge(clk) then
            pc_internal <= pc_input;
        end if;
    end process;

    pc_value <= pc_internal;

end architecture counter;
