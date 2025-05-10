library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_FetchUnit is
end entity tb_FetchUnit;

architecture sim of tb_FetchUnit is

    -- Declare component instances for all four modules
    component FetchUnit is
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
    end component;

    component IFID_Buffer is
        port(
            clk            : in std_logic;
            rst_active_low : in std_logic;
            write_enable   : in std_logic;

            -- Inputs from IF stage
            pc_curr_in     : in std_logic_vector(15 downto 0);
            pc_next_in     : in std_logic_vector(15 downto 0);
            instr_in       : in std_logic_vector(31 downto 0);

            -- Outputs to ID stage
            pc_curr_out    : out std_logic_vector(15 downto 0);
            pc_next_out    : out std_logic_vector(15 downto 0);
            instr_out      : out std_logic_vector(31 downto 0)
        );
    end component;

    component InstMemory is
        port(
            addr   : in std_logic_vector(15 downto 0);
            instr  : out std_logic_vector(31 downto 0)
        );
    end component;

    component PC_Module is
        port(
            reset    : in std_logic;
            clk      : in std_logic;
            pc_input : in std_logic_vector(15 downto 0);
            pc_value : out std_logic_vector(15 downto 0)
        );
    end component;

    -- Signals for simulation
    signal clk          : std_logic := '0';
    signal rst_n        : std_logic := '0';
    signal fetch_trigger: std_logic := '0';

    -- Signals to connect between modules
    signal IFID_write_en : std_logic;
    signal pc_now        : std_logic_vector(15 downto 0);
    signal pc_next       : std_logic_vector(15 downto 0);
    signal instruction   : std_logic_vector(31 downto 0);
    signal pc_curr_in    : std_logic_vector(15 downto 0);
    signal pc_next_in    : std_logic_vector(15 downto 0);
    signal instr_in      : std_logic_vector(31 downto 0);
    signal pc_curr_out   : std_logic_vector(15 downto 0);
    signal pc_next_out   : std_logic_vector(15 downto 0);
    signal instr_out     : std_logic_vector(31 downto 0);

begin

    -- Instantiating the FetchUnit (IF stage)
    fetch_unit_inst: FetchUnit
        port map(
            clk           => clk,
            rst_n         => rst_n,
            fetch_trigger => fetch_trigger,

            IFID_write_en => IFID_write_en,
            pc_now        => pc_now,
            pc_next       => pc_next,
            instruction   => instruction
        );

    -- Instantiating the IFID_Buffer (IF/ID pipeline register)
    ifid_buffer_inst: IFID_Buffer
        port map(
            clk            => clk,
            rst_active_low => rst_n,
            write_enable   => IFID_write_en,

            -- Inputs
            pc_curr_in     => pc_now,
            pc_next_in     => pc_next,
            instr_in       => instruction,

            -- Outputs
            pc_curr_out    => pc_curr_out,
            pc_next_out    => pc_next_out,
            instr_out      => instr_out
        );

    -- Instantiating the InstMemory (ROM)
    inst_memory_inst: InstMemory
        port map(
            addr  => pc_curr_out,
            instr => instr_out
        );

    -- Instantiating the PC_Module
    pc_module_inst: PC_Module
        port map(
            reset    => rst_n,
            clk      => clk,
            pc_input => pc_next_out,
            pc_value => pc_curr_out
        );

    -- Clock generation process
    clock_process: process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process clock_process;

    -- Test sequence process
    test_process: process
    begin
        -- Reset the design
        rst_n <= '0';
        wait for 20 ns;
        rst_n <= '1';
        wait for 20 ns;

        -- Simulate fetches and instruction writes
        fetch_trigger <= '1';
        wait for 40 ns;
        fetch_trigger <= '0';
        wait for 40 ns;

        fetch_trigger <= '1';
        wait for 40 ns;
        fetch_trigger <= '0';
        wait for 40 ns;

        -- Finish the simulation
        report "Testbench simulation completed.";
        wait;
    end process test_process;

end architecture sim;
