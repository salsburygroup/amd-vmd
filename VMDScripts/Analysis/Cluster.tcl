#Cluster Wrapper
#Spetember 2, 2014
#Ryan Godwin
#####
#
#Example call to Cluster Wrapper tcl script
#vmd File.psf (or pdb) File.dcd -dispdev text -e TCLScript.tcl -args -atomsel all -first 1 -last -1 -stride 1 -cutoff 2.2 -numclus 50 -distfunc rmsd -outfile /Someplace/OutputFile.dat
#####
#ToDo:
#####

#Initialize Procedure
proc calcClusters {atomsel distfunc cutoffDist numClust first last stride} {
set sel [atomselect top "$atomsel"]
set data [measure cluster $sel distfunc $distfunc num $numClust cutoff $cutoffDist first $first last $last step $stride]

}

#####
#Initialize Input Parameters
#####
#set required package
package require cmdline
 
# Process the command line
set parameters {
    atomsel.arg "" "Which atom selection?"
    first.arg   "" "Which starting frame?"
    last.arg    "" "Which final frame?"
    stride.arg    "" "What stride?"
    distfunc.arg "" "Distance Function? (rmsd, fitrmsd, or rgyrd)"
    cutoff.arg  "" "What cutoff distance?"
    numclus.arg "" "Maximum number of clusters?"
    outfile.arg "" "Which output file?"
}

#Set command line input to arg variable
array set arg [cmdline::getoptions argv $parameters]
 
# Verify required parameters
set requiredParameters {atomsel first last stride cutoff numclus distfunc outfile}
foreach parameter $requiredParameters {
    if {$arg($parameter) == ""} {
        puts stderr "Missing required parameter: -$parameter"
        exit 1
    }
}

#Replace underscores in atomselection
regsub -all {_} $arg(atomsel) " " atomsel


#Calculate Cluster 
set clust [calcClusters $atomsel $arg(distfunc) $arg(cutoff) $arg(numclus) $arg(first) $arg(last) $arg(stride)]

#Set & Write output file
#Set output file
set out [open "$arg(outfile)" w]
puts $out $clust
close $out

exit