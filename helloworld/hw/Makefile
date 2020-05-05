VIVADO_VERSION ?= 2018.2
VIVADO := /opt/Xilinx/Vivado/$(VIVADO_VERSION)/bin/vivado

TARGET = build/System_top.hdf

.PHONY: all proj synth par gui clean

all: $(TARGET)

build:
	@mkdir -p $@

$(TARGET): | build
	@echo "Building PL design."
	$(VIVADO) -mode batch -notrace -source build_proj.tcl

# make proj (to create a new project only)
proj: clean | build 
	@echo "Cleaning and creating new project."
	$(VIVADO) -mode batch -notrace -source build_proj.tcl -tclargs $@

# Rules for incremental development
# make synth (to synthesize design only)
# make par (to synthesize (if necessary) and implement to bitstream)
synth par: | build
	$(VIVADO) -mode batch -notrace -source build_proj.tcl -tclargs $@

gui:
	$(VIVADO) build/project_1.xpr

clean:
	rm -rf build/ NA/
	rm -f vivado*
