# PlutoSDR Custom Use
This repo holds examples of how to run applications on the PlutoSDR (ADALM-PLUTO from Analog Devices Inc.)

This was mainly an exercise to become familiar with the Vivado/SDK flow and use the Pluto as a generic dev board with a Zynq 7010 on it.  As such, the goal was not to re-flash the Pluto but only to be able to load in new gates and firmware temporariliy.

Approach:
1. I built the standard plutosdr-fw git repo firmware.
2. Opened the Vivado project and exported the project block design to a tcl script.
3. I then lifted the ps7 component definition from the script and placed it in a stand-alone script.
    * base/bd/pluto_ps_only.tcl
4. You can use this as the basis for a new block design since it encompasses all the parameters of the PS (DDR, GPIO, etc..). Just start a new Vivado project and 'source pluto_ps_only.tcl'.

Tools Used
* Vivado 2018.2.
* ADALM-UARTJTAG
* Digilent JTAG-HS3

A few tidbits:
- You can install the Vivado Lab version for a remote JTAG/debug server.
```
$ hw_server  
   
****** Xilinx hw_server v2018.2
  **** Build date : Jun 14 2018-20:18:37
    ** Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.

INFO: hw_server application started
INFO: Use Ctrl-C to exit hw_server application

INFO: To connect to this hw_server instance use url: TCP:cardinal.home:3121
```
This is very handy since the workstation you build on doesn't have to be physically connected to the hardware.

See the 'helloworld' example for the tool flow.
