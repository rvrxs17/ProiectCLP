module generatorSemafor(
    input clk_i_t,
    input reset_n_t,
    input service_i_t,
    input enable_i_T,

    output verde_nord,
    output galben_nord,
    output rosu_nord,

    output verde_sud,
    output galben_sud,
    output rosu_sud,

    output verde_est,
    output galben_est,
    output rosu_est,

    output verde_vest,
    output galben_vest,
    output rosu_vest,

    output verde_pietoni,
    output rosu_pietoni
);

localparam sec_verde_nord = 17;
localparam sec_verde_sud = 22;
localparam sec_verde_est = 19;
localparam sec_verde_vest = 20;
localparam sec_verde_pietoni = 12;
localparam sec_verde_intermitent_pietoni = 8;
localparam factor_div = 10;

modulControl  MODUL_CONTROL(
    .clk_i(clk_i_t),
    .enable(enable_i_T),
    .reset_n(reset_n_t),
    .service_i(service_i_t),

    .done_nord(done_nord),
    .done_sud(done_sud),
    .done_est(done_est),
    .done_vest(done_vest),
    .done_pietoni(done_pietoni),

    .enable_nord(enable_nord),
    .enable_sud(enable_sud),
    .enable_est(enable_est),
    .enable_vest(enable_vest),
    .enable_pietoni(enable_pietoni),

    .clear_nord(clear_nord),
    .clear_sud(clear_sud),
    .clear_est(clear_est),
    .clear_vest(clear_vest),
    .clear_pietoni(clear_pietoni),

    .service_o(service_o)
);

modulPietoni #(sec_verde_pietoni, factor_div, sec_verde_intermitent_pietoni) MODUL_PIETONI(
    .clk_i(clk_i_t),
    .enable(enable_pietoni),
    .clear(clear_pietoni),
    .reset_n(reset_n_t),
    .service_i(service_i_t),

    .done_pietoni(done_pietoni),
    .verde_pietoni(verde_pietoni),
    .rosu_pietoni(rosu_pietoni)
);

modulAuto #(sec_verde_nord, factor_div) MODUL_NORD(
    .clk_i(clk_i_t),
    .enable(enable_nord),
    .clear(clear_nord),
    .reset_n(reset_n),
    .service_i(service_i_t),

    .done(done_nord),
    .rosu(rosu_nord),
    .galben(galben_nord),
    .verde(verde_nord)
);

modulAuto #(sec_verde_sud, factor_div) MODUL_SUD(
    .clk_i(clk_i_t),
    .enable(enable_sud),
    .clear(clear_sud),
    .reset_n(reset_n_t),
    .service_i(service_i_t),

    .done(done_sud),
    .rosu(rosu_sud),
    .galben(galben_sud),
    .verde(verde_sud)
);

modulAuto #(sec_verde_est, factor_div) MODUL_EST(
    .clk_i(clk_i_t),
    .enable(enable_est),
    .clear(clear_est),
    .reset_n(reset_n_t),
    .service_i(service_i_t),

    .done(done_est),
    .rosu(rosu_est),
    .galben(galben_est),
    .verde(verde_est)
);

modulAuto #(sec_verde_vest, factor_div) MODUL_VEST(
    .clk_i(clk_i_t),
    .enable(enable_vest),
    .clear(clear_vest),
    .reset_n(reset_n_t),
    .service_i(service_i_t),
    
    .done(done_vest),
    .rosu(rosu_vest),
    .galben(galben_vest),
    .verde(verde_vest)
);

endmodule