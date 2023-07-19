#Cross-Correlation Wrapper
#Feb 20, 2015
#Ryan Godwin
#####
#Example call to coorelation Wrapper tcl script
#vmd File.psd File.dcd -dispdev text -e TCLScript.tcl -args -atomsel all -first 1 -last -1 -stride 1 -outfile OutputFile.dat
#####
#refs:  http://www.ks.uiuc.edu/Research/vmd/mailing_list/vmd-l/19191.html
#	http://www.ks.uiuc.edu/Research/vmd/mailing_list/vmd-l/7001.html

#Initialize Procedure
proc calcCovar {atomsel first last stride} {

set sel [atomselect top "$atomsel"]
#Make a list of the atoms
set list1 [$sel list]

#Get number of frames, set the increment, and determine the normalization factor
set nf [molinfo top get numframes]
set incr1 1
set initFrame 1
set N [expr ($nf/$incr1)+1]

#Get number of atoms and list of atoms
set coords1 [$sel get {x y z}]
set list1  [$sel list]

set list2 0
for {set i 1} {$i <= [expr [llength $list1]-1]} {incr i 1} {
	lappend list2 $i
}

#Initialize the reference matrix
#array set ref $list2
#foreach atom1 $coords1 id1 $list2 {
#   	foreach atom2 $coords1 id2 $list2 {
#		set ref($id1,$id2) 0
#        }
#}
array set ref {}

#Get the average positions of the atoms of the aligned trajectory
set avgposition [measure avpos $sel first 0 last [expr $nf-1] step $incr1]

for {set i $initFrame} {$i <= $nf} {incr i $incr1} {
                set curpos1 [$sel get {x y z} frame all]
                set dist1 [vecsub $curpos1 $avgposition ]

################
################	
#iterate over all frames
#for {set i $initFrame} {$i <= $nf} {incr i $incr1} {
#
#	#Loop over the atoms two times to setup the covariance matrix
#	foreach atom1 $coords1 id1 $list2 {
#               	foreach atom2 $coords1 id2 $list2 {
#
#				set curavgpos1 [lindex $avgposition $id1]
#				set curavgpos2 [lindex $avgposition $id2]
#							
#				#Find the distance from the current position to the average for each atom
#				set dist1($id1) [vecsub $atom1 $curavgpos1]
#				set dist2($id2) [vecsub $atom2 $curavgpos2]
#			
#				#Dot the two vectors together
#				set dotprod($id1,$id2) [vecdot $dist1($id1) $dist2($id2)]
#				set dotprodnorm($id1,$id2) [expr $dotprod($id1,$id2)/$N]
#				
#				#set the current convariance value by adding the previous 	
#				set covariance($id1,$id2) [expr ($ref($id1,$id2)+$dotprodnorm($id1,$id2))]
#
#				#Store the current dot product for summation	
#				set ref($id1,$id2) $dotprodnorm($id1,$id2)
#
#			}
#		}		
#        }   
#}

foreach atom1 $coords1 id1 $list2 {
	foreach atom2 $coords1 id2 $list2 {
		if {$id1==$id2} {
			set Cii($id1) $covariance($id1,$id2)
		}
	}
}

foreach atom1 $coords1 id1 $list2 {
	foreach atom2 $coords1 id2 $list2 {
		if {$id1<=$id2} {
			set correlation($id1,$id2) [expr $covariance($id1,$id2)/(sqrt($Cii($id1)*$Cii($id2)))]
			puts $outfile "$correlation($id1,$id2)"
		}
	}
}


}

#####
#Initialize Input Parameters
#####
#Call Packages
package require cmdline

#Process the Command line
set parameters {
    atomsel.arg "" "Which atom selection?"
    first.arg   "" "Which starting frame?"
    last.arg    "" "Which final frame?"
    stride.arg    "" "What stride?"
    outfile.arg "" "Which output file?"
}

array set arg [cmdline::getoptions argv $parameters]

# Verify required parameters
set requiredParameters {atomsel first last stride outfile}
foreach parameter $requiredParameters {
    if {$arg($parameter) == ""} {
        puts stderr "Missing required parameter: -$parameter"
        exit 1
    }
}

#Replace underscores in atomselection
regsub -all {_} $arg(atomsel) " " atomsel

#Calculate RMSF 
set covarToWrite [calcCovar $atomsel $arg(first) $arg(last) $arg(stride)]

#Set & Write output file
set out [open "$arg(outfile)" w]
puts $out $rmsfToWrite
close $out

exit