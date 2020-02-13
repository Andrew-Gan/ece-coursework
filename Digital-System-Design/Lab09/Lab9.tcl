
########## Tcl recorder starts at 03/15/19 17:54:07 ##########

set version "1.7"
set proj_dir "W:/ecn.data/Desktop/Lab9"
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
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/15/19 17:54:07 ###########


########## Tcl recorder starts at 03/15/19 17:54:58 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/15/19 17:54:58 ###########


########## Tcl recorder starts at 03/15/19 17:55:32 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/15/19 17:55:32 ###########


########## Tcl recorder starts at 03/15/19 17:55:47 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/15/19 17:55:47 ###########


########## Tcl recorder starts at 03/20/19 18:37:30 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 18:37:31 ###########


########## Tcl recorder starts at 03/20/19 18:37:59 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" binary_counter.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 18:37:59 ###########


########## Tcl recorder starts at 03/20/19 18:42:55 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" binary_counter.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 18:42:56 ###########


########## Tcl recorder starts at 03/20/19 18:46:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" binary_counter.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 18:46:01 ###########


########## Tcl recorder starts at 03/20/19 18:52:40 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 18:52:40 ###########


########## Tcl recorder starts at 03/20/19 18:53:23 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 18:53:23 ###########


########## Tcl recorder starts at 03/20/19 18:55:16 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 18:55:16 ###########


########## Tcl recorder starts at 03/20/19 18:55:24 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 18:55:24 ###########


########## Tcl recorder starts at 03/20/19 18:58:18 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 18:58:18 ###########


########## Tcl recorder starts at 03/20/19 18:58:24 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 18:58:24 ###########


########## Tcl recorder starts at 03/20/19 18:58:51 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 18:58:51 ###########


########## Tcl recorder starts at 03/20/19 19:08:12 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:08:12 ###########


########## Tcl recorder starts at 03/20/19 19:08:19 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:08:19 ###########


########## Tcl recorder starts at 03/20/19 19:09:06 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:09:06 ###########


########## Tcl recorder starts at 03/20/19 19:09:14 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:09:14 ###########


########## Tcl recorder starts at 03/20/19 19:09:30 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:09:30 ###########


########## Tcl recorder starts at 03/20/19 19:09:33 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:09:33 ###########


########## Tcl recorder starts at 03/20/19 19:14:32 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:14:32 ###########


########## Tcl recorder starts at 03/20/19 19:14:36 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:14:36 ###########


########## Tcl recorder starts at 03/20/19 19:17:14 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:17:14 ###########


########## Tcl recorder starts at 03/20/19 19:18:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:18:01 ###########


########## Tcl recorder starts at 03/20/19 19:18:06 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:18:06 ###########


########## Tcl recorder starts at 03/20/19 19:25:09 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:25:09 ###########


########## Tcl recorder starts at 03/20/19 19:25:56 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:25:56 ###########


########## Tcl recorder starts at 03/20/19 19:33:35 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:33:35 ###########


########## Tcl recorder starts at 03/20/19 19:33:42 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:33:42 ###########


########## Tcl recorder starts at 03/20/19 19:34:19 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:34:19 ###########


########## Tcl recorder starts at 03/20/19 19:34:36 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:34:36 ###########


########## Tcl recorder starts at 03/20/19 19:34:40 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:34:40 ###########


########## Tcl recorder starts at 03/20/19 19:42:18 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:42:18 ###########


########## Tcl recorder starts at 03/20/19 19:42:23 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:42:23 ###########


########## Tcl recorder starts at 03/20/19 19:44:00 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:44:00 ###########


########## Tcl recorder starts at 03/20/19 19:47:24 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:47:24 ###########


########## Tcl recorder starts at 03/20/19 19:47:30 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:47:30 ###########


########## Tcl recorder starts at 03/20/19 19:48:09 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:48:09 ###########


########## Tcl recorder starts at 03/20/19 19:48:15 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:48:15 ###########


########## Tcl recorder starts at 03/20/19 19:53:14 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:53:14 ###########


########## Tcl recorder starts at 03/20/19 19:53:19 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 19:53:19 ###########


########## Tcl recorder starts at 03/20/19 20:03:00 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:03:00 ###########


########## Tcl recorder starts at 03/20/19 20:03:04 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:03:04 ###########


########## Tcl recorder starts at 03/20/19 20:12:38 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:12:38 ###########


########## Tcl recorder starts at 03/20/19 20:12:52 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:12:53 ###########


########## Tcl recorder starts at 03/20/19 20:13:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:13:13 ###########


########## Tcl recorder starts at 03/20/19 20:15:36 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:15:36 ###########


########## Tcl recorder starts at 03/20/19 20:15:44 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:15:44 ###########


########## Tcl recorder starts at 03/20/19 20:16:25 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:16:25 ###########


########## Tcl recorder starts at 03/20/19 20:16:36 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:16:36 ###########


########## Tcl recorder starts at 03/20/19 20:18:31 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:18:31 ###########


########## Tcl recorder starts at 03/20/19 20:22:02 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:22:02 ###########


########## Tcl recorder starts at 03/20/19 20:22:07 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:22:07 ###########


########## Tcl recorder starts at 03/20/19 20:24:42 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:24:42 ###########


########## Tcl recorder starts at 03/20/19 20:24:46 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:24:46 ###########


########## Tcl recorder starts at 03/20/19 20:25:15 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:25:15 ###########


