module modulControl
(
    input clk_i,
    input enable,
    input reset_n,
    input service_i,

    input done_nord,
    input done_sud,
    input done_est,
    input done_vest,
    input done_pietoni,

    output enable_nord,
    output enable_sud,
    output enable_est,
    output enable_vest,
    output enable_pietoni,

    output reg clear_nord,
    output reg clear_sud,
    output reg clear_est,
    output reg clear_vest,
    output reg clear_pietoni,

    output reg service_o
);

//Codare:
localparam s_idle = 0;
localparam s_auto_nord = 1;
localparam s_auto_sud = 2;
localparam s_auto_est = 3; 
localparam s_auto_vest = 4; 
localparam s_pietoni = 5; 
localparam s_service = 6;

reg [6:0]stare_curenta;
reg [6:0]stare_viitoare;

//Control:
//Partea secventiala

always @(posedge clk_i or negedge reset_n)
begin
    if(~reset_n) stare_curenta <= s_idle;
    else if(service_i) stare_curenta <= s_service;
    else       stare_curenta <= stare_viitoare;
end

//Parte combinationala
always @(*)  
begin
    case(stare_curenta)
        s_idle: if(enable) stare_viitoare <= s_auto_sud;
                else stare_viitoare <= s_idle;

        s_auto_sud: if(done_sud) stare_viitoare <= s_auto_nord;
                else stare_viitoare <= s_auto_sud;

        s_auto_nord: if(done_nord) stare_viitoare <= s_auto_est;
                else stare_viitoare <= s_auto_nord;

        s_auto_est: if(done_est) stare_viitoare <= s_auto_vest;
                else stare_viitoare <= s_auto_est;

        s_auto_vest: if(done_vest) stare_viitoare <= s_pietoni;
                else stare_viitoare <= s_auto_vest;

        s_pietoni: if(done_pietoni) stare_viitoare <= s_auto_sud;
                else stare_viitoare <= s_pietoni;

        s_service: if(service_i) stare_viitoare <= s_idle;
       
        default: stare_viitoare <= s_idle;
    endcase
end


//Iesirele

assign enable_nord = (stare_curenta == s_auto_nord);
assign enable_sud =  (stare_curenta == s_auto_sud);
assign enable_est = (stare_curenta == s_auto_est);
assign enable_vest = (stare_curenta == s_auto_vest);
assign enable_pietoni = (stare_curenta == s_pietoni);

always @*
begin
    clear_nord = (done_nord == 1) ? 1'b1 : 1'b0;
    clear_sud = (done_sud == 1) ? 1'b1 : 1'b0;
    clear_est = (done_est == 1) ? 1'b1 : 1'b0;
    clear_vest = (done_vest == 1) ? 1'b1 : 1'b0;
    clear_pietoni = (done_pietoni == 1) ? 1'b1 : 1'b0;
    service_o = (service_i == 1) ? 1'b1 : 1'b0;
end


endmodule