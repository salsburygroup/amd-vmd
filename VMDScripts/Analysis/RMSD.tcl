#####
#RMSD.tcl   
#September 21, 2014 
#Ryan Godwin
#####
#
#####
#Example call to tcl script
#vmd File.psf File.dcd -dispdev text -e NameOfScript.tcl -args -atomsel name_CA -first 1 -refFrame 0 -outfile OutputFile.dat
#Separate words im atomselection with underscores
#####
#TODO: add ability to reference crystal or average structure
#####
#Procedures to Execute
#####
proc calcRMSD {atomsel initFrame refFrame out} {

set sel [atomselect top "$atomsel"]
set ref [atomselect top "$atomsel" frame $refFrame]
set nf [molinfo top get numframes]


    for {set i $initFrame} {$i<=$nf} {incr i} {
        # set current frame to be comparison structure
        $sel frame $i
        set rmsd [measure rmsd $sel $ref]
        set rmsdrnd [expr {double(round(1000*$rmsd))/1000}]
        puts $out $rmsdrnd
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
    {first.arg   ""   "Which initial frame"}
    {refFrame.arg ""  "Which Ref Frame"}
    {outfile.arg ""   "Which output file"}
}

array set arg [cmdline::getoptions argv $parameters]
 
# Verify required parameters
set requiredParameters {atomsel first refFrame outfile}
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
calcRMSD $atomsel $arg(first) $arg(refFrame) $out

#####
#Close VMD
#####
close $out
exit

