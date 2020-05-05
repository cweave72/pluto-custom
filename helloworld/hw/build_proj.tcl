set part "xc7z010clg225-1"
set block_design "system_bd.tcl"

set currpath [pwd]
set buildpath $currpath/build

# Arguments accepted:
# proj
# synth
# par

set jobs [list]

if {$argc == 1} {
    if {$argv == "proj"} {
        lappend jobs "proj"
    } elseif {$argv == "synth"} {
        lappend jobs "synth"
        # Add proj to the jobs list if the project doesn't exist yet.
        if { [file exists "$buildpath/project_1.xpr"] == 0} {
            lappend jobs "proj"
        }
    } elseif {$argv == "par"} {
        lappend jobs "par"
        # Add proj to the jobs list if the project doesn't exist yet.
        if { [file exists "$buildpath/project_1.xpr"] == 0} {
            lappend jobs "proj"
        }
    }
} else {
    set jobs {"proj" "synth" "par"}
}

puts "Jobs: $jobs"

# Project operations
if {[lsearch -exact $jobs "proj"] >= 0} {
    puts "Creating project..."
    create_project project_1 $buildpath -part $part -force
    set_property target_language VHDL [current_project]

    source -quiet $block_design
    make_wrapper -files [get_files $buildpath/project_1.srcs/sources_1/bd/system/system.bd] -top -force
    import_files -force -norecurse $buildpath/project_1.srcs/sources_1/bd/system/hdl/system_wrapper.vhd

    add_files -norecurse $currpath/../vhdl/src/system_top.vhd
    add_files -fileset constrs_1 -norecurse $currpath/system_constr.xdc
} else {
    open_project $buildpath/project_1.xpr
}

if {[lsearch -exact $jobs "synth"] >= 0} {
    puts "Running synth ..."
    reset_run synth_1
    launch_runs synth_1 -jobs 4
    wait_on_run synth_1
}

if {[lsearch -exact $jobs "par"] >= 0} {
    puts "Running par ..."
    reset_run impl_1
    launch_runs impl_1 -to_step write_bitstream -jobs 4
    wait_on_run impl_1
    open_run impl_1

    puts "Generating utilization report..."
    report_utilization -file [file join $buildpath "utilization.rpt"]
    puts "Generating timing report..."
    report_timing -file [file join $buildpath "timing.rpt"]

    puts "Exporting hardware definition..."
    file copy -force $buildpath/project_1.runs/impl_1/System_top.sysdef $buildpath/System_top.hdf
}
