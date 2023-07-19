#####
#Name of Script: Residue Center of Mass Distance Matrix Trajectory 
#Date: Wed Feb 25 14:27:55 EST 2015
#Name: Ryan Melvin
#####
#
#####
#Example call to tcl script
#vmd File.psf File.dcd -dispdev text -e NameOfScript.tcl -args -atomsel name_CA -outfile OutputFile.dat
#Separate words im atomselection with underscores
#####
#Credit:
#Wapper for a lightly modified version of "difference_matrix" by Andrew Dalke (dalke@ks.uiuc.edu)
#http://www.ks.uiuc.edu/Research/vmd/script_library/scripts/difference_matrix/
#####
#Warning: Large trajectory files can be extermely expensive in both
#           calculation and disk space
#####
#
#####
#Procedures to Execute
#####

proc calcCOMDistMat {atomsel1 atomsel2 first stride distances_out} {

set sel1 [atomselect top "$atomsel1"]
set sel2 [atomselect top "$atomsel2"]
# get the list of residues in each selection
set reslist1 [lsort -integer -unique [$sel1 get residue]]
set num_reslist1 [llength $reslist1]
set reslist2 [lsort -integer -unique [$sel2 get residue]]
set num_reslist2 [llength $reslist2]


# make sure they have the same number of residues
if { $num_reslist1 != $num_reslist2 } {
error "First set of atoms has $num_reslist1 residues but the \
second has $num_reslist2]"
}

set nf [molinfo top get numframes]


for {set i $first} {$i <= $nf} {incr i $stride} {
  # compute the center of mass for each residue of the first selection
  foreach residue $reslist1 {
    set sel [atomselect [$sel1 molid]  "residue $residue" frame $i]
    set com(1,$residue) [measure center $sel weight mass]
  }

  # compute the center of mass for each residue of the second selection
  foreach residue $reslist2 {
    set sel [atomselect [$sel2 molid] "residue $residue" frame $i]
    set com(2,$residue) [measure center $sel weight mass]
  }        
    # loop over each residue and print the matrix
  foreach res1 $reslist1  {
    foreach res2 $reslist2 {
	    if {$res1<=$res2} {
     		 set dist  [veclength [vecsub $com(1,$res1) $com(2,$res2)]]
		 set distrnd [expr {double(round(1000*$dist))/1000}]
     		 puts $distances_out "$distrnd"
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
    {atomsel1.arg ""   "Which Atom Selection1"}
    {atomsel2.arg ""   "Which Atom Selection2"}
    {first.arg   ""   "Which first frame"}
    {stride.arg  ""   "Which frame increment"}
    {outfile.arg ""   "Which distance matrix output file"}
}

array set arg [cmdline::getoptions argv $parameters]
 
# Verify required parameters
set requiredParameters {atomsel1 atomsel2 first stride outfile}
foreach parameter $requiredParameters {
    if {$arg($parameter) == ""} {
        puts stderr "Missing required parameter: -$parameter"
        exit 1
    }
}

#Replace underscores in atomselection
regsub -all {_} $arg(atomsel1) " " atomsel1
regsub -all {_} $arg(atomsel2) " " atomsel2

#####
#Call Procedure(s)
#####
puts "$arg(outfile)"

#Calculate distance matrix for each frame
set distances_out [open "$arg(outfile)" w]
calcCOMDistMat $atomsel1 $atomsel2 $arg(first) $arg(stride) $distances_out

#####
#Close VMD
#####
close $distances_out
exit
