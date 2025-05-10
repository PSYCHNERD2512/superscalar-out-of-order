library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FetchUnit is
    port(
        clk           : in std_logic;
        rst_n         : in std_logic;
        fetch_trigger : in std_logic;

        -- Output signals to pipeline
        IFID_write_en : out std_logic;
        pc_now        : out std_logic_vector(15 downto 0);
        pc_next       : out std_logic_vector(15 downto 0);
        instruction   : out std_logic_vector(31 downto 0)
    );
end entity FetchUnit;

architecture behavior of FetchUnit is

    component PC_Module is
        port(
            reset    : in std_logic;
            clk      : in std_logic;
            pc_input : in std_logic_vector(15 downto 0);
            pc_value : out std_logic_vector(15 downto 0)
        );
    end component;

    component InstMemory is
        port(
            addr  : in std_logic_vector(15 downto 0);
            instr : out std_logic_vector(31 downto 0)
        );
    end component;

    signal current_pc   : std_logic_vector(15 downto 0) := (others => '0');
    signal next_pc_calc : std_logic_vector(15 downto 0);
    signal fetched_inst : std_logic_vector(31 downto 0);

begin

    -- Increment PC (32-bit instruction = +2)
    next_pc_calc <= std_logic_vector(unsigned(current_pc) + 2);

    -- PC register instance
    PC_inst: PC_Module
        port map(
            reset    => rst_n,
            clk      => clk,
            pc_input => next_pc_calc,
            pc_value => current_pc
        );

    -- Instruction memory instance
    ROM_inst: InstMemory
        port map(
            addr  => current_pc,
            instr => fetched_inst
        );

    -- Outputs to pipeline register
    pc_now      <= current_pc;
    pc_next     <= next_pc_calc;
    instruction <= fetched_inst;

    -- Always allow IF/ID writing for now
    IFID_write_en <= '1';

end architecture behavior;
