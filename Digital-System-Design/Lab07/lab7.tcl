
########## Tcl recorder starts at 02/23/19 13:41:35 ##########

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
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 13:41:35 ###########


########## Tcl recorder starts at 02/23/19 13:43:00 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 13:43:00 ###########


########## Tcl recorder starts at 02/23/19 13:55:14 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 13:55:14 ###########


########## Tcl recorder starts at 02/23/19 13:55:38 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 13:55:38 ###########


########## Tcl recorder starts at 02/23/19 13:55:46 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7.sty
PROJECT: Lab7
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7
VERILOG_FILE_LIST: lab7.h lab7.v
OUTPUT_FILE_NAME: Lab7
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7.cmd

########## Tcl recorder end at 02/23/19 13:55:46 ###########


########## Tcl recorder starts at 02/23/19 13:56:32 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 13:56:32 ###########


########## Tcl recorder starts at 02/23/19 13:56:36 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7.sty
PROJECT: Lab7
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7
VERILOG_FILE_LIST: lab7.h lab7.v
OUTPUT_FILE_NAME: Lab7
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7.cmd

########## Tcl recorder end at 02/23/19 13:56:36 ###########


########## Tcl recorder starts at 02/23/19 13:58:07 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 13:58:07 ###########


########## Tcl recorder starts at 02/23/19 13:58:10 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7.sty
PROJECT: Lab7
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7
VERILOG_FILE_LIST: lab7.h lab7.v
OUTPUT_FILE_NAME: Lab7
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7.cmd

########## Tcl recorder end at 02/23/19 13:58:10 ###########


########## Tcl recorder starts at 02/23/19 13:58:30 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 13:58:30 ###########


########## Tcl recorder starts at 02/23/19 13:58:33 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7.sty
PROJECT: Lab7
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7
VERILOG_FILE_LIST: lab7.h lab7.v
OUTPUT_FILE_NAME: Lab7
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7.cmd

########## Tcl recorder end at 02/23/19 13:58:33 ###########


########## Tcl recorder starts at 02/23/19 13:58:55 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 13:58:55 ###########


########## Tcl recorder starts at 02/23/19 13:59:53 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 13:59:53 ###########


########## Tcl recorder starts at 02/23/19 13:59:59 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7.sty
PROJECT: Lab7
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7
VERILOG_FILE_LIST: lab7.h lab7.v
OUTPUT_FILE_NAME: Lab7
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7.cmd

########## Tcl recorder end at 02/23/19 13:59:59 ###########


########## Tcl recorder starts at 02/23/19 14:03:02 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab7.edi\" -out \"Lab7.bl0\" -err automake.err -log \"Lab7.log\" -prj lab7 -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab7.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab7.bl1\" -o \"lab7.bl2\" -omod Lab7 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:03:03 ###########


########## Tcl recorder starts at 02/23/19 14:03:07 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab7.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab7.bl3 -pla -o lab7.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab7.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:03:07 ###########


########## Tcl recorder starts at 02/23/19 14:03:11 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab7.tt3 -dev p22v10g -o lab7.jed -ivec NoInput.tmv -rep lab7.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab7 -if lab7.jed -j2s -log lab7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:03:11 ###########


########## Tcl recorder starts at 02/23/19 14:17:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decoder.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:17:01 ###########


########## Tcl recorder starts at 02/23/19 14:32:24 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decoder.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:32:24 ###########


########## Tcl recorder starts at 02/23/19 14:33:28 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decoder.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:33:28 ###########


########## Tcl recorder starts at 02/23/19 14:34:54 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decoder.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:34:54 ###########


########## Tcl recorder starts at 02/23/19 14:35:06 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_decoder.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_decoder.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7.sty
PROJECT: Lab7_decoder
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_decoder
VERILOG_FILE_LIST: lab7.h lab7_decoder.v
OUTPUT_FILE_NAME: Lab7_decoder
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_decoder -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_decoder.cmd

########## Tcl recorder end at 02/23/19 14:35:06 ###########


########## Tcl recorder starts at 02/23/19 14:35:24 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decoder.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:35:24 ###########


########## Tcl recorder starts at 02/23/19 14:35:28 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_decoder.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_decoder.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7.sty
PROJECT: Lab7_decoder
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_decoder
VERILOG_FILE_LIST: lab7.h lab7_decoder.v
OUTPUT_FILE_NAME: Lab7_decoder
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_decoder -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_decoder.cmd

########## Tcl recorder end at 02/23/19 14:35:29 ###########


########## Tcl recorder starts at 02/23/19 14:35:53 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decoder.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:35:53 ###########


########## Tcl recorder starts at 02/23/19 14:35:58 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_decoder.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_decoder.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7.sty
PROJECT: Lab7_decoder
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_decoder
VERILOG_FILE_LIST: lab7.h lab7_decoder.v
OUTPUT_FILE_NAME: Lab7_decoder
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_decoder -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_decoder.cmd

