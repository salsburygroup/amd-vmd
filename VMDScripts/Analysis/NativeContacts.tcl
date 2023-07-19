#####
#Name of Script: Native Contacts Trajectory
#Date: September 26, 2014
#Name: Ryan Godwin
#####
#
#####
#Example call to tcl script
#vmd File.psf File.dcd -dispdev text -e NameOfScript.tcl -args -atomsel name_CA -first 1 -stride 10 -outfile OutputFile.dat
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
proc calcNCMat {atomsel first stride cutoff contacts_out} {

set sel [atomselect top "$atomsel"]
set nf [molinfo top get numframes]
set coords1 [$sel get {x y z}]
set list1 [$sel list]
puts "$list1"

set list2 0
for {set i 1} {$i <= [expr [llength $list1]-1]} {incr i 1} {
	lappend list2 $i
}
puts $list2

#Initialize the reference array
array set nc $list2
foreach atom1 $coords1 id1 $list2 {
   	foreach atom2 $coords1 id2 $list2 {
		set nc($id1,$id2) 0
       }
}

for {set i $first} {$i <= $nf} {incr i $stride} {
	# find distances between each pair
	foreach atom1 $coords1 id1 $list2 {
		foreach atom2 $coords1 id2 $list2 {
			if {$id1<=$id2} {
				set dist($id1,$id2) [veclength [vecsub $atom2 $atom1]]
					if {$dist($id1,$id2) <= $cutoff} {
						set nc($id1,$id2) 1
					} else {
						set nc($id1,$id2) 0
					}
				}
                                puts $contacts_out "$nc($id1,$id2)"
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
    {cutoff.arg  ""   "What cutoff distance for contact"}
    {outfile.arg ""   "Which distance matrix output file"}
}

array set arg [cmdline::getoptions argv $parameters]
 
# Verify required parameters
set requiredParameters {atomsel first stride cutoff outfile}
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
set contacts_out [open "$arg(outfile)" w]
calcNCMat $atomsel $arg(first) $arg(stride) $arg(cutoff) $contacts_out

#####
#Close VMD
#####
close $contacts_out
exit

