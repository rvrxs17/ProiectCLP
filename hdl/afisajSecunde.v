module afisajSecunde#(
    parameter latime = 6,     // Lățimea în biți a valorii secundelor
    parameter sec_verde = 10, // Numărul de secunde pentru afișajul verde
    parameter factor_div = 10 // Factorul de divizare al frecvenței
)(
    input [latime-1:0] secunde, // Intrarea cu valoarea secundelor
    input clk_i,                // Intrare pentru semnalul de ceas
    input reset_n,              // Intrare pentru semnalul de reset
    input enable,               // Intrare pentru semnalul de activare
    output reg [6:0] afisaj,    // Ieșirea pentru afișajul cu 7 segmente
    output reg puls_1_sec      // Ieșire pentru semnalul de puls de 1 secundă
);

// Definirea codului pentru fiecare cifră
reg [6:0] cifra0 = 7'b1000000; // 0
reg [6:0] cifra1 = 7'b1111001; // 1
reg [6:0] cifra2 = 7'b0100100; // 2
reg [6:0] cifra3 = 7'b0110000; // 3
reg [6:0] cifra4 = 7'b0011001; // 4
reg [6:0] cifra5 = 7'b0010010; // 5
reg [6:0] cifra6 = 7'b0000010; // 6
reg [6:0] cifra7 = 7'b1111000; // 7
reg [6:0] cifra8 = 7'b0000000; // 8
reg [6:0] cifra9 = 7'b0010000; // 9

localparam factor_div_afisaj = factor_div;

divFrecventa #(factor_div_afisaj) DIV_FQR(
    .clk_i(clk_i),
    .reset_n_i(reset_n),
    .enable(enable),
    .clk_div(puls_1_sec)
);

// Afișajul inițial este setat la 0
always @(*) begin
    case(secunde)
        0: afisaj = cifra0;
        1: afisaj = cifra1;
        2: afisaj = cifra2;
        3: afisaj = cifra3;
        4: afisaj = cifra4;
        5: afisaj = cifra5;
        6: afisaj = cifra6;
        7: afisaj = cifra7;
        8: afisaj = cifra8;
        9: afisaj = cifra9;
        default: afisaj = cifra0; // În cazul în care secundele depășesc 9, afișează 0
    endcase
end

endmodule