########## Tcl recorder end at 02/23/19 14:35:58 ###########


########## Tcl recorder starts at 02/23/19 14:43:15 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decoder.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:43:15 ###########


########## Tcl recorder starts at 02/23/19 14:43:26 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_decoder.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_decoder.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7.sty
PROJECT: Lab7_decoder
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_decoder
VERILOG_FILE_LIST: lab7.h lab7_decoder.v
OUTPUT_FILE_NAME: Lab7_decoder
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_decoder -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_decoder.cmd

########## Tcl recorder end at 02/23/19 14:43:26 ###########


########## Tcl recorder starts at 02/23/19 14:43:40 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/iblflink\" \"Lab7.bl1\" -o \"lab7.bl2\" -omod Lab7 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:43:40 ###########


########## Tcl recorder starts at 02/23/19 14:43:44 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab7.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab7.bl3 -pla -o lab7.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab7.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:43:44 ###########


########## Tcl recorder starts at 02/23/19 14:43:47 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab7.tt3 -dev p22v10g -o lab7.jed -ivec NoInput.tmv -rep lab7.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab7 -if lab7.jed -j2s -log lab7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:43:47 ###########


########## Tcl recorder starts at 02/23/19 14:44:23 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decoder.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:44:23 ###########


########## Tcl recorder starts at 02/23/19 14:44:26 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_decoder.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_decoder.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7.sty
PROJECT: Lab7_decoder
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_decoder
VERILOG_FILE_LIST: lab7.h lab7_decoder.v
OUTPUT_FILE_NAME: Lab7_decoder
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_decoder -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_decoder.cmd

########## Tcl recorder end at 02/23/19 14:44:27 ###########


########## Tcl recorder starts at 02/23/19 14:44:42 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab7_decoder.edi\" -out \"Lab7_decoder.bl0\" -err automake.err -log \"Lab7_decoder.log\" -prj lab7 -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab7_decoder.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab7_decoder.bl1\" -o \"lab7.bl2\" -omod Lab7_decoder -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:44:42 ###########


########## Tcl recorder starts at 02/23/19 14:44:45 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab7.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab7.bl3 -pla -o lab7.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab7.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:44:45 ###########


########## Tcl recorder starts at 02/23/19 14:45:32 ##########

