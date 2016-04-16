
network_x_size = 2
network_y_size = 2

noc_file = open('network_'+str(network_x_size)+"x"+str(network_y_size)+'.vhd', 'w')


noc_file.write("library ieee;\n")
noc_file.write("use ieee.std_logic_1164.all;\n")
noc_file.write("use IEEE.STD_LOGIC_ARITH.ALL;\n")
noc_file.write("use IEEE.STD_LOGIC_UNSIGNED.ALL;\n")
noc_file.write("use work.Router_Package.all;\n\n")

noc_file.write("entity network_"+str(network_x_size)+"x"+str(network_y_size)+" is\n")

noc_file.write("end network_"+str(network_x_size)+"x"+str(network_y_size)+"; \n")


noc_file.write("\n\n")
noc_file.write("architecture behavior of network_"+str(network_x_size)+"x"+str(network_y_size)+" is\n")
noc_file.write("component router is\n")
noc_file.write(" generic (\n")
noc_file.write("        DATA_WIDTH: integer := 32;\n")
noc_file.write("        current_address : integer := 5;\n")
noc_file.write("        Rxy_rst : integer := 60;\n")
noc_file.write("        Cx_rst : integer := 15\n")
noc_file.write("    );\n")
noc_file.write("    port (\n")
noc_file.write("    reset, clk: in std_logic;\n")
noc_file.write("    DCTS_N, DCTS_E, DCTS_w, DCTS_S, DCTS_L: in std_logic;\n")
noc_file.write("    DRTS_N, DRTS_E, DRTS_W, DRTS_S, DRTS_L: in std_logic;\n")
noc_file.write("    In_N, In_E, In_W, In_S, In_L : in std_logic_vector (DATA_WIDTH-1 downto 0);\n")
noc_file.write("    RTS_N, RTS_E, RTS_W, RTS_S, RTS_L: out std_logic;\n")
noc_file.write("    CTS_N, CTS_E, CTS_w, CTS_S, CTS_L: out std_logic;\n")
noc_file.write("    Out_N, Out_E, Out_W, Out_S, Out_L: out std_logic_vector (DATA_WIDTH-1 downto 0));\n")
noc_file.write("end component; \n")
noc_file.write("\n")
for i in range(0, network_x_size*network_y_size):
    noc_file.write("\tsignal DCTS_N_"+str(i)+", DCTS_E_"+str(i)+", DCTS_w_"+str(i)+", DCTS_S_"+str(i) +
                   ", DCTS_L_"+str(i)+": std_logic;\n")
noc_file.write("\n")
for i in range(0, network_x_size*network_y_size):
    noc_file.write("\tsignal DRTS_N_"+str(i)+", DRTS_E_"+str(i)+", DRTS_W_"+str(i)+", DRTS_S_"+str(i) +
                   ", DRTS_L_"+str(i)+": std_logic;\n")
noc_file.write("\n")
for i in range(0, network_x_size*network_y_size):
    noc_file.write("\tsignal In_N_"+str(i)+", In_E_"+str(i)+", In_W_"+str(i)+", In_S_"+str(i)+", In_L_"+str(i) +
                   " : std_logic_vector (DATA_WIDTH-1 downto 0);\n")
noc_file.write("\n")
for i in range(0, network_x_size*network_y_size):
    noc_file.write("\tsignal CTS_N_"+str(i)+", CTS_E_"+str(i)+", CTS_w_"+str(i)+", CTS_S_"+str(i) +
                   ", CTS_L_"+str(i)+": std_logic;\n")
noc_file.write("\n")
for i in range(0, network_x_size*network_y_size):
    noc_file.write("\tsignal RTS_N_"+str(i)+", RTS_E_"+str(i)+", RTS_W_"+str(i)+", RTS_S_"+str(i) +
                   ", RTS_L_"+str(i)+": std_logic;\n")
noc_file.write("\n")
for i in range(0, network_x_size*network_y_size):
    noc_file.write("\tsignal Out_N_"+str(i)+", Out_E_"+str(i)+", Out_W_"+str(i)+", Out_S_"+str(i)+", Out_L_"+str(i) +
                   " : std_logic_vector (DATA_WIDTH-1 downto 0);\n")
noc_file.write("begin\n")



noc_file.write("end;\n")