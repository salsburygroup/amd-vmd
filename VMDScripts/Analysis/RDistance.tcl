#R Wrapper
#September 15, 2014
#Ryan Melvin
#####
#Purpose: Measeure the distance between two atoms defined by atomid1 and atomid2
#Example call to R Wrapper tcl script
#vmd File.psf File.dcd -dispdev text -e TCLScript.tcl -args -atomid1 2 -atomid2 294 -frames all -outfile OutputFile.dat
#####

#ToDo:Add frame range selection

#Initialize Procedure
proc calcR {id1 id2 frames} {
        set ends "$id1 $id2"
        set Rout [measure bond $ends molid 0 frame $frames]

}

#####
#Initialize Input Parameters
#####
#Call Packages
package require cmdline

#Process the Command line
set parameters {
    atomid1.arg "" "Which starting atom?"
    atomid2.arg "" "Which ending atom?"
    frames.arg   "" "Which frame(s)?"
    outfile.arg "" "Which output file?"
}
array set arg [cmdline::getoptions argv $parameters]

# Verify required parameters
set requiredParameters {atomid1 atomid2 frames outfile}
foreach parameter $requiredParameters {
    if {$arg($parameter) == ""} {
        puts stderr "Missing required parameter: -$parameter"
        exit 1
    }
}
#Calculate R
set rToWrite [calcR $arg(atomid1) $arg(atomid2) $arg(frames)]

#Set & Write output file
set out [open "$arg(outfile)" w]
puts $out $rToWrite
close $out

exit

