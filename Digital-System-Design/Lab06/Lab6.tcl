
########## Tcl recorder starts at 02/17/19 14:32:06 ##########

set version "1.7"
set proj_dir "U:/Desktop/Lab6"
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
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab6.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab6.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/17/19 14:32:06 ###########


########## Tcl recorder starts at 02/17/19 14:39:07 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab6.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab6.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/17/19 14:39:07 ###########


########## Tcl recorder starts at 02/17/19 14:48:39 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab6.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab6.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/17/19 14:48:39 ###########


########## Tcl recorder starts at 02/17/19 14:51:22 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab6.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab6.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/17/19 14:51:22 ###########


########## Tcl recorder starts at 02/17/19 14:52:10 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab6.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab6.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/17/19 14:52:10 ###########


########## Tcl recorder starts at 02/17/19 14:54:01 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab6.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab6.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab6.sty
PROJECT: Lab6
WORKING_PATH: \"$proj_dir\"
MODULE: Lab6
VERILOG_FILE_LIST: lab6.h lab6.v
OUTPUT_FILE_NAME: Lab6
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab6 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab6.cmd

########## Tcl recorder end at 02/17/19 14:54:01 ###########


########## Tcl recorder starts at 02/17/19 14:54:51 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab6.edi\" -out \"Lab6.bl0\" -err automake.err -log \"Lab6.log\" -prj lab6 -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab6.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab6.bl1\" -o \"lab6.bl2\" -omod Lab6 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/17/19 14:54:51 ###########


########## Tcl recorder starts at 02/17/19 14:54:58 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab6.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab6.bl3 -pla -o lab6.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab6.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/17/19 14:54:58 ###########


########## Tcl recorder starts at 02/17/19 14:55:03 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab6.tt3 -dev p22v10g -o lab6.jed -ivec NoInput.tmv -rep lab6.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab6 -if lab6.jed -j2s -log lab6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/17/19 14:55:03 ###########


########## Tcl recorder starts at 02/17/19 14:58:30 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab6.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab6.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/17/19 14:58:30 ###########


########## Tcl recorder starts at 02/17/19 15:06:32 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab6.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab6.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/17/19 15:06:32 ###########


########## Tcl recorder starts at 02/21/19 14:26:53 ##########

# Commands to make the Process: 
# Hierarchy Browser
# - none -
# Application to view the Process: 
# Hierarchy Browser
if [runCmd "\"$cpld_bin/hierbro\" \"lab6.jid\"  Lab6"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 14:26:53 ###########


########## Tcl recorder starts at 02/21/19 14:27:32 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab6.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab6.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab6.sty
PROJECT: Lab6
WORKING_PATH: \"$proj_dir\"
MODULE: Lab6
VERILOG_FILE_LIST: lab6.h lab6.v
OUTPUT_FILE_NAME: Lab6
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab6 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab6.cmd

########## Tcl recorder end at 02/21/19 14:27:32 ###########


########## Tcl recorder starts at 02/21/19 14:30:42 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab6.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab6.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 14:30:42 ###########


########## Tcl recorder starts at 02/21/19 14:48:39 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab6.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab6.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 14:48:39 ###########


########## Tcl recorder starts at 02/21/19 14:49:35 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab6.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab6.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab6.sty
PROJECT: Lab6
WORKING_PATH: \"$proj_dir\"
MODULE: Lab6
VERILOG_FILE_LIST: lab6.h lab6.v
OUTPUT_FILE_NAME: Lab6
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab6 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab6.cmd

########## Tcl recorder end at 02/21/19 14:49:36 ###########


########## Tcl recorder starts at 02/21/19 14:50:10 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab6.edi\" -out \"Lab6.bl0\" -err automake.err -log \"Lab6.log\" -prj lab6 -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab6.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab6.bl1\" -o \"lab6.bl2\" -omod Lab6 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 14:50:10 ###########


########## Tcl recorder starts at 02/21/19 14:50:15 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab6.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab6.bl3 -pla -o lab6.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab6.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 14:50:15 ###########


########## Tcl recorder starts at 02/21/19 14:50:18 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab6.tt3 -dev p22v10g -o lab6.jed -ivec NoInput.tmv -rep lab6.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab6 -if lab6.jed -j2s -log lab6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 14:50:18 ###########


########## Tcl recorder starts at 02/21/19 15:01:09 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab6.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab6.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:01:09 ###########


########## Tcl recorder starts at 02/21/19 15:01:19 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab6.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab6.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab6.sty
PROJECT: Lab6
WORKING_PATH: \"$proj_dir\"
MODULE: Lab6
VERILOG_FILE_LIST: lab6.h lab6.v
OUTPUT_FILE_NAME: Lab6
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab6 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab6.cmd

########## Tcl recorder end at 02/21/19 15:01:19 ###########


########## Tcl recorder starts at 02/21/19 15:01:34 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab6.edi\" -out \"Lab6.bl0\" -err automake.err -log \"Lab6.log\" -prj lab6 -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab6.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab6.bl1\" -o \"lab6.bl2\" -omod Lab6 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:01:34 ###########


########## Tcl recorder starts at 02/21/19 15:01:37 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab6.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab6.bl3 -pla -o lab6.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab6.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:01:37 ###########


########## Tcl recorder starts at 02/21/19 15:01:40 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab6.tt3 -dev p22v10g -o lab6.jed -ivec NoInput.tmv -rep lab6.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab6 -if lab6.jed -j2s -log lab6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:01:40 ###########


########## Tcl recorder starts at 02/21/19 15:14:40 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab6.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab6.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:14:40 ###########


########## Tcl recorder starts at 02/21/19 15:14:43 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab6.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab6.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab6.sty
PROJECT: Lab6
WORKING_PATH: \"$proj_dir\"
MODULE: Lab6
VERILOG_FILE_LIST: lab6.h lab6.v
OUTPUT_FILE_NAME: Lab6
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab6 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab6.cmd

########## Tcl recorder end at 02/21/19 15:14:43 ###########


########## Tcl recorder starts at 02/21/19 15:14:54 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab6.edi\" -out \"Lab6.bl0\" -err automake.err -log \"Lab6.log\" -prj lab6 -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab6.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab6.bl1\" -o \"lab6.bl2\" -omod Lab6 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:14:54 ###########


########## Tcl recorder starts at 02/21/19 15:14:58 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab6.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab6.bl3 -pla -o lab6.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab6.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:14:58 ###########


########## Tcl recorder starts at 02/21/19 15:15:02 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab6.tt3 -dev p22v10g -o lab6.jed -ivec NoInput.tmv -rep lab6.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab6 -if lab6.jed -j2s -log lab6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:15:02 ###########


########## Tcl recorder starts at 02/21/19 15:22:28 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab6.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab6.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:22:28 ###########


########## Tcl recorder starts at 02/21/19 15:22:42 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab6.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab6.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab6.sty
PROJECT: Lab6
WORKING_PATH: \"$proj_dir\"
MODULE: Lab6
VERILOG_FILE_LIST: lab6.h lab6.v
OUTPUT_FILE_NAME: Lab6
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab6 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab6.cmd

########## Tcl recorder end at 02/21/19 15:22:42 ###########


########## Tcl recorder starts at 02/21/19 15:23:07 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab6.edi\" -out \"Lab6.bl0\" -err automake.err -log \"Lab6.log\" -prj lab6 -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab6.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab6.bl1\" -o \"lab6.bl2\" -omod Lab6 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:23:07 ###########


########## Tcl recorder starts at 02/21/19 15:23:10 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab6.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab6.bl3 -pla -o lab6.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab6.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:23:10 ###########


########## Tcl recorder starts at 02/21/19 15:23:13 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab6.tt3 -dev p22v10g -o lab6.jed -ivec NoInput.tmv -rep lab6.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab6 -if lab6.jed -j2s -log lab6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:23:13 ###########


########## Tcl recorder starts at 02/21/19 15:31:24 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab6.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab6.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:31:24 ###########


########## Tcl recorder starts at 02/21/19 15:31:30 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab6.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab6.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab6.sty
PROJECT: Lab6
WORKING_PATH: \"$proj_dir\"
MODULE: Lab6
VERILOG_FILE_LIST: lab6.h lab6.v
OUTPUT_FILE_NAME: Lab6
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab6 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab6.cmd

########## Tcl recorder end at 02/21/19 15:31:30 ###########


########## Tcl recorder starts at 02/21/19 15:31:59 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab6.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab6.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:31:59 ###########


########## Tcl recorder starts at 02/21/19 15:32:02 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab6.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab6.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab6.sty
PROJECT: Lab6
WORKING_PATH: \"$proj_dir\"
MODULE: Lab6
VERILOG_FILE_LIST: lab6.h lab6.v
OUTPUT_FILE_NAME: Lab6
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab6 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab6.cmd

########## Tcl recorder end at 02/21/19 15:32:03 ###########


########## Tcl recorder starts at 02/21/19 15:32:16 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab6.edi\" -out \"Lab6.bl0\" -err automake.err -log \"Lab6.log\" -prj lab6 -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab6.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab6.bl1\" -o \"lab6.bl2\" -omod Lab6 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:32:16 ###########


########## Tcl recorder starts at 02/21/19 15:32:19 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab6.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab6.bl3 -pla -o lab6.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab6.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:32:19 ###########


########## Tcl recorder starts at 02/21/19 15:32:22 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab6.tt3 -dev p22v10g -o lab6.jed -ivec NoInput.tmv -rep lab6.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab6 -if lab6.jed -j2s -log lab6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:32:22 ###########


########## Tcl recorder starts at 02/21/19 15:38:54 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab6.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab6.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:38:54 ###########


########## Tcl recorder starts at 02/21/19 15:38:59 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab6.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab6.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab6.sty
PROJECT: Lab6
WORKING_PATH: \"$proj_dir\"
MODULE: Lab6
VERILOG_FILE_LIST: lab6.h lab6.v
OUTPUT_FILE_NAME: Lab6
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab6 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab6.cmd

########## Tcl recorder end at 02/21/19 15:38:59 ###########


########## Tcl recorder starts at 02/21/19 15:39:27 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab6.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab6.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:39:27 ###########


########## Tcl recorder starts at 02/21/19 15:39:31 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab6.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab6.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab6.sty
PROJECT: Lab6
WORKING_PATH: \"$proj_dir\"
MODULE: Lab6
VERILOG_FILE_LIST: lab6.h lab6.v
OUTPUT_FILE_NAME: Lab6
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab6 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab6.cmd

########## Tcl recorder end at 02/21/19 15:39:31 ###########


########## Tcl recorder starts at 02/21/19 15:39:50 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab6.edi\" -out \"Lab6.bl0\" -err automake.err -log \"Lab6.log\" -prj lab6 -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab6.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab6.bl1\" -o \"lab6.bl2\" -omod Lab6 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:39:50 ###########


########## Tcl recorder starts at 02/21/19 15:39:53 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab6.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab6.bl3 -pla -o lab6.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab6.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:39:53 ###########


########## Tcl recorder starts at 02/21/19 15:39:56 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab6.tt3 -dev p22v10g -o lab6.jed -ivec NoInput.tmv -rep lab6.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab6 -if lab6.jed -j2s -log lab6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/21/19 15:39:56 ###########

