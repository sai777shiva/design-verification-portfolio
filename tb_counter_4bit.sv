`timescale 1ns/1ps

module tb_counter_4bit;

    logic       clk;
    logic       reset;
    logic       enable;
    logic [3:0] count;

    logic [3:0] expected_count;
    int unsigned checks;
    int unsigned errors;

    bit saw_reset;
    bit saw_reset_priority;
    bit saw_hold;
    bit saw_increment;
    bit saw_wraparound;

    counter_4bit dut (
        .clk    (clk),
        .reset  (reset),
        .enable (enable),
        .count  (count)
    );

    // A 10 ns clock period: rising edges occur every 10 ns.
    initial clk = 1'b0;
    always #5 clk = ~clk;

    task automatic apply_and_check(
        input logic next_reset,
        input logic next_enable,
        input string test_name
    );
        logic [3:0] previous_expected;

        // Drive away from the rising edge to avoid a testbench/DUT race.
        @(negedge clk);
        reset  = next_reset;
        enable = next_enable;
        previous_expected = expected_count;

        @(posedge clk);
        if (next_reset)
            expected_count = 4'b0000;
        else if (next_enable)
            expected_count = expected_count + 4'b0001;

        // Wait for the DUT's nonblocking assignment to update count.
        #1;
        checks++;

        if (count !== expected_count) begin
            errors++;
            $error("FAIL %-24s reset=%0b enable=%0b expected=%0d actual=%0d",
                   test_name, next_reset, next_enable, expected_count, count);
        end
        else begin
            $display("PASS %-24s reset=%0b enable=%0b count=%0d",
                     test_name, next_reset, next_enable, count);
        end

        if (next_reset && next_enable)
            saw_reset_priority = 1'b1;
        if (next_reset)
            saw_reset = 1'b1;
        else if (!next_enable && count == previous_expected)
            saw_hold = 1'b1;
        else if (next_enable && previous_expected == 4'hF && count == 4'h0)
            saw_wraparound = 1'b1;
        else if (next_enable && count == previous_expected + 4'b0001)
            saw_increment = 1'b1;
    endtask

    task automatic check_functional_coverage;
        checks += 5;
        if (!saw_reset) begin
            errors++;
            $error("COVERAGE MISS: reset behavior was not observed");
        end
        if (!saw_reset_priority) begin
            errors++;
            $error("COVERAGE MISS: reset priority was not observed");
        end
        if (!saw_hold) begin
            errors++;
            $error("COVERAGE MISS: hold behavior was not observed");
        end
        if (!saw_increment) begin
            errors++;
            $error("COVERAGE MISS: increment behavior was not observed");
        end
        if (!saw_wraparound) begin
            errors++;
            $error("COVERAGE MISS: wraparound was not observed");
        end
    endtask

    initial begin
        $dumpfile("counter_4bit.vcd");
        $dumpvars(0, tb_counter_4bit);

        reset          = 1'b1;
        enable         = 1'b0;
        expected_count = 4'b0000;
        checks         = 0;
        errors         = 0;
        saw_reset          = 1'b0;
        saw_reset_priority = 1'b0;
        saw_hold           = 1'b0;
        saw_increment      = 1'b0;
        saw_wraparound     = 1'b0;

        // Directed requirements.
        apply_and_check(1'b1, 1'b0, "reset");
        apply_and_check(1'b0, 1'b0, "hold after reset");
        apply_and_check(1'b0, 1'b1, "first increment");
        apply_and_check(1'b0, 1'b1, "second increment");
        apply_and_check(1'b1, 1'b1, "reset priority");

        // Count from zero through 15 and verify wraparound to zero.
        repeat (16)
            apply_and_check(1'b0, 1'b1, "count and wraparound");

        // Deterministic pseudo-random stimulus.
        for (int cycle = 0; cycle < 100; cycle++) begin
            apply_and_check(
                $urandom_range(0, 15) == 0,
                $urandom_range(0, 1),
                $sformatf("random cycle %0d", cycle)
            );
        end

        check_functional_coverage();

        if (errors == 0)
            $display("\nPROJECT PASS: %0d checks completed with no errors.", checks);
        else
            $fatal(1, "\nPROJECT FAIL: %0d of %0d checks failed.", errors, checks);

        $finish;
    end

endmodule
