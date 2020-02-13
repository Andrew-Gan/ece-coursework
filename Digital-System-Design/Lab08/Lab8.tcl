
########## Tcl recorder starts at 03/03/19 13:49:08 ##########

set version "1.7"
set proj_dir "U:/Desktop/Lab8"
cd $proj_dir

# Get directory paths
set pver $version
regsub -all {\.} $pver {_} pver
set lscfile "lsc_"
append lscfile $pver ".ini"
set lsvini_dir [lindex [array get env LSC_INI_PATH] 1]
set lsvini_path [file join $lsvini_dir $lscfile]
if {[catch {set fid [open $lsvini_path]} msg]} {
	 puts "File Open Error: $lsvini_path"
	 return false
} else {set data [read $fid]; close $fid }
foreach line [split $data '\n'] { 
	set lline [string tolower $line]
	set lline [string trim $lline]
	if {[string compare $lline "\[paths\]"] == 0} { set path 1; continue}
	if {$path && [regexp {^\[} $lline]} {set path 0; break}
	if {$path && [regexp {^bin} $lline]} {set cpld_bin $line; continue}
	if {$path && [regexp {^fpgapath} $lline]} {set fpga_dir $line; continue}
	if {$path && [regexp {^fpgabinpath} $lline]} {set fpga_bin $line}}

set cpld_bin [string range $cpld_bin [expr [string first "=" $cpld_bin]+1] end]
regsub -all "\"" $cpld_bin "" cpld_bin
set cpld_bin [file join $cpld_bin]
set install_dir [string range $cpld_bin 0 [expr [string first "ispcpld" $cpld_bin]-2]]
regsub -all "\"" $install_dir "" install_dir
set install_dir [file join $install_dir]
set fpga_dir [string range $fpga_dir [expr [string first "=" $fpga_dir]+1] end]
regsub -all "\"" $fpga_dir "" fpga_dir
set fpga_dir [file join $fpga_dir]
set fpga_bin [string range $fpga_bin [expr [string first "=" $fpga_bin]+1] end]
regsub -all "\"" $fpga_bin "" fpga_bin
set fpga_bin [file join $fpga_bin]

if {[string match "*$fpga_bin;*" $env(PATH)] == 0 } {
   set env(PATH) "$fpga_bin;$env(PATH)" }

if {[string match "*$cpld_bin;*" $env(PATH)] == 0 } {
   set env(PATH) "$cpld_bin;$env(PATH)" }

lappend auto_path [file join $install_dir "ispcpld" "tcltk" "lib" "ispwidget" "runproc"]
package require runcmd

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-1.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 13:49:08 ###########


########## Tcl recorder starts at 03/03/19 13:49:32 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-1.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 13:49:32 ###########


########## Tcl recorder starts at 03/03/19 13:49:41 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open lab8.cmd w} rspFile] {
	puts stderr "Cannot create response file lab8.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab8.sty
PROJECT: lab8
WORKING_PATH: \"$proj_dir\"
MODULE: lab8
VERILOG_FILE_LIST: lab8.h lab8-1.v
OUTPUT_FILE_NAME: lab8
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e lab8 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab8.cmd

########## Tcl recorder end at 03/03/19 13:49:41 ###########


########## Tcl recorder starts at 03/03/19 13:50:25 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-1.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 13:50:25 ###########


########## Tcl recorder starts at 03/03/19 13:50:29 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open lab8.cmd w} rspFile] {
	puts stderr "Cannot create response file lab8.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab8.sty
PROJECT: lab8
WORKING_PATH: \"$proj_dir\"
MODULE: lab8
VERILOG_FILE_LIST: lab8.h lab8-1.v
OUTPUT_FILE_NAME: lab8
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e lab8 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab8.cmd

########## Tcl recorder end at 03/03/19 13:50:29 ###########


########## Tcl recorder starts at 03/03/19 13:51:24 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-1.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 13:51:24 ###########


########## Tcl recorder starts at 03/03/19 13:51:27 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open lab8.cmd w} rspFile] {
	puts stderr "Cannot create response file lab8.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab8.sty
PROJECT: lab8
WORKING_PATH: \"$proj_dir\"
MODULE: lab8
VERILOG_FILE_LIST: lab8.h lab8-1.v
OUTPUT_FILE_NAME: lab8
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e lab8 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab8.cmd

########## Tcl recorder end at 03/03/19 13:51:27 ###########


########## Tcl recorder starts at 03/03/19 13:51:44 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"lab8.edi\" -out \"lab8.bl0\" -err automake.err -log \"lab8.log\" -prj lab8 -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"lab8.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"lab8.bl1\" -o \"lab8.bl2\" -omod lab8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" lab8.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab8.bl3 -pla -o lab8.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab8.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fuseasm\" lab8.tt3 -dev p22v10g -o lab8.jed -ivec NoInput.tmv -rep lab8.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab8 -if lab8.jed -j2s -log lab8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 13:51:44 ###########


########## Tcl recorder starts at 03/03/19 14:38:19 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-2.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 14:38:19 ###########


########## Tcl recorder starts at 03/03/19 14:40:16 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-2.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 14:40:16 ###########


########## Tcl recorder starts at 03/03/19 14:46:43 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-3.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 14:46:43 ###########


########## Tcl recorder starts at 03/03/19 14:49:17 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-3.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 14:49:17 ###########


########## Tcl recorder starts at 03/03/19 14:49:51 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-3.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 14:49:51 ###########


########## Tcl recorder starts at 03/03/19 14:50:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-3.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 14:50:01 ###########


########## Tcl recorder starts at 03/03/19 14:50:21 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-4.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 14:50:21 ###########


########## Tcl recorder starts at 03/03/19 14:51:03 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-4.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 14:51:03 ###########


########## Tcl recorder starts at 03/03/19 14:56:52 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-2.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 14:56:53 ###########


########## Tcl recorder starts at 03/03/19 14:57:06 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-3.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 14:57:06 ###########


########## Tcl recorder starts at 03/03/19 14:57:30 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-4.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 14:57:30 ###########


########## Tcl recorder starts at 03/03/19 14:58:04 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-2.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 14:58:04 ###########


########## Tcl recorder starts at 03/03/19 14:58:16 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-3.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 14:58:16 ###########


########## Tcl recorder starts at 03/03/19 14:58:58 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-4.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 14:58:58 ###########


########## Tcl recorder starts at 03/03/19 15:36:09 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-5.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 15:36:09 ###########


########## Tcl recorder starts at 03/03/19 15:36:41 ##########

# Commands to make the Process: 
# Hierarchy Browser
# - none -
# Application to view the Process: 
# Hierarchy Browser
if [runCmd "\"$cpld_bin/hierbro\" \"lab8.jid\"  lab8"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 15:36:41 ###########


########## Tcl recorder starts at 03/03/19 15:38:31 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-2.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 15:38:31 ###########


########## Tcl recorder starts at 03/03/19 15:38:39 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-3.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 15:38:39 ###########


########## Tcl recorder starts at 03/03/19 15:38:47 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-4.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 15:38:47 ###########


########## Tcl recorder starts at 03/03/19 15:38:59 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open lab8_4.cmd w} rspFile] {
	puts stderr "Cannot create response file lab8_4.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab8.sty
PROJECT: lab8_4
WORKING_PATH: \"$proj_dir\"
MODULE: lab8_4
VERILOG_FILE_LIST: lab8.h lab8-4.v
OUTPUT_FILE_NAME: lab8_4
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e lab8_4 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab8_4.cmd

########## Tcl recorder end at 03/03/19 15:38:59 ###########


########## Tcl recorder starts at 03/03/19 15:39:52 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-4.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 15:39:52 ###########


########## Tcl recorder starts at 03/03/19 15:39:59 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-3.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 15:39:59 ###########


########## Tcl recorder starts at 03/03/19 15:40:10 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-2.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 15:40:10 ###########


########## Tcl recorder starts at 03/03/19 15:40:15 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open lab8_4.cmd w} rspFile] {
	puts stderr "Cannot create response file lab8_4.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab8.sty
PROJECT: lab8_4
WORKING_PATH: \"$proj_dir\"
MODULE: lab8_4
VERILOG_FILE_LIST: lab8.h lab8-4.v
OUTPUT_FILE_NAME: lab8_4
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e lab8_4 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab8_4.cmd

########## Tcl recorder end at 03/03/19 15:40:15 ###########


########## Tcl recorder starts at 03/03/19 15:40:50 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"lab8_4.edi\" -out \"lab8_4.bl0\" -err automake.err -log \"lab8_4.log\" -prj lab8 -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"lab8_4.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"lab8_4.bl1\" -o \"lab8.bl2\" -omod lab8_4 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" lab8.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab8.bl3 -pla -o lab8.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab8.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fuseasm\" lab8.tt3 -dev p22v10g -o lab8.jed -ivec NoInput.tmv -rep lab8.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab8 -if lab8.jed -j2s -log lab8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 15:40:51 ###########


########## Tcl recorder starts at 03/03/19 15:55:45 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/iblflink\" \"lab8.bl1\" -o \"lab8.bl2\" -omod lab8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" lab8.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab8.bl3 -pla -o lab8.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab8.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fuseasm\" lab8.tt3 -dev p22v10g -o lab8.jed -ivec NoInput.tmv -rep lab8.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab8 -if lab8.jed -j2s -log lab8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 15:55:45 ###########


########## Tcl recorder starts at 03/03/19 16:06:53 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/iblflink\" \"lab8_4.bl1\" -o \"lab8.bl2\" -omod lab8_4 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" lab8.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab8.bl3 -pla -o lab8.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab8.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fuseasm\" lab8.tt3 -dev p22v10g -o lab8.jed -ivec NoInput.tmv -rep lab8.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab8 -if lab8.jed -j2s -log lab8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/03/19 16:06:53 ###########


########## Tcl recorder starts at 03/07/19 14:46:29 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/iblflink\" \"lab8.bl1\" -o \"lab8.bl2\" -omod lab8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" lab8.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab8.bl3 -pla -o lab8.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab8.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fuseasm\" lab8.tt3 -dev p22v10g -o lab8.jed -ivec NoInput.tmv -rep lab8.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab8 -if lab8.jed -j2s -log lab8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/07/19 14:46:29 ###########


########## Tcl recorder starts at 03/07/19 15:33:56 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open lab8_2.cmd w} rspFile] {
	puts stderr "Cannot create response file lab8_2.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab8.sty
PROJECT: lab8_2
WORKING_PATH: \"$proj_dir\"
MODULE: lab8_2
VERILOG_FILE_LIST: lab8.h lab8-2.v
OUTPUT_FILE_NAME: lab8_2
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e lab8_2 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab8_2.cmd

########## Tcl recorder end at 03/07/19 15:33:56 ###########


########## Tcl recorder starts at 03/07/19 15:34:11 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"lab8_2.edi\" -out \"lab8_2.bl0\" -err automake.err -log \"lab8_2.log\" -prj lab8 -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"lab8_2.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"lab8_2.bl1\" -o \"lab8.bl2\" -omod lab8_2 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" lab8.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab8.bl3 -pla -o lab8.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab8.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fuseasm\" lab8.tt3 -dev p22v10g -o lab8.jed -ivec NoInput.tmv -rep lab8.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab8 -if lab8.jed -j2s -log lab8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/07/19 15:34:11 ###########


########## Tcl recorder starts at 03/07/19 15:36:06 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open lab8_3.cmd w} rspFile] {
	puts stderr "Cannot create response file lab8_3.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab8.sty
PROJECT: lab8_3
WORKING_PATH: \"$proj_dir\"
MODULE: lab8_3
VERILOG_FILE_LIST: lab8.h lab8-3.v
OUTPUT_FILE_NAME: lab8_3
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e lab8_3 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab8_3.cmd

########## Tcl recorder end at 03/07/19 15:36:06 ###########


########## Tcl recorder starts at 03/07/19 15:36:29 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"lab8_3.edi\" -out \"lab8_3.bl0\" -err automake.err -log \"lab8_3.log\" -prj lab8 -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"lab8_3.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"lab8_3.bl1\" -o \"lab8.bl2\" -omod lab8_3 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" lab8.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab8.bl3 -pla -o lab8.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab8.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fuseasm\" lab8.tt3 -dev p22v10g -o lab8.jed -ivec NoInput.tmv -rep lab8.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab8 -if lab8.jed -j2s -log lab8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/07/19 15:36:29 ###########


########## Tcl recorder starts at 03/07/19 15:38:19 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-3.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/07/19 15:38:19 ###########


########## Tcl recorder starts at 03/07/19 15:38:23 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open lab8_3.cmd w} rspFile] {
	puts stderr "Cannot create response file lab8_3.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab8.sty
PROJECT: lab8_3
WORKING_PATH: \"$proj_dir\"
MODULE: lab8_3
VERILOG_FILE_LIST: lab8.h lab8-3.v
OUTPUT_FILE_NAME: lab8_3
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e lab8_3 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab8_3.cmd

########## Tcl recorder end at 03/07/19 15:38:23 ###########


########## Tcl recorder starts at 03/07/19 15:38:37 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"lab8_3.edi\" -out \"lab8_3.bl0\" -err automake.err -log \"lab8_3.log\" -prj lab8 -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"lab8_3.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"lab8_3.bl1\" -o \"lab8.bl2\" -omod lab8_3 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" lab8.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab8.bl3 -pla -o lab8.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab8.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fuseasm\" lab8.tt3 -dev p22v10g -o lab8.jed -ivec NoInput.tmv -rep lab8.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab8 -if lab8.jed -j2s -log lab8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/07/19 15:38:37 ###########


########## Tcl recorder starts at 03/07/19 15:41:53 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/iblflink\" \"lab8_4.bl1\" -o \"lab8.bl2\" -omod lab8_4 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" lab8.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab8.bl3 -pla -o lab8.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab8.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fuseasm\" lab8.tt3 -dev p22v10g -o lab8.jed -ivec NoInput.tmv -rep lab8.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab8 -if lab8.jed -j2s -log lab8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/07/19 15:41:53 ###########


########## Tcl recorder starts at 03/07/19 15:46:49 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab8-3.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab8.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/07/19 15:46:49 ###########


########## Tcl recorder starts at 03/07/19 15:47:17 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open lab8_3.cmd w} rspFile] {
	puts stderr "Cannot create response file lab8_3.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab8.sty
PROJECT: lab8_3
WORKING_PATH: \"$proj_dir\"
MODULE: lab8_3
VERILOG_FILE_LIST: lab8.h lab8-3.v
OUTPUT_FILE_NAME: lab8_3
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e lab8_3 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab8_3.cmd

########## Tcl recorder end at 03/07/19 15:47:17 ###########


########## Tcl recorder starts at 03/07/19 15:47:28 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"lab8_3.edi\" -out \"lab8_3.bl0\" -err automake.err -log \"lab8_3.log\" -prj lab8 -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"lab8_3.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"lab8_3.bl1\" -o \"lab8.bl2\" -omod lab8_3 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" lab8.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab8.bl3 -pla -o lab8.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab8.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fuseasm\" lab8.tt3 -dev p22v10g -o lab8.jed -ivec NoInput.tmv -rep lab8.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab8 -if lab8.jed -j2s -log lab8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/07/19 15:47:28 ###########

