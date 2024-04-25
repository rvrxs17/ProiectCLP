 module testbench();
    reg clk_i = 0;
    reg reset_n_i=0;
    reg service_i=0;
    reg enable = 0 ;
    wire Rosu_auto_S_o;
    wire Galben_auto_S_o;
    wire Verde_auto_S_o;
    wire Rosu_auto_E_o;
    wire Galben_auto_E_o;
    wire Verde_auto_E_o;
    wire Rosu_auto_V_o;
    wire Galben_auto_V_o;
    wire Verde_auto_V_o;
    wire Rosu_auto_N_o;
    wire Galben_auto_N_o;
    wire Verde_auto_N_o;
    wire Rosu_pietoni_o;
    wire Verde_pietoni_o;
    
initial begin
    forever #10 clk_i <= ~clk_i;
end

initial begin
    #10 
    reset_n_i <=1;
    enable <=1;
    #26000
    $finish();
end
    


generatorSemafor rezultate(
    .clk_i_t(clk_i),
    .reset_n_t(reset_n_i),
    .service_i_t(service_i),
    .enable_i_T(enable),

    .rosu_nord(Rosu_auto_N_o),
    .galben_nord(Galben_auto_N_o), 
    .verde_nord(Verde_auto_N_o),

    .rosu_sud(Rosu_auto_S_o),
    .galben_sud(Galben_auto_S_o),
    .verde_sud(Verde_auto_S_o),

    .rosu_est(Rosu_auto_E_o),
    .galben_est(Galben_auto_E_o), 
    .verde_est(Verde_auto_E_o),

    .rosu_vest(Rosu_auto_V_o),
    .galben_vest(Galben_auto_V_o),
    .verde_vest(Verde_auto_V_o),

    .rosu_pietoni(Rosu_pietoni_o),
    .verde_pietoni(Verde_pietoni_o)
);

endmodule