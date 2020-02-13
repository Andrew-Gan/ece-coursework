
########## Tcl recorder starts at 02/23/19 14:50:21 ##########

set version "1.7"
set proj_dir "U:/Desktop/Lab7"
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
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7_decode.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:50:21 ###########


########## Tcl recorder starts at 02/23/19 14:50:30 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7_decode.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:50:30 ###########


########## Tcl recorder starts at 02/23/19 14:51:21 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_decode.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_decode.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7_decode.sty
PROJECT: Lab7_decode
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_decode
VERILOG_FILE_LIST: lab7_decode.h lab7_decode.v
OUTPUT_FILE_NAME: Lab7_decode
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_decode -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_decode.cmd

########## Tcl recorder end at 02/23/19 14:51:21 ###########


########## Tcl recorder starts at 02/23/19 14:51:31 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab7_decode.edi\" -out \"Lab7_decode.bl0\" -err automake.err -log \"Lab7_decode.log\" -prj lab7_decode -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab7_decode.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab7_decode.bl1\" -o \"lab7_decode.bl2\" -omod Lab7_decode -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:51:31 ###########


########## Tcl recorder starts at 02/23/19 14:51:34 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab7_decode.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab7_decode.bl3 -pla -o lab7_decode.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab7_decode.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:51:34 ###########


########## Tcl recorder starts at 02/23/19 14:52:45 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7_decode.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:52:45 ###########


########## Tcl recorder starts at 02/23/19 14:52:48 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_decode.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_decode.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7_decode.sty
PROJECT: Lab7_decode
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_decode
VERILOG_FILE_LIST: lab7_decode.h lab7_decode.v
OUTPUT_FILE_NAME: Lab7_decode
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_decode -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_decode.cmd

########## Tcl recorder end at 02/23/19 14:52:48 ###########


########## Tcl recorder starts at 02/23/19 14:52:56 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab7_decode.edi\" -out \"Lab7_decode.bl0\" -err automake.err -log \"Lab7_decode.log\" -prj lab7_decode -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab7_decode.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab7_decode.bl1\" -o \"lab7_decode.bl2\" -omod Lab7_decode -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:52:57 ###########


########## Tcl recorder starts at 02/23/19 14:53:01 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab7_decode.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab7_decode.bl3 -pla -o lab7_decode.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab7_decode.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:53:01 ###########


########## Tcl recorder starts at 02/23/19 14:53:32 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab7_decode.tt3 -dev p22v10g -o lab7_decode.jed -ivec NoInput.tmv -rep lab7_decode.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab7_decode -if lab7_decode.jed -j2s -log lab7_decode.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:53:32 ###########


########## Tcl recorder starts at 02/23/19 15:22:26 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7_decode.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:22:26 ###########


########## Tcl recorder starts at 02/23/19 15:22:33 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_decode.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_decode.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7_decode.sty
PROJECT: Lab7_decode
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_decode
VERILOG_FILE_LIST: lab7_decode.h lab7_decode.v
OUTPUT_FILE_NAME: Lab7_decode
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_decode -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_decode.cmd

########## Tcl recorder end at 02/23/19 15:22:33 ###########


########## Tcl recorder starts at 02/23/19 15:24:22 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7_decode.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:24:22 ###########


########## Tcl recorder starts at 02/23/19 15:24:24 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_decode.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_decode.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7_decode.sty
PROJECT: Lab7_decode
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_decode
VERILOG_FILE_LIST: lab7_decode.h lab7_decode.v
OUTPUT_FILE_NAME: Lab7_decode
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_decode -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_decode.cmd

########## Tcl recorder end at 02/23/19 15:24:24 ###########


########## Tcl recorder starts at 02/23/19 15:24:34 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab7_decode.edi\" -out \"Lab7_decode.bl0\" -err automake.err -log \"Lab7_decode.log\" -prj lab7_decode -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab7_decode.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab7_decode.bl1\" -o \"lab7_decode.bl2\" -omod Lab7_decode -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:24:34 ###########


########## Tcl recorder starts at 02/23/19 15:24:38 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab7_decode.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab7_decode.bl3 -pla -o lab7_decode.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab7_decode.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:24:38 ###########


########## Tcl recorder starts at 02/23/19 15:24:40 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab7_decode.tt3 -dev p22v10g -o lab7_decode.jed -ivec NoInput.tmv -rep lab7_decode.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab7_decode -if lab7_decode.jed -j2s -log lab7_decode.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:24:40 ###########


########## Tcl recorder starts at 02/23/19 15:35:20 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7_decode.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:35:20 ###########


########## Tcl recorder starts at 02/23/19 15:35:48 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7_decode.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:35:48 ###########


########## Tcl recorder starts at 02/23/19 15:38:59 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7_decode.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:38:59 ###########


########## Tcl recorder starts at 02/23/19 15:40:11 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7_decode.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:40:11 ###########


