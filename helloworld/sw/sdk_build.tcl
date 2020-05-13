set currdir [pwd]
set hwdef ../hw/build/System_top.hdf

setws workspace

# Create the hw project.
createhw -name hw_0 -hwspec $hwdef

# Create the FSBL
createapp -name fsbl -app {Zynq FSBL} -hwproject hw_0 -proc ps7_cortexa9_0 -os standalone
configapp -app fsbl define-compiler-symbols FSBL_DEBUG_INFO

# Create helloworld app using the Empty application template.
createapp -name helloworld -app {Empty Application} -hwproject hw_0 -proc ps7_cortexa9_0 -os standalone
importsources -name helloworld -path src/

# Build everything
projects -build

