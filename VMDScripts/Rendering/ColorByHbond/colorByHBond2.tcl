# Ryan Godwin
# Sept 15 2016
# Modified after the colorByRMSF script...

#Example Call
#colorByHBond top /Location/To/File/Hbonds.dat 0.2 0.85

# Blue --> almost white --> Red
set firstColor { 0.048722 0. 0.89285 }
set middleColor { 1. 0.95239 0.99919 }
set lastColor { 1. 0.059525 0.0981 }

proc colorByHBond2 {molid HBondFile {scaleMin -1} {scaleMax -1}} {
#    set numReps [molinfo $molid get numreps]
    set sel [atomselect top all]
    set coords [$sel get {x y z}]

    # Read Hbond file
    puts "Reading HBond data..."
    set numAtoms 0
    set numClipped 0
    set readFlag 0
    set inF [open $HBondFile r]
    while { [gets $inF line] >= 0 } {

        set splitline [split [string trim $line]]
        set hbd [expr [lindex $splitline 0]-1]  
        set hba [expr [lindex $splitline 1]-1]
        set selText [lindex $splitline 2]
        set occu2 [lindex $splitline 3]

	# Draw dashed line from the hydrogen bond donor to the acceptor
        #puts "Hydrogen bond donor and acceptor coordinates..."
        #puts "[lindex $coords $hbd] [lindex $coords $hba]"

	# Add name for each hydrogen bond
	set coordsTextTMP [vecadd [lindex $coords $hbd] [lindex $coords $hba]]
	set coordsText [vecscale [expr 1.0 /2] $coordsTextTMP]

	# Width for each dashed line
	#set w [expr int($occu2+1) ]
	set w [expr ($occu2-1.1)/10 ]
	#puts "$w"

	if {-$occu2 >= 0} {
	    draw color blue
	    draw text $coordsText $selText size 1
	    puts "$w"
	    draw cylinder [lindex $coords $hbd] [lindex $coords $hba] radius  resolution 60
	} 
	
	#draw line [lindex $coords $hbd] [lindex $coords $hba] width $w style dashed
    }
    close $inF
    
#    puts ""
#    puts "$numClipped HBond values were clipped to place them in requested range (+buffer)"
    return
}

