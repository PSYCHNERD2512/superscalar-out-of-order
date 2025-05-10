library ieee;
use ieee.std_logic_1164.all;

entity IFID_Buffer is
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
end entity IFID_Buffer;

architecture logic of IFID_Buffer is

    signal pc_curr_reg  : std_logic_vector(15 downto 0);
    signal pc_next_reg  : std_logic_vector(15 downto 0);
    signal instr_reg    : std_logic_vector(31 downto 0);

begin

    process(clk, rst_active_low)
    begin
        if rst_active_low = '1' then
            pc_curr_reg  <= (others => '0');
            pc_next_reg  <= (others => '0');
            instr_reg    <= (others => '0');
        elsif rising_edge(clk) then
            if write_enable = '1' then
                pc_curr_reg  <= pc_curr_in;
                pc_next_reg  <= pc_next_in;
                instr_reg    <= instr_in;
            end if;
        end if;
    end process;

    pc_curr_out <= pc_curr_reg;
    pc_next_out <= pc_next_reg;
    instr_out   <= instr_reg;

end architecture logic;