########## Tcl recorder starts at 02/23/19 15:41:00 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_decode.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_decode.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7_decode.sty
PROJECT: Lab7_decode
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_decode
VERILOG_FILE_LIST: lab7_decode.h lab7_decode.v
OUTPUT_FILE_NAME: Lab7_decode
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_decode -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_decode.cmd

########## Tcl recorder end at 02/23/19 15:41:00 ###########


########## Tcl recorder starts at 02/23/19 15:41:26 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7_decode.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:41:26 ###########


########## Tcl recorder starts at 02/23/19 15:41:29 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_decode.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_decode.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7_decode.sty
PROJECT: Lab7_decode
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_decode
VERILOG_FILE_LIST: lab7_decode.h lab7_decode.v
OUTPUT_FILE_NAME: Lab7_decode
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_decode -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_decode.cmd

########## Tcl recorder end at 02/23/19 15:41:29 ###########


########## Tcl recorder starts at 02/23/19 15:42:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7_decode.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:42:01 ###########


########## Tcl recorder starts at 02/23/19 15:42:17 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_decode.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_decode.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7_decode.sty
PROJECT: Lab7_decode
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_decode
VERILOG_FILE_LIST: lab7_decode.h lab7_decode.v
OUTPUT_FILE_NAME: Lab7_decode
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_decode -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_decode.cmd

########## Tcl recorder end at 02/23/19 15:42:17 ###########


########## Tcl recorder starts at 02/23/19 15:42:49 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7_decode.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:42:49 ###########


########## Tcl recorder starts at 02/23/19 15:42:52 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_decode.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_decode.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7_decode.sty
PROJECT: Lab7_decode
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_decode
VERILOG_FILE_LIST: lab7_decode.h lab7_decode.v
OUTPUT_FILE_NAME: Lab7_decode
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_decode -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_decode.cmd

########## Tcl recorder end at 02/23/19 15:42:52 ###########


########## Tcl recorder starts at 02/23/19 15:43:21 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7_decode.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:43:21 ###########


########## Tcl recorder starts at 02/23/19 15:43:23 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_decode.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_decode.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7_decode.sty
PROJECT: Lab7_decode
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_decode
VERILOG_FILE_LIST: lab7_decode.h lab7_decode.v
OUTPUT_FILE_NAME: Lab7_decode
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_decode -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_decode.cmd

########## Tcl recorder end at 02/23/19 15:43:23 ###########


########## Tcl recorder starts at 02/23/19 15:45:17 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7_decode.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:45:17 ###########


########## Tcl recorder starts at 02/23/19 15:45:20 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_decode.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_decode.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7_decode.sty
PROJECT: Lab7_decode
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_decode
VERILOG_FILE_LIST: lab7_decode.h lab7_decode.v
OUTPUT_FILE_NAME: Lab7_decode
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_decode -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_decode.cmd

########## Tcl recorder end at 02/23/19 15:45:20 ###########


########## Tcl recorder starts at 02/23/19 15:45:32 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab7_decode.edi\" -out \"Lab7_decode.bl0\" -err automake.err -log \"Lab7_decode.log\" -prj lab7_decode -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab7_decode.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab7_decode.bl1\" -o \"lab7_decode.bl2\" -omod Lab7_decode -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:45:32 ###########


########## Tcl recorder starts at 02/23/19 15:45:36 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab7_decode.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab7_decode.bl3 -pla -o lab7_decode.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab7_decode.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:45:36 ###########


########## Tcl recorder starts at 02/23/19 15:45:39 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab7_decode.tt3 -dev p22v10g -o lab7_decode.jed -ivec NoInput.tmv -rep lab7_decode.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab7_decode -if lab7_decode.jed -j2s -log lab7_decode.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:45:39 ###########


########## Tcl recorder starts at 02/23/19 15:51:43 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7_decode.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:51:43 ###########


########## Tcl recorder starts at 02/23/19 15:52:03 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7_decode.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:52:03 ###########


########## Tcl recorder starts at 02/23/19 15:53:37 ##########

