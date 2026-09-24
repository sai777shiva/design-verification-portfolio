.PHONY: sim clean

sim:
	./scripts/run_iverilog.sh

clean:
	rm -rf build
