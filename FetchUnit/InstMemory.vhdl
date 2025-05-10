library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstMemory is
    port(
        addr   : in std_logic_vector(15 downto 0);
        instr  : out std_logic_vector(31 downto 0)
    );
end entity InstMemory;

architecture mem_block of InstMemory is

    type mem_array_type is array(0 to 63) of std_logic_vector(15 downto 0);

    -- Example ROM content (can be customized as needed)
    signal memory : mem_array_type := (
        0 => "0100000111111111",
        1 => "0100001111111111",
        2 => "0001000001010000",
        3 => "0010000001011010",
        others => (others => '0')
    );

begin

    -- Output: combine two 16-bit words into a 32-bit instruction
    instr <= memory(to_integer(unsigned(addr))) & memory(to_integer(unsigned(addr)) + 1);

end architecture mem_block;
