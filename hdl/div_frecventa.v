module divFrecventa#(parameter factor_div = 10)
    (
    input clk_i,
    input reset_n_i,
    input enable,

    output reg clk_div
);

reg [31:0] cnt;
always @ (posedge clk_i or negedge reset_n_i)
begin
    if(~reset_n_i) cnt <= 0;
    else if(enable & (cnt <= factor_div)) cnt <= cnt + 1;
    else cnt <= 0;
end



always @(posedge clk_i or posedge reset_n_i)
    begin
        if (~reset_n_i)
            clk_div <= 0;
        else if (cnt == factor_div)
            clk_div <= 1;
        else
            clk_div <= 0;
    end

endmodule