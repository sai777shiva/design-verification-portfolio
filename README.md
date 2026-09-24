# Shivasai Rachakonda - Design Verification Portfolio

This portfolio documents hands-on ASIC design-verification projects developed
from specification through verification sign-off. Each project includes RTL,
a verification plan, self-checking tests, assertions, debugging evidence and a
clear interview explanation.

## Projects

### 1. SystemVerilog Verification of a 4-Bit Counter

Status: Implementation complete; simulator execution pending.

Concepts demonstrated:

- Synchronous sequential RTL
- Clock, reset and enable behavior
- Reference-model checking
- Directed and pseudo-random stimulus
- SystemVerilog assertions
- Functional scenario tracking
- Reset-priority bug injection and root-cause analysis

[Open the counter project](projects/01-counter-verification/)

## Planned Next Projects

1. Synchronous FIFO verification
2. APB register peripheral and layered SystemVerilog testbench
3. APB UVM verification environment
4. UART controller verification
5. Asynchronous FIFO and CDC verification
6. AXI-Lite slave verification
7. Python regression automation

## Verification Workflow

Every project follows the same engineering process:

1. Read and simplify the specification.
2. Convert requirements into a verification plan.
3. Build or inspect the RTL DUT.
4. Develop self-checking stimulus and checking.
5. Add assertions and coverage.
6. Run regressions and debug failures.
7. Record evidence and sign-off criteria.
8. Practice an accurate interview explanation.