# Commands to make the Process: 
# Chip Report
if [catch {open Lab7_decode.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_decode.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7_decode.sty
PROJECT: Lab7_decode
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_decode
VERILOG_FILE_LIST: lab7_decode.h lab7_decode.v
OUTPUT_FILE_NAME: Lab7_decode
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_decode -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_decode.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab7_decode.edi\" -out \"Lab7_decode.bl0\" -err automake.err -log \"Lab7_decode.log\" -prj lab7_decode -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab7_decode.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab7_decode.bl1\" -o \"lab7_decode.bl2\" -omod Lab7_decode -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" lab7_decode.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab7_decode.bl3 -pla -o lab7_decode.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab7_decode.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fuseasm\" lab7_decode.tt3 -dev p22v10g -o lab7_decode.jed -ivec NoInput.tmv -rep lab7_decode.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:53:37 ###########


########## Tcl recorder starts at 02/23/19 15:57:20 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7_decode.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:57:20 ###########


########## Tcl recorder starts at 02/23/19 15:57:26 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open Lab7_decode.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_decode.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7_decode.sty
PROJECT: Lab7_decode
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_decode
VERILOG_FILE_LIST: lab7_decode.h lab7_decode.v
OUTPUT_FILE_NAME: Lab7_decode
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_decode -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_decode.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab7_decode.edi\" -out \"Lab7_decode.bl0\" -err automake.err -log \"Lab7_decode.log\" -prj lab7_decode -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab7_decode.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab7_decode.bl1\" -o \"lab7_decode.bl2\" -omod Lab7_decode -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" lab7_decode.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab7_decode.bl3 -pla -o lab7_decode.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab7_decode.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:57:26 ###########


########## Tcl recorder starts at 02/23/19 15:57:39 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab7_decode.tt3 -dev p22v10g -o lab7_decode.jed -ivec NoInput.tmv -rep lab7_decode.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab7_decode -if lab7_decode.jed -j2s -log lab7_decode.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 15:57:39 ###########


########## Tcl recorder starts at 02/23/19 16:08:11 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7_decode.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:08:11 ###########


########## Tcl recorder starts at 02/23/19 16:08:37 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_decode.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_decode.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7_decode.sty
PROJECT: Lab7_decode
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_decode
VERILOG_FILE_LIST: lab7_decode.h lab7_decode.v
OUTPUT_FILE_NAME: Lab7_decode
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_decode -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_decode.cmd

########## Tcl recorder end at 02/23/19 16:08:37 ###########


########## Tcl recorder starts at 02/23/19 16:08:53 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab7_decode.edi\" -out \"Lab7_decode.bl0\" -err automake.err -log \"Lab7_decode.log\" -prj lab7_decode -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab7_decode.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab7_decode.bl1\" -o \"lab7_decode.bl2\" -omod Lab7_decode -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:08:53 ###########


########## Tcl recorder starts at 02/23/19 16:08:56 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab7_decode.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab7_decode.bl3 -pla -o lab7_decode.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab7_decode.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:08:56 ###########


########## Tcl recorder starts at 02/23/19 16:08:59 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab7_decode.tt3 -dev p22v10g -o lab7_decode.jed -ivec NoInput.tmv -rep lab7_decode.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab7_decode -if lab7_decode.jed -j2s -log lab7_decode.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:08:59 ###########


########## Tcl recorder starts at 02/23/19 16:17:53 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7_decode.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:17:53 ###########


########## Tcl recorder starts at 02/23/19 16:18:43 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7_decode.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:18:43 ###########


########## Tcl recorder starts at 02/23/19 16:18:46 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_decode.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_decode.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7_decode.sty
PROJECT: Lab7_decode
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_decode
VERILOG_FILE_LIST: lab7_decode.h lab7_decode.v
OUTPUT_FILE_NAME: Lab7_decode
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_decode -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_decode.cmd

########## Tcl recorder end at 02/23/19 16:18:46 ###########


########## Tcl recorder starts at 02/23/19 16:18:57 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab7_decode.edi\" -out \"Lab7_decode.bl0\" -err automake.err -log \"Lab7_decode.log\" -prj lab7_decode -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab7_decode.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab7_decode.bl1\" -o \"lab7_decode.bl2\" -omod Lab7_decode -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:18:57 ###########


########## Tcl recorder starts at 02/23/19 16:19:01 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab7_decode.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab7_decode.bl3 -pla -o lab7_decode.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab7_decode.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:19:01 ###########


########## Tcl recorder starts at 02/23/19 16:19:04 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab7_decode.tt3 -dev p22v10g -o lab7_decode.jed -ivec NoInput.tmv -rep lab7_decode.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab7_decode -if lab7_decode.jed -j2s -log lab7_decode.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:19:04 ###########


########## Tcl recorder starts at 02/23/19 16:28:02 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7_decode.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:28:02 ###########


########## Tcl recorder starts at 02/23/19 16:28:54 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_decode.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_decode.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7_decode.sty
PROJECT: Lab7_decode
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_decode
VERILOG_FILE_LIST: lab7_decode.h lab7_decode.v
OUTPUT_FILE_NAME: Lab7_decode
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_decode -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_decode.cmd

########## Tcl recorder end at 02/23/19 16:28:54 ###########


########## Tcl recorder starts at 02/23/19 16:29:17 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab7_decode.edi\" -out \"Lab7_decode.bl0\" -err automake.err -log \"Lab7_decode.log\" -prj lab7_decode -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab7_decode.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab7_decode.bl1\" -o \"lab7_decode.bl2\" -omod Lab7_decode -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:29:17 ###########


########## Tcl recorder starts at 02/23/19 16:29:22 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab7_decode.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab7_decode.bl3 -pla -o lab7_decode.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab7_decode.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:29:22 ###########


########## Tcl recorder starts at 02/23/19 16:29:24 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab7_decode.tt3 -dev p22v10g -o lab7_decode.jed -ivec NoInput.tmv -rep lab7_decode.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab7_decode -if lab7_decode.jed -j2s -log lab7_decode.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:29:24 ###########

