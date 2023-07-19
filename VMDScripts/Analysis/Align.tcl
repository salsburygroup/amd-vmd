#Alignment TCL Script
#September 2, 2014
#Ryan Godwin
#####

#####
#Example call to tcl alignment script
#vmd File.psf File.dcd -dispdev text -e TCLScript.tcl -args -atomsel all -refframe 0 -outfile /Users/User/Document/Aligned.dcd
#####

#####
#Initialize Procedure
#   This procedure is a bit different.  Namely, since the animate command is used to create
#   file, it has been moved into the procdure loop.  This seems like the simplest solution for now
#   as it does not affect the external call to the file
#####
proc alignTraj {atomsel refFrame nf opfp} {
    #Set the particular selection of atoms for the reference and comparisons
    set ref [atomselect top "$atomsel" frame $refFrame]
    set cmp [atomselect top "$atomsel"]
    
    #Set frame to index
    set frame1 0
    #Determine number of frames for indexing
  
    #Align the structure
    for {set i 0} {$i <= [expr $nf-1]} {incr i} {
        animate dup frame $frame1 0
        incr frame1
        animate goto $frame1
    
        #Set current frame to be comparison structure
        $cmp frame $i
        #Compute best fit alignment transformation matrix
        set transmat [measure fit $cmp $ref]
        # move comparison structure
        $cmp move $transmat
    }
animate write dcd "$opfp" beg 0 end [expr $nf-1] waitfor all 

}
    
    #Initialize Input Parameters
#####
#set required package
package require cmdline
 
# Process the command line
set parameters {
    atomsel.arg "" "Which atom selection?"
    refframe.arg "" "Which Reference Frame?"
    outfile.arg "" "Which output file?"
}

#Set command line input to arg variable
array set arg [cmdline::getoptions argv $parameters]
 
# Verify required parameters
set requiredParameters {atomsel refframe outfile}
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
alignTraj $atomsel $arg(refframe) [molinfo top get numframes] $arg(outfile)


close $out
exit