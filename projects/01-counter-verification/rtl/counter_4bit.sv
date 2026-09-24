module counter_4bit (
    input  logic       clk,
    input  logic       reset,
    input  logic       enable,
    output logic [3:0] count
);

    always_ff @(posedge clk) begin
        if (reset)
            count <= 4'b0000;
        else if (enable)
            count <= count + 4'b0001;
    end

endmodule