# Commands to make the Process: 
# Chip Report
if [runCmd "\"$cpld_bin/fuseasm\" lab7.tt3 -dev p22v10g -o lab7.jed -ivec NoInput.tmv -rep lab7.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:45:32 ###########


########## Tcl recorder starts at 02/23/19 14:46:09 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:46:09 ###########


########## Tcl recorder starts at 02/23/19 14:46:19 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/iblflink\" \"Lab7_decoder.bl1\" -o \"lab7.bl2\" -omod Lab7_decoder -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:46:19 ###########


########## Tcl recorder starts at 02/23/19 14:46:24 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab7.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab7.bl3 -pla -o lab7.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab7.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:46:24 ###########


########## Tcl recorder starts at 02/23/19 14:46:30 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab7.tt3 -dev p22v10g -o lab7.jed -ivec NoInput.tmv -rep lab7.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab7 -if lab7.jed -j2s -log lab7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:46:30 ###########


########## Tcl recorder starts at 02/23/19 14:49:17 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:49:17 ###########


########## Tcl recorder starts at 02/23/19 14:51:10 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 14:51:10 ###########


########## Tcl recorder starts at 02/23/19 16:41:49 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:41:49 ###########


########## Tcl recorder starts at 02/23/19 16:42:15 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:42:15 ###########


########## Tcl recorder starts at 02/23/19 16:42:20 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:42:20 ###########


########## Tcl recorder starts at 02/23/19 16:42:24 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7.sty
PROJECT: Lab7
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7
VERILOG_FILE_LIST: lab7.h lab7.v
OUTPUT_FILE_NAME: Lab7
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7.cmd

########## Tcl recorder end at 02/23/19 16:42:24 ###########


########## Tcl recorder starts at 02/23/19 16:42:41 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab7.edi\" -out \"Lab7.bl0\" -err automake.err -log \"Lab7.log\" -prj lab7 -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab7.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab7.bl1\" -o \"lab7.bl2\" -omod Lab7 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:42:41 ###########


########## Tcl recorder starts at 02/23/19 16:42:43 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab7.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab7.bl3 -pla -o lab7.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab7.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:42:43 ###########


########## Tcl recorder starts at 02/23/19 16:42:54 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab7.tt3 -dev p22v10g -o lab7.jed -ivec NoInput.tmv -rep lab7.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab7 -if lab7.jed -j2s -log lab7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:42:54 ###########


########## Tcl recorder starts at 02/23/19 16:43:21 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:43:21 ###########


########## Tcl recorder starts at 02/23/19 16:43:25 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7.sty
PROJECT: Lab7
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7
VERILOG_FILE_LIST: lab7.h lab7.v
OUTPUT_FILE_NAME: Lab7
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7.cmd

########## Tcl recorder end at 02/23/19 16:43:25 ###########


########## Tcl recorder starts at 02/23/19 16:43:40 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab7.edi\" -out \"Lab7.bl0\" -err automake.err -log \"Lab7.log\" -prj lab7 -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab7.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab7.bl1\" -o \"lab7.bl2\" -omod Lab7 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:43:40 ###########


########## Tcl recorder starts at 02/23/19 16:43:43 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab7.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab7.bl3 -pla -o lab7.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab7.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:43:43 ###########


########## Tcl recorder starts at 02/23/19 16:43:45 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab7.tt3 -dev p22v10g -o lab7.jed -ivec NoInput.tmv -rep lab7.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab7 -if lab7.jed -j2s -log lab7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:43:45 ###########


########## Tcl recorder starts at 02/23/19 16:48:27 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:48:27 ###########


########## Tcl recorder starts at 02/23/19 16:50:37 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:50:37 ###########


########## Tcl recorder starts at 02/23/19 16:50:53 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:50:53 ###########


########## Tcl recorder starts at 02/23/19 16:51:19 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_dorm.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:51:19 ###########


########## Tcl recorder starts at 02/23/19 16:51:41 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_dorm.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:51:41 ###########


########## Tcl recorder starts at 02/23/19 16:52:39 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_dorm.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:52:40 ###########


########## Tcl recorder starts at 02/23/19 16:52:57 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_decode.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:52:57 ###########


########## Tcl recorder starts at 02/23/19 16:53:24 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 16:53:24 ###########


########## Tcl recorder starts at 02/23/19 17:12:53 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_dorm.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 17:12:53 ###########


########## Tcl recorder starts at 02/23/19 17:13:00 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_dorm.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_dorm.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7.sty
PROJECT: Lab7_dorm
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_dorm
VERILOG_FILE_LIST: lab7.h lab7_dorm.v
OUTPUT_FILE_NAME: Lab7_dorm
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_dorm -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_dorm.cmd

########## Tcl recorder end at 02/23/19 17:13:00 ###########


########## Tcl recorder starts at 02/23/19 17:14:34 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_dorm.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 17:14:34 ###########


########## Tcl recorder starts at 02/23/19 17:14:36 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_dorm.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_dorm.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7.sty
PROJECT: Lab7_dorm
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_dorm
VERILOG_FILE_LIST: lab7.h lab7_dorm.v
OUTPUT_FILE_NAME: Lab7_dorm
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_dorm -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_dorm.cmd

########## Tcl recorder end at 02/23/19 17:14:37 ###########


########## Tcl recorder starts at 02/23/19 17:14:52 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab7_dorm.edi\" -out \"Lab7_dorm.bl0\" -err automake.err -log \"Lab7_dorm.log\" -prj lab7 -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab7_dorm.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab7_dorm.bl1\" -o \"lab7.bl2\" -omod Lab7_dorm -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 17:14:52 ###########


########## Tcl recorder starts at 02/23/19 17:14:56 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab7.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab7.bl3 -pla -o lab7.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab7.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 17:14:56 ###########


########## Tcl recorder starts at 02/23/19 17:14:59 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab7.tt3 -dev p22v10g -o lab7.jed -ivec NoInput.tmv -rep lab7.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab7 -if lab7.jed -j2s -log lab7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 17:14:59 ###########


########## Tcl recorder starts at 02/23/19 17:17:58 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7_dorm.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 17:17:58 ###########


########## Tcl recorder starts at 02/23/19 17:18:02 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_dorm.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_dorm.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7.sty
PROJECT: Lab7_dorm
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_dorm
VERILOG_FILE_LIST: lab7.h lab7_dorm.v
OUTPUT_FILE_NAME: Lab7_dorm
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7_dorm -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7_dorm.cmd

########## Tcl recorder end at 02/23/19 17:18:02 ###########


########## Tcl recorder starts at 02/23/19 17:18:29 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab7_dorm.edi\" -out \"Lab7_dorm.bl0\" -err automake.err -log \"Lab7_dorm.log\" -prj lab7 -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab7_dorm.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab7_dorm.bl1\" -o \"lab7.bl2\" -omod Lab7_dorm -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 17:18:29 ###########


########## Tcl recorder starts at 02/23/19 17:18:34 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab7.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab7.bl3 -pla -o lab7.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab7.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 17:18:34 ###########


########## Tcl recorder starts at 02/23/19 17:18:35 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab7.tt3 -dev p22v10g -o lab7.jed -ivec NoInput.tmv -rep lab7.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab7 -if lab7.jed -j2s -log lab7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 17:18:35 ###########


########## Tcl recorder starts at 02/23/19 17:20:46 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7_decode.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7_decode.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7.sty
PROJECT: Lab7_decode
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7_decode
VERILOG_FILE_LIST: lab7.h lab7_decode.v
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

########## Tcl recorder end at 02/23/19 17:20:46 ###########


########## Tcl recorder starts at 02/23/19 17:22:26 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab7_decode.edi\" -out \"Lab7_decode.bl0\" -err automake.err -log \"Lab7_decode.log\" -prj lab7 -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
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
if [runCmd "\"$cpld_bin/iblflink\" \"Lab7_decode.bl1\" -o \"lab7.bl2\" -omod Lab7_decode -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 17:22:26 ###########


########## Tcl recorder starts at 02/23/19 17:22:30 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab7.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab7.bl3 -pla -o lab7.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab7.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 17:22:30 ###########


########## Tcl recorder starts at 02/23/19 17:22:32 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab7.tt3 -dev p22v10g -o lab7.jed -ivec NoInput.tmv -rep lab7.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab7 -if lab7.jed -j2s -log lab7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/19 17:22:32 ###########


########## Tcl recorder starts at 02/28/19 14:59:49 ##########

# Commands to make the Process: 
# Synplify Synthesize Verilog File
if [catch {open Lab7.cmd w} rspFile] {
	puts stderr "Cannot create response file Lab7.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab7.sty
PROJECT: Lab7
WORKING_PATH: \"$proj_dir\"
MODULE: Lab7
VERILOG_FILE_LIST: lab7.h lab7.v
OUTPUT_FILE_NAME: Lab7
SUFFIX_NAME: edi
Vlog_std_v2001: true
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e Lab7 -target ispGAL -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete Lab7.cmd

########## Tcl recorder end at 02/28/19 14:59:49 ###########


########## Tcl recorder starts at 02/28/19 15:00:18 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/edif2blf\" -edf \"Lab7.edi\" -out \"Lab7.bl0\" -err automake.err -log \"Lab7.log\" -prj lab7 -lib \"$install_dir/ispcpld/dat/mach.edn\" -cvt YES -net_Vcc VCC -net_GND GND -nbx -dse -tlw"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" \"Lab7.bl0\" -red bypin choose -collapse -pterms 8 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblflink\" \"Lab7.bl1\" -o \"lab7.bl2\" -omod Lab7 -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/19 15:00:18 ###########


########## Tcl recorder starts at 02/28/19 15:00:25 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/iblifopt\" lab7.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab7.bl3 -pla -o lab7.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab7.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/19 15:00:26 ###########


########## Tcl recorder starts at 02/28/19 15:00:38 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/fuseasm\" lab7.tt3 -dev p22v10g -o lab7.jed -ivec NoInput.tmv -rep lab7.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab7 -if lab7.jed -j2s -log lab7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/19 15:00:38 ###########


########## Tcl recorder starts at 02/28/19 15:21:46 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" \"lab7.v\" -p \"$install_dir/ispcpld/generic\" -predefine lab7.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/19 15:21:46 ###########


########## Tcl recorder starts at 02/28/19 15:22:14 ##########

# Commands to make the Process: 
# Link Design
if [runCmd "\"$cpld_bin/iblflink\" \"Lab7_decode.bl1\" -o \"lab7.bl2\" -omod Lab7_decode -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/19 15:22:14 ###########


########## Tcl recorder starts at 02/28/19 15:22:17 ##########

# Commands to make the Process: 
# Create Fuse Map
if [runCmd "\"$cpld_bin/iblifopt\" lab7.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab7.bl3 -pla -o lab7.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab7.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fuseasm\" lab7.tt3 -dev p22v10g -o lab7.jed -ivec NoInput.tmv -rep lab7.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab7 -if lab7.jed -j2s -log lab7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/19 15:22:17 ###########


########## Tcl recorder starts at 02/28/19 15:24:27 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/iblflink\" \"Lab7_dorm.bl1\" -o \"lab7.bl2\" -omod Lab7_dorm -family -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/iblifopt\" lab7.bl2 -red bypin choose -sweep -collapse all -pterms 8 -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/idiofft\" lab7.bl3 -pla -o lab7.tt2 -dev p22v10g -define N -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fit\" lab7.tt2 -dev p22v10g -str -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/fuseasm\" lab7.tt3 -dev p22v10g -o lab7.jed -ivec NoInput.tmv -rep lab7.rpt -doc brief -con ptblown -for brief -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/19 15:24:27 ###########

