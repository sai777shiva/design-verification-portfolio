// Intentionally incorrect design used for the documented debugging exercise.
// BUG: enable is tested before reset, so reset loses priority when both are 1.
module counter_4bit_buggy (
    input  logic       clk,
    input  logic       reset,
    input  logic       enable,
    output logic [3:0] count
);

    always_ff @(posedge clk) begin
        if (enable)
            count <= count + 4'b0001;
        else if (reset)
            count <= 4'b0000;
    end

endmodule
