BUILD_DIR = ./build

export PATH := $(PATH):$(abspath ./utils)

test:
	mill -i __.test

verilog:
	$(call git_commit, "generate verilog")
	mkdir -p $(BUILD_DIR)
	mill -i __.test.runMain Elaborate -td $(BUILD_DIR)

help:
	mill -i __.test.runMain Elaborate --help

compile:
	mill -i __.compile

bsp:
	mill -i mill.bsp.BSP/install

reformat:
	mill -i __.reformat

checkformat:
	mill -i __.checkFormat

clean:
	-rm -rf $(BUILD_DIR)

build_docker:
	docker build -f docker/Dockerfile -t chisel-chipware:latest .

run_docker: build_docker
	docker run -it --rm -v $(shell pwd):/workspace/$(shell basename $$(pwd)) --workdir /workspace/$(shell basename $$(pwd)) chisel-chipware:latest

.PHONY: test verilog help compile bsp reformat checkformat build_docker run_docker clean

sim:
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!
	@echo "Write this Makefile by yourself."

-include ../Makefile
