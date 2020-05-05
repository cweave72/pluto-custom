SDK_VERSION ?= 2018.2
SDK := /opt/Xilinx/SDK/$(SDK_VERSION)/bin/xsdk

.PHONY: all clean gui proj

TARGET = workspace/fsbl/Debug/fsbl.elf

all: $(TARGET)

$(TARGET): clean
	$(SDK) -batch -source sdk_build.tcl | tee build.out

gui:
	$(SDK) -workspace workspace/ -wait

clean:
	rm -rf workspace/
