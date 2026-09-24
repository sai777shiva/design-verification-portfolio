# 4-Bit Counter Verification Plan

## Specification

The DUT is a 4-bit up-counter with synchronous active-high reset and enable.
Reset has priority over enable.

## Requirements and Checks

| ID | Requirement | Stimulus | Expected result | Check |
|---|---|---|---|---|
| CNT-01 | Reset clears the counter | `reset=1` at rising edge | `count=0` | Scoreboard + SVA |
| CNT-02 | Disabled counter holds | `reset=0`, `enable=0` | Count unchanged | Scoreboard + SVA |
| CNT-03 | Enabled counter increments | `reset=0`, `enable=1` | Count increases by one | Scoreboard + SVA |
| CNT-04 | Counter wraps | Increment from 15 | Count becomes zero | Scoreboard |
| CNT-05 | Reset has priority | `reset=1`, `enable=1` | Count becomes zero | Scoreboard + SVA |
| CNT-06 | Mixed operation is stable | 100 random cycles | Matches reference model | Scoreboard |

## Coverage Goals

- Observe reset.
- Observe hold.
- Observe increment.
- Observe wraparound.
- Observe reset and enable high together.
- Complete every directed and random check with zero mismatches.

## Sign-Off Criteria

- All directed requirements pass.
- All 100 random cycles match the reference model.
- All five functional scenarios are observed.
- No assertion failures.
- No unresolved testbench or RTL defects.
