# Bug Report: Reset Priority Failure

## Requirement

When `reset` and `enable` are both high at a rising clock edge, reset must have
priority and `count` must become zero.

## Failure

The `reset priority` test expected `count=0`, but the intentionally buggy RTL
incremented the previous count.

## Root Cause

The buggy `if/else if` statement checked `enable` before `reset`. Because only
the first true branch executes, reset was ignored when both inputs were high.

## Correction

Check `reset` first, followed by `enable`:

```systemverilog
if (reset)
    count <= 4'b0000;
else if (enable)
    count <= count + 4'b0001;
```

## Prevention

The directed reset-priority test and `p_reset_has_priority` assertion remain in
the regression to prevent the defect from returning.
