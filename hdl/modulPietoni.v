module modulPietoni#(parameter sec_verde = 10, 
parameter factor_div_modul_pietoni = 10,
parameter sec_verde_intermitent = 10
)
(
    input clk_i,
    input enable,
    input clear,
    input reset_n,
    input service_i,

    output done_pietoni,
    output verde_pietoni,
    output rosu_pietoni
);

//Declarare variabilele interne
reg [5:0] counter_verde = 0;
reg [4:0] counter_verde_intermitent = 0; 

//Codare
localparam s_idle = 0;
localparam s_verde = 1;
localparam s_verde_intermitent = 2;
localparam s_done = 3; 


wire puls_1_sec;

reg [4:0]stare_curenta;
reg [4:0]stare_viitoare; 

//Control:
//Partea secventiala

always @(posedge clk_i or negedge reset_n)
begin
    if(~reset_n) stare_curenta <= s_idle;
    if(service_i) stare_curenta <= s_idle;
    else       stare_curenta <= stare_viitoare;
end

//Parte combinationala
always @(*)  
begin
    case(stare_curenta)
        s_idle: if(enable) stare_viitoare <= s_verde;
                else stare_viitoare <= s_idle;

        s_verde: if(counter_verde == sec_verde || service_i) stare_viitoare <= s_verde_intermitent;
                else stare_viitoare <= s_verde;

        s_verde_intermitent: if(counter_verde_intermitent == sec_verde_intermitent) stare_viitoare <= s_done;
                else stare_viitoare <= s_verde_intermitent;

        s_done: if(clear) stare_viitoare <= s_idle;
                else stare_viitoare <= s_done;
       
        default: stare_viitoare <= s_idle;
    endcase
end


//Instantierea modului de frecventa

divFrecventa #(factor_div_modul_pietoni) DIV_FQR(
    .clk_i(clk_i),
    .reset_n_i(reset_n),
    .enable(enable),
    .clk_div(puls_1_sec)
);



always @(posedge clk_i or negedge reset_n) 
begin
    if(~reset_n)                                       counter_verde_intermitent <= 0;
    else if((stare_curenta == s_verde_intermitent) & puls_1_sec ) counter_verde_intermitent <= counter_verde_intermitent +1;
end

always @(posedge clk_i or negedge reset_n) 
begin
    if(~reset_n)                                      counter_verde <= 0;
    else if((stare_curenta == s_verde) & puls_1_sec ) counter_verde <= counter_verde +1;
end

//Iesirele

assign verde_pietoni = (stare_curenta == s_verde) || ( (stare_curenta == s_verde_intermitent) && ((counter_verde_intermitent % 2) == 0)) || (service_i);
assign rosu_pietoni = (stare_curenta == s_idle) || (stare_curenta == s_done); 
assign done_pietoni = (stare_curenta == s_done);


endmodule