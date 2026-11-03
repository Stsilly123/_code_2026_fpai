# Fix Vivado HLS 2018.3's IP packaging bug and re-run the pack step.
#
# Symptom (expected, unrelated to the design):
#   ERROR: [IMPL 213-28] Failed to generate IP.
# The real error in impl/ip/vivado.log:
#   bad lexical cast ... "rdi::set_property core_revision 2620xxxxxx ..."
# HLS builds the revision as YYMMDDHHMM, which exceeds INT32_MAX for any date
# after 2022.  Patch the number, then re-source run_ippack.tcl under Vivado.
#
# Every export regenerates run_ippack.tcl and wipes this patch, so run this
# script after every export_design.
#
# Run from D:/FPGA/FPGA/FPAI_PL/HLS/LcwtMLP_RFFI:
#   D:/Xilinx/Vivado/2018.3/bin/vivado -notrace -mode batch -source LcwtMLP_RFFI/pack_ip.tcl
set ipdir "proj_export/solution1/impl/ip"

if {![file isdirectory $ipdir]} {
    puts "ERROR: $ipdir not found -- run export_ip.tcl first"
    exit 1
}
cd $ipdir

set fh [open run_ippack.tcl r]
set data [read $fh]
close $fh

if {![regexp {set Revision(\s+)"([0-9]+)"} $data -> _ws rev]} {
    puts "ERROR: 'set Revision' not found in run_ippack.tcl"
    exit 1
}

set limit 2147483647
if {$rev > $limit || $rev < 0} {
    set newrev [expr {$rev % 2000000000}]
    puts "INFO: core_revision = $rev > INT32_MAX($limit) -> $newrev"
    set data [regsub {set Revision(\s+)"[0-9]+"} $data "set Revision\\1\"$newrev\""]
    set fh [open run_ippack.tcl w]
    puts -nonewline $fh $data
    close $fh
} else {
    puts "INFO: core_revision = $rev already valid"
}

puts "INFO: packing ..."
source run_ippack.tcl -notrace
puts "INFO: pack done"
