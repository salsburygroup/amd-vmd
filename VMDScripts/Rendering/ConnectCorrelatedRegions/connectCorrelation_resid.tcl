# Ryan Godwin
# Sept 15 2016
# Modified after the colorByHBond script...

#Example Call
#connectCorrelation top /Location/To/File/Hbonds.dat 0.2 0.85

proc lerpcolor { col1 col2 alpha } {
  set dc [vecsub $col2 $col1]
  set nc [vecadd $col1 [vecscale $dc $alpha]]
  return $nc
}

proc tricolor_scale {} {
  display update off
  set mincolorid [expr [colorinfo num] - 1]
  set maxcolorid [expr [colorinfo max] - 1]
  set colrange [expr $maxcolorid - $mincolorid]
  set colhalf [expr $colrange / 2]
  for {set i $mincolorid} {$i < $maxcolorid} {incr i} {
    set colpcnt [expr ($i - $mincolorid) / double($colrange)]

    # Blue --> almost white --> Red
    set firstColor { 0.048722 0. 0.89285 }
    set middleColor { 1. 0.95239 0.99919 }
    set lastColor { 1. 0.059525 0.0981 }

    # Orange --> Cyan --> Magenta
    #set firstColor { 1.0 0.5 0.0 }
    #set middleColor { 0.0 0.88 1.0 }
    #set lastColor { 0.9 0.0 0.9 }

    # Cyan --> Orange --> Magenta
#    set firstColor { 0.0 0.88 1.0 }
#    set middleColor { 1.0 0.25 0.0 }
#    set lastColor { 0.9 0.0 0.9 }

    if { $colpcnt < 0.5 } {
      set nc [lerpcolor $firstColor $middleColor [expr $colpcnt * 2.0]]
    } else {
      set nc [lerpcolor $middleColor $lastColor [expr ($colpcnt-0.5) * 2.0]]
    }

    foreach {r g b} $nc {}
    display update ui
    color change rgb $i $r $g $b
  }
  display update on
}


proc connectCorrelation_resid {molid HBondFile {scaleMin -1} {scaleMax 1}} {
    # This function adds a NewCartoon representation with coloring according to RMSF
    #
    # molid    --> molecule ID
    # rmsfFile --> the output file rmsf.xvg from from g_rmsf.  It contains the
    #                  RMSF for each atom
    # scaleMin --> minimum in color scale
    # scaleMax --> max in color scale
    #
    # * setting scaleMin and scaleMax allows for consistant color scaling between
    #        different structures

    # delete all existing representations
    set numReps [molinfo $molid get numreps]
    set sel [atomselect top "name CA"]
    set coords [$sel get {x y z}]
    puts coords
    #for {set i 0} {$i < $numReps} {incr i} {
    #    mol delrep 0 $molid
    #}

    # the minimum and maximum beta values that VMD will color
    set minVal 0
    set maxVal 0
    #if {$scaleMin != -1 && $scaleMax != -1} {
        set val [expr ($scaleMax - $scaleMin) * 0.0015]
        set minVal [expr $scaleMin + $val]
        set maxVal [expr $scaleMax - $val]
    #}

    # read RMSF file
    puts "Reading Correlation data..."
    set numAtoms 0
    set selText "resid"
    set numClipped 0
    set readFlag 0
    set inF [open $HBondFile r]
    puts $scaleMin 
    while { [gets $inF line] >= 0 } {


        set splitline [split [string trim $line]]
        set atom1 [expr [lindex $splitline 0]]  
        set atom2 [expr [lindex $splitline 1]]
        set occu [lindex $splitline 2]

        # if scaleMax and scaleMin are specified, make sure that the rmsf is
        #       in range
        if {$scaleMin != -1 && $scaleMax != -1} {
          if {$occu < $minVal} {
             set $occu($line) $minVal
             incr numClipped
             set selText "$selText $numAtoms"
          } elseif {$occu > $maxVal} {
            set $occu($line) $maxVal
            incr numClipped
            set selText "$selText $numAtoms"
          }
        } 
        
        #draw cylinders from the hydrogen bond donor to the acceptor
        #puts "Correlated atom pair coordinates..."
        #puts "[lindex $coords $atom1] [lindex $coords $atom2]"
        #draw color RWB
        #set sel2 [atomselect $molid all]
        #$sel2 set beta 0.0
        #$sel2 delete
        #set sel3 [atomselect $molid "serial $line"]
        puts $minVal
        set increment [expr {($maxVal-$minVal)/19}]
        puts $increment
        if {$occu < $minVal+$increment} {
            draw color 35
          } elseif {$occu < $minVal+$increment} {
            draw color 85
          } elseif {$occu < $minVal+2*$increment} {
            draw color 135
          }  elseif {$occu < $minVal+3*$increment} {
            draw color 185
          }  elseif {$occu < $minVal+4*$increment} {
            draw color 235
          }  elseif {$occu < $minVal+5*$increment} {
            draw color 285
          }  elseif {$occu < $minVal+6*$increment} {
            draw color 335
          }  elseif {$occu < $minVal+7*$increment} {
            draw color 385
          }  elseif {$occu < $minVal+8*$increment} {
            draw color 435
          }  elseif {$occu < $minVal+9*$increment} {
            draw color 585
          } elseif {$occu < $minVal+10*$increment} {
            draw color 635
          } elseif {$occu < $minVal+11*$increment} {
            draw color 685
          }  elseif {$occu < $minVal+12*$increment} {
            draw color 735
          }  elseif {$occu < $minVal+13*$increment} {
            draw color 785
          }  elseif {$occu < $minVal+14*$increment} {
            draw color 835
          }  elseif {$occu < $minVal+15*$increment} {
            draw color 885
          }  elseif {$occu < $minVal+16*$increment} {
            draw color 935
          }  elseif {$occu < $minVal+17*$increment} {
            draw color 985
          }  elseif {$occu < $minVal+18*$increment} {
            draw color 1035
          } 
          
        draw cylinder [lindex $coords $atom1] [lindex $coords $atom2] radius 0.2
        #draw line [lindex $coords $atom1] [lindex $coords $atom2] width 6 style dashed

        #incr numAtoms
    }
    close $inF


    puts ""
    puts "$numClipped Correlation values were clipped to place them in requested range (+buffer)"
    if {$numClipped > 0} {
        puts $selText
    }
    puts ""

    # add "Beta" representation
    #mol color Beta
    #mol representation NewCartoon 0.3 60 4.1 0
    #mol selection "protein"
    #mol addrep $molid
    # 
    #
    #mol representation VDW 0.8 46
    #mol material Opaque
    #mol color ColorID 7
    #mol selection "type ZN"
    #mol addrep $molid
    #
    #mol representation Licorice 0.3 40 40
    #mol material Opaque
    #mol color Name
    #mol selection "resid 6 9 22 26"
    #mol addrep $molid

    
    # NOTE: here I could use a built-in VMD color scaling instead if I preferred
    #     http://www.ks.uiuc.edu/Research/vmd/vmd-1.7/ug/node76.html
    # now adjust to a custom color scaling
    tricolor_scale        

    # set the color scale appropriately
    set repNum [expr [molinfo $molid get numreps] - 1]

    if {$scaleMin == -1 || $scaleMax == -1} {
        mol scaleminmax $molid $repNum auto 
    } else {
        mol scaleminmax $molid $repNum $scaleMin $scaleMax
    }


    return
}

