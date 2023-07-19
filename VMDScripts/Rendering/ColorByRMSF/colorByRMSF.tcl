# The first four helper functions were copied and/or adapted from the VMD User Forum
# Ref: https://sites.google.com/site/mattperkett/projects/fun-with-vmd

#Example Call
#colorByRMSF top /Location/To/File/RMSF.dat 1.4 9.7
#


proc lerpcolor { col1 col2 alpha } {
  set dc [vecsub $col2 $col1]
  set nc [vecadd $col1 [vecscale $dc $alpha]]
  return $nc
}

proc coltogs { col } {
  foreach {r g b} $col {}
  set gray [expr ($r + $g + $b) / 3.0]
  return [list $gray $gray $gray]
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


proc bicolor_scale {} {
  display update off
  set mincolorid [expr [colorinfo num] - 1]
  set maxcolorid [expr [colorinfo max] - 1]
  set colrange [expr $maxcolorid - $mincolorid - 1]
  for {set i $mincolorid} {$i < $maxcolorid} {incr i} {
    set colpcnt [expr ($i - $mincolorid) / double($colrange)]

    # Cyan --> Magenta
    set firstColor { 0.0 0.88 1.0 }
    set lastColor { 0.9 0.0 0.9 }

    set nc [lerpcolor $firstColor $lastColor $colpcnt]

    foreach {r g b} $nc {}
    display update ui
    color change rgb $i $r $g $b
  }
  display update on
}



proc colorByRMSF {molid rmsfFile {scaleMin -1} {scaleMax -1}} {
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
    #for {set i 0} {$i < $numReps} {incr i} {
    #    mol delrep 0 $molid
    #}

    # the minimum and maximum beta values that VMD will color
    set minVal 0
    set maxVal 0
    if {$scaleMin != -1 && $scaleMax != -1} {
        set val [expr ($scaleMax - $scaleMin) * 0.015]
        set minVal [expr $scaleMin + $val]
        set maxVal [expr $scaleMax - $val]
    }

    # read RMSF file
    puts "Reading RMSF data..."
    set numAtoms 0
    set selText "serial"
    set numClipped 0
    set readFlag 0
    set inF [open $rmsfFile r]
    while { [gets $inF line] >= 0 } {

        # start reading after "@TYPE xy"
        #if {!$readFlag} {
        #    if {[string equal $line "@TYPE xy"]} {
        #        set readFlag 1
        #    }
        #    continue
        #}

        set splitLine [split [string trim $line]]
        #set atomNum($numAtoms) [lindex $splitLine 0]
        set rmsfAng($numAtoms) [lindex $splitLine 0]
        set rmsf($numAtoms) [expr $rmsfAng($numAtoms)]
        #puts $rmsfAng($numAtoms)

        # if scaleMax and scaleMin are specified, make sure that the rmsf is
        #       in range
        if {$scaleMin != -1 && $scaleMax != -1} {
            if {$rmsf($numAtoms) < $minVal} {
                set rmsf($numAtoms) $minVal
                incr numClipped
                set selText "$selText $numAtoms"
            } elseif {$rmsf($numAtoms) > $maxVal} {
                set rmsf($numAtoms) $maxVal
                incr numClipped
                set selText "$selText $numAtoms"
            }
        }

        incr numAtoms
    }
    close $inF


    puts ""
    puts "$numClipped RMSF values were clipped to place them in requested range (+buffer)"
    if {$numClipped > 0} {
        puts $selText
    }
    puts ""


    # set beta value to RMSF
    puts "Setting beta values..."
    set sel [atomselect $molid "all"]
    $sel set beta 0.0
    $sel delete
    for {set i 0} {$i < $numAtoms} {incr i} {
        set sel [atomselect $molid "serial $i"]
        $sel set beta $rmsf($i)
        $sel delete
    }


    # add "Beta" representation
    mol color Beta
    mol representation NewCartoon 0.3 60 4.1 0
    mol selection "protein"
    mol addrep $molid
     
    mol representation NewRibbons 0.3 60 4.1 0
    mol material Opaque
    mol selection "nucleic"
    mol addrep $molid

    mol representation VDW 0.8 46
    mol material Opaque
    mol selection "type ZN"
    mol addrep $molid
    
    mol representation Licorice 0.3 40 40
    mol material Opaque
    mol selection "resname ME8"
    mol addrep $molid

    
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



proc colorByResid {molid {scaleMin -1} {scaleMax -1}} {
    # This function adds a NewCartoon representation with coloring according to the resid
    #
    # molid    --> molecule ID
    # scaleMin --> minimum in color scale
    # scaleMax --> max in color scale
    #
    # * setting scaleMin and scaleMax allows for consistant color scaling between
    #        different structures

    # delete all existing representations
    set numReps [molinfo $molid get numreps]
    for {set i 0} {$i < $numReps} {incr i} {
        mol delrep 0 $molid
    }

    # the minimum and maximum beta values that VMD will color
    set minVal 0
    set maxVal 0
    if {$scaleMin != -1 && $scaleMax != -1} {
        set val [expr ($scaleMax - $scaleMin) * 0.015]
        set minVal [expr $scaleMin + $val]
        set maxVal [expr $scaleMax - $val]
    }

    # set beta value to Resid
    puts "Setting beta values..."
    set numResids 28
    set sel [atomselect $molid "all"]
    $sel set beta 0.0
    $sel delete
    for {set i 1} {$i <= $numResids} {incr i} {
        set sel [atomselect $molid "resid $i"]
        $sel set beta $i
        $sel delete
    }


    # add "Beta" representation
    mol color Beta
    #mol representation Licorice 0.3 10 10
    mol representation NewCartoon 0.3 60 4.1 0
    mol material Opaque
    mol selection "protein"
    mol addrep $molid

    # NOTE: here I could use the built-in VMD color scaling instead if I preferred
    #     http://www.ks.uiuc.edu/Research/vmd/vmd-1.7/ug/node76.html
    # now adjust to a custom color scaling
    #tricolor_scale        

    # set the color scale appropriately
    set repNum [expr [molinfo $molid get numreps] - 1]

    if {$scaleMin == -1 || $scaleMax == -1} {
        mol scaleminmax $molid $repNum auto 
    } else {
        mol scaleminmax $molid $repNum $scaleMin $scaleMax
    }


    return
}
