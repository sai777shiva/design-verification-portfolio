#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build_dir="$project_dir/build"

mkdir -p "$build_dir"
cd "$build_dir"

iverilog -g2012 \
    -s tb_counter_4bit \
    -o counter_sim \
    "$project_dir/rtl/counter_4bit.sv" \
    "$project_dir/tb/tb_counter_4bit.sv"

vvp counter_sim
