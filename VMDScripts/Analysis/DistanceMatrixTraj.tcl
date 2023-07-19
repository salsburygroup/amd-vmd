#####
#Name of Script: Distance Matrix Trajectory
#Date: September 25, 2014
#Name: Ryan Godwin
#####
#
#####
#Example call to tcl script
#vmd File.psf File.dcd -dispdev text -e NameOfScript.tcl -args -atomsel name_CA -outfile OutputFile.dat
#Separate words im atomselection with underscores
#####
#
#####
#Warning: Large trajectory files can be extermely expensive in both
#           calculation and disk space
#####
#
#####
#Procedures to Execute
#####
proc calcDistMat {atomsel first stride distances_out} {

set sel [atomselect top "$atomsel"]
set nf [molinfo top get numframes]
set list1 [$sel list]

for {set i $first} {$i <= $nf} {incr i $stride} {
	# find distances between each pair
	$sel frame $i
	set coords1 [$sel get {x y z}]
	foreach atom1 $coords1 id1 $list1 {
		foreach atom2 $coords1 id2 $list1 {
			if {$id1<=$id2} {
				set dist($id1,$id2) [veclength [vecsub $atom2 $atom1]]
                set distrnd($id1,$id2) [expr {double(round(1000*$dist($id1,$id2)))/1000}]
                puts $distances_out "$distrnd($id1,$id2)"
			}	
		}
	}
        
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
    {first.arg   ""   "Which first frame"}
    {stride.arg  ""   "Which frame increment"}
    {outfile.arg ""   "Which distance matrix output file"}
}

array set arg [cmdline::getoptions argv $parameters]
 
# Verify required parameters
set requiredParameters {atomsel first stride outfile}
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
puts "$arg(outfile)"

#Calculate distance matrix for each frame
set distances_out [open "$arg(outfile)" w]
calcDistMat $atomsel $arg(first) $arg(stride) $distances_out

#####
#Close VMD
#####
close $distances_out
exit

