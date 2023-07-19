#Unwrap TCL Script
#September 2, 2014
#Ryan Godwin
#####

#####
#Example call to tcl alignment script
#vmd File.psf File.dcd -dispdev text -e TCLScript.tcl -args all 0 /Users/User/Document/Aligned.dcd
#####

#####
#Initialize Procedure
#   This procedure is a bit different.  Namely, since the animate command is used to create
#   file, it has been moved into the procdure loop.  This seems like the simplest solution for now
#   as it does not affect the external call to the file
#####
proc unwrapTraj {atomsel opfp} {
    #Set the particular selection of atoms for the reference and comparisons
    #set sel [atomselect top "$atomsel"]
    pbc unwrap -sel $atomsel -all
    
    animate write dcd "$opfp" beg 0 end -1 waitfor all

}
    
    #Initialize Input Parameters
#####
#set required package
package require cmdline
package require pbctools

# Process the command line
set parameters {
    atomsel.arg "" "Which atom selection?"
    outfile.arg "" "Which output file?"
}

#Set command line input to arg variable
array set arg [cmdline::getoptions argv $parameters]
 
# Verify required parameters
set requiredParameters {atomsel outfile}
foreach parameter $requiredParameters {
    if {$arg($parameter) == ""} {
        puts stderr "Missing required parameter: -$parameter"
        exit 1
    }
}

#Replace underscores in atomselection
regsub -all {_} $arg(atomsel) " " atomsel

set out [open "$arg(outfile)" w]

#####
#Perform Operation
#####
unwrapTraj $atomsel $arg(outfile)


close $out
exit
