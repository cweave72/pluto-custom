set hwdef ../hw/build/System_top.hdf

# Create device tree
puts "Creating device tree..."

hsi open_hw_design $hwdef
hsi set_repo_path ../../device-tree-xlnx
hsi create_sw_design device-tree -os device_tree -proc ps7_cortexa9_0
hsi generate_target -dir dts
hsi close_hw_design [hsi::current_hw_design]
