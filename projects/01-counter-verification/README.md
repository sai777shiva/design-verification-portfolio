# SystemVerilog Verification of a 4-Bit Counter

This beginner-friendly design-verification project verifies a synchronous
4-bit up-counter using a self-checking SystemVerilog testbench, a reference
model, assertions, directed tests, pseudo-random stimulus and manually tracked
functional scenarios.

## DUT Behavior

At every rising clock edge:

1. If `reset=1`, `count` becomes zero.
2. Otherwise, if `enable=1`, `count` increments.
3. Otherwise, `count` holds its value.
4. Incrementing 15 wraps the 4-bit result to zero.

## Repository Structure

```text
rtl/          Correct synthesizable RTL
tb/           Self-checking testbench and reference model
assertions/   SVA properties and bind file
debug/        Injected defect and root-cause report
docs/         Verification plan and sign-off requirements
scripts/      Reproducible simulation command
```

## Verification Strategy

The testbench drives inputs on falling edges and samples results after rising
edges. This avoids a race between the testbench and DUT. A small reference
model independently calculates the expected count and compares it with the DUT
after every stimulus cycle.

The regression includes:

- Reset testing
- Hold testing
- Increment testing
- Reset-priority testing
- Full-range wraparound testing
- 100 cycles of pseudo-random reset and enable combinations
- Five functional scenario checks

## Assertions

The SVA module checks:

- Reset clears the counter.
- A disabled counter holds its previous value.
- An enabled counter increments.
- Reset wins when reset and enable are both asserted.

The assertion files are intended for simulators with full SVA support, such as
QuestaSim. The default Icarus command runs the portable self-checking testbench.

## Running with Icarus Verilog

Install Icarus Verilog and run:

```bash
make sim
```

Successful completion ends with:

```text
PROJECT PASS: 126 checks completed with no errors.
```

The run also produces `build/counter_4bit.vcd` for waveform inspection.

## Debugging Exercise

`debug/counter_4bit_buggy.sv` intentionally gives enable higher priority than
reset. `debug/bug_report.md` documents the failure, root cause, correction and
regression protection.

## Interview Summary

I verified a synchronous 4-bit counter by first converting its specification
into six testable requirements. I wrote directed and random stimulus, built an
independent reference model, compared expected and actual outputs after every
clock, added assertions for temporal behavior, and tracked important functional
scenarios. I also injected a reset-priority defect, reproduced the failure and
documented its root cause and prevention.
