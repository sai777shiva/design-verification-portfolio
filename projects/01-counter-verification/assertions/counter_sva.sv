module counter_sva (
    input logic       clk,
    input logic       reset,
    input logic       enable,
    input logic [3:0] count
);

    logic past_valid = 1'b0;
    always_ff @(posedge clk)
        past_valid <= 1'b1;

    // Synchronous reset takes effect after the edge at which it is sampled.
    property p_reset_clears_count;
        @(posedge clk) past_valid && $past(reset) |-> count == 4'h0;
    endproperty

    property p_hold_when_disabled;
        @(posedge clk)
        past_valid && !$past(reset) && !$past(enable)
        |-> count == $past(count);
    endproperty

    property p_increment_when_enabled;
        @(posedge clk)
        past_valid && !$past(reset) && $past(enable)
        |-> count == ($past(count) + 4'h1);
    endproperty

    property p_reset_has_priority;
        @(posedge clk)
        past_valid && $past(reset) && $past(enable)
        |-> count == 4'h0;
    endproperty

    a_reset_clears_count:
        assert property (p_reset_clears_count);

    a_hold_when_disabled:
        assert property (p_hold_when_disabled);

    a_increment_when_enabled:
        assert property (p_increment_when_enabled);

    a_reset_has_priority:
        assert property (p_reset_has_priority);

endmodule