########## Tcl recorder starts at 03/20/19 20:25:19 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:25:19 ###########


########## Tcl recorder starts at 03/20/19 20:29:05 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:29:05 ###########


########## Tcl recorder starts at 03/20/19 20:29:31 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:29:31 ###########


########## Tcl recorder starts at 03/20/19 20:34:18 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:34:18 ###########


########## Tcl recorder starts at 03/20/19 20:34:27 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:34:27 ###########


########## Tcl recorder starts at 03/20/19 20:36:28 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:36:28 ###########


########## Tcl recorder starts at 03/20/19 20:36:37 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:36:37 ###########


########## Tcl recorder starts at 03/20/19 20:40:39 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:40:39 ###########


########## Tcl recorder starts at 03/20/19 20:40:45 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:40:45 ###########


########## Tcl recorder starts at 03/20/19 20:45:20 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:45:20 ###########


########## Tcl recorder starts at 03/20/19 20:45:29 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:45:29 ###########


########## Tcl recorder starts at 03/20/19 20:49:36 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:49:36 ###########


########## Tcl recorder starts at 03/20/19 20:49:40 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:49:40 ###########


########## Tcl recorder starts at 03/20/19 20:57:53 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:57:53 ###########


########## Tcl recorder starts at 03/20/19 20:58:28 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/20/19 20:58:28 ###########


########## Tcl recorder starts at 03/21/19 14:28:04 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/21/19 14:28:04 ###########


########## Tcl recorder starts at 03/21/19 14:28:16 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/21/19 14:28:16 ###########


########## Tcl recorder starts at 03/21/19 14:45:55 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/21/19 14:45:55 ###########


########## Tcl recorder starts at 03/21/19 14:51:56 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/21/19 14:51:56 ###########


########## Tcl recorder starts at 03/21/19 14:53:36 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/21/19 14:53:36 ###########


########## Tcl recorder starts at 03/21/19 14:59:59 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/21/19 14:59:59 ###########


########## Tcl recorder starts at 03/21/19 15:00:17 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/21/19 15:00:17 ###########


########## Tcl recorder starts at 03/21/19 15:12:46 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/21/19 15:12:46 ###########


########## Tcl recorder starts at 03/21/19 15:13:00 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/21/19 15:13:00 ###########


########## Tcl recorder starts at 03/21/19 15:23:59 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/21/19 15:23:59 ###########


########## Tcl recorder starts at 03/21/19 15:24:03 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/21/19 15:24:03 ###########


########## Tcl recorder starts at 03/21/19 15:24:41 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/21/19 15:24:41 ###########


########## Tcl recorder starts at 03/21/19 15:24:46 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/21/19 15:24:46 ###########


########## Tcl recorder starts at 03/21/19 15:25:05 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/21/19 15:25:05 ###########


########## Tcl recorder starts at 03/21/19 15:25:08 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/21/19 15:25:08 ###########


########## Tcl recorder starts at 03/21/19 15:26:18 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/21/19 15:26:18 ###########


########## Tcl recorder starts at 03/21/19 15:26:21 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/21/19 15:26:21 ###########


########## Tcl recorder starts at 03/21/19 15:27:42 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/21/19 15:27:42 ###########


########## Tcl recorder starts at 03/21/19 15:27:46 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/21/19 15:27:46 ###########


########## Tcl recorder starts at 03/21/19 15:28:56 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" gan35_lab9.v -p \"$install_dir/ispcpld/generic\" -predefine lab9.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/21/19 15:28:56 ###########


########## Tcl recorder starts at 03/21/19 15:29:03 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open lab9_top.cmd w} rspFile] {
	puts stderr "Cannot create response file lab9_top.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: lab9.sty
PROJECT: lab9_top
WORKING_PATH: \"$proj_dir\"
MODULE: lab9_top
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" lab9.h gan35_lab9.v
OUTPUT_FILE_NAME: lab9_top
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e lab9_top -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9_top.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf lab9_top.edi -out lab9_top.bl0 -err automake.err -log lab9_top.log -prj lab9 -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9_top.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"lab9_top.bl1\" -o \"lab9.bl2\" -omod \"lab9\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj lab9 -lci lab9.lct -log lab9.imp -err automake.err -tti lab9.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -blifopt lab9.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" lab9.bl2 -sweep -mergefb -err automake.err -o lab9.bl3 @lab9.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -diofft lab9.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" lab9.bl3 -family AMDMACH -idev van -o lab9.bl4 -oxrf lab9.xrf -err automake.err @lab9.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci lab9.lct -dev lc4k -prefit lab9.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp lab9.bl4 -out lab9.bl5 -err automake.err -log lab9.log -mod lab9_top @lab9.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open lab9.rs1 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs1: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -nojed -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open lab9.rs2 w} rspFile] {
	puts stderr "Cannot create response file lab9.rs2: $rspFile"
} else {
	puts $rspFile "-i lab9.bl5 -lci lab9.lct -d m4e_256_96 -lco lab9.lco -html_rpt -fti lab9.fti -fmt PLA -tto lab9.tt4 -eqn lab9.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@lab9.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete lab9.rs1
file delete lab9.rs2
if [runCmd "\"$cpld_bin/tda\" -i lab9.bl5 -o lab9.tda -lci lab9.lct -dev m4e_256_96 -family lc4k -mod lab9_top -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj lab9 -if lab9.jed -j2s -log lab9.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/21/19 15:29:04 ###########

