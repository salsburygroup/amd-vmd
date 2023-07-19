#####
#RGYR.tcl   
#September 21, 2014 
#Ryan Godwin
#####
#
#####
#Example call to tcl script
#vmd File.psf File.dcd -dispdev text -e NameOfScript.tcl -args -atomsel name_CA -first 1 -outfile OutputFile.dat
#Separate words im atomselection with underscores
#####
#
#####
#Procedures to Execute
#####
proc calcRGYR {atomsel initFrame out} {

set sel [atomselect top "$atomsel"]
set nf [molinfo top get numframes]
puts "$out"

    for {set i $initFrame} {$i<=$nf} {incr i} {
        $sel frame $i
        set rgyrValue [measure rgyr $sel]
        set rgyrRnd [expr {double(round(1000*$rgyrValue))/1000}]
        puts $out $rgyrRnd
    }
    
}

#####
#Initialize Input Parameters
#####
#set required package
package require cmdline
 
# Process the command line
set parameters {
    {atomsel.arg ""   "Which Atom Selection"}
    {first.arg   ""    "Which initial frame"}
    {outfile.arg ""   "Which output file"}
}

array set arg [cmdline::getoptions argv $parameters]
 
# Verify required parameters
set requiredParameters {atomsel first outfile}
foreach parameter $requiredParameters {
    if {$arg($parameter) == ""} {
        puts stderr "Missing required parameter: -$parameter"
        exit 1
    }
}

#Replace underscores in atomselection
regsub -all {_} $arg(atomsel) " " atomsel

#####
#Call Procedure(s)
#####

#Calculate RMSF
set out [open "$arg(outfile)" w]
calcRGYR $atomsel $arg(first) $out

#####
#Close VMD
#####
close $out
exit

