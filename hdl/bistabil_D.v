module bistabil_D(
    input clk,
    input D,
    output reg Q,
    output reg Q_neg
    );
    
    always @ (posedge clk)
    begin

    Q<=D;
    Q_neg <=!Q;
    
    end
endmodule
