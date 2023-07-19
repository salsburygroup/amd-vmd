#####
#HBond.tcl  
#January 30, 2014 
#Ryan Godwin
#####
#
#####
#Example call to tcl script
#vmd File.psf File.dcd -dispdev text -e NameOfScript.tcl -args -atomsel name_CA -cutoff 3.2 -angle 60 -outfile OutputFile.dat
#Separate words im atomselection with underscores
#####
#TODO: add ability to reference crystal or average structure
#####
#Procedures to Execute
#####
proc calcHBonds {atomsel cutoff angle first last stride out} {
set nf [molinfo top get numframes]

    for {set i $first} {$i <= $nf} {incr i $stride} {
        set sel [atomselect top "$atomsel" frame $i]
        set hbondies [measure hbonds $cutoff $angle $sel]   
        puts $out $hbondies    
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
    {cutoff.arg   ""   "Which Cutoff Distance"}
    {angle.arg ""  "Which angle Cutoff"}
    {first.arg ""  "Which first Frame"}
    {last.arg ""  "Which angle Cutoff"}
    {stride.arg ""  "Which angle Cutoff"}
    {outfile.arg ""   "Which output file"}
}

array set arg [cmdline::getoptions argv $parameters]
 
# Verify required parameters
set requiredParameters {atomsel cutoff angle outfile}
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
calcHBonds $atomsel $arg(cutoff) $arg(angle) $arg(first) $arg(last) $arg(stride) $out

#####
#Close VMD
#####
close $out
exit

