VERSION = 2018.2
XSDB = /opt/Xilinx/SDK/$(VERSION)/bin/xsdb

.PHONY: all sw hw export clean

all: hw sw load

export:
	@mkdir -p $@

hw: | export
	$(MAKE) -C hw/
	cp hw/build/System_top.hdf export/
	unzip -o export/System_top.hdf -d export/

sw: hw
	$(MAKE) -C sw/
	cp sw/workspace/fsbl/Debug/fsbl.elf export/
	cp sw/workspace/helloworld/Debug/helloworld.elf export/

$(warning "hw_server = $(HW_SERVER)")

load:
	$(XSDB) scripts/jtagboot.tcl
	
clean:
	rm -rf export/
	$(MAKE) -C hw/ clean
	$(MAKE) -C sw/ clean
