module modulAuto#(parameter sec_verde = 10, 
parameter factor_div_auto_module = 10
)
(
    input clk_i,
    input enable,
    input clear,
    input reset_n,
    input service_i,

    output done,
    output rosu,
    output galben,
    output verde
);

//Declarare variabilele interne
reg [2:0] counter_galben = 0;
reg [5:0] counter_verde = 0;

//Codare
localparam s_idle = 0;
localparam s_galben = 1;
localparam s_verde = 2;
localparam s_done = 3; 


wire puls_1_sec;

reg [3:0]stare_curenta;
reg [3:0]stare_viitoare; 

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
        s_idle: if(enable || service_i) stare_viitoare <= s_galben;
                else stare_viitoare <= s_idle;

        s_galben: if(counter_galben == 2) stare_viitoare <= s_verde;
                else stare_viitoare <= s_galben;

        s_verde: if(counter_verde == sec_verde) stare_viitoare <= s_done;
                else stare_viitoare <= s_verde;

        s_done: if(clear) stare_viitoare <= s_idle;
                else stare_viitoare <= s_done;
       
        default: stare_viitoare <= s_idle;
    endcase
end


//Instantierea modului de frecventa

divFrecventa #(factor_div_auto_module) DIV_FQR(
    .clk_i(clk_i),
    .reset_n_i(reset_n),
    .enable(enable),
    .clk_div(puls_1_sec)
);


// Modelam enable_div_frec

always @(posedge clk_i or negedge reset_n) 
begin
    if(~reset_n)                                       counter_galben <= 0;
    else if((stare_curenta == s_galben) & puls_1_sec ) counter_galben <= counter_galben +1;
end

always @(posedge clk_i or negedge reset_n) 
begin
    if(~reset_n)                                      counter_verde <= 0;
    else if((stare_curenta == s_verde) & puls_1_sec ) counter_verde <= counter_verde +1;
end


//Iesirele

assign galben = (stare_curenta == s_galben) || (service_i && stare_curenta == s_idle);
assign verde = (stare_curenta == s_verde);
assign rosu = (stare_curenta == s_idle) || (stare_curenta == s_done);
assign done = (stare_curenta == s_done);


endmodule