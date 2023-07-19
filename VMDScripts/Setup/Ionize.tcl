#####
#Name of Script:Auto Ionize Wrapper
#Date: September 16, 2014
#Name: Ryan Melvin
#####
#
#####
#Example call to tcl script
#vmd -dispdev text -e Ionize.tcl -args -psf input.psf -pdb input.pdb -neutralize -cation MG -o Outfile_Prefix
#Separate words im atomselection with underscores
#####
#Accepts same input as autoionize: http://www.ks.uiuc.edu/Research/vmd/plugins/autoionize/
#####
#ToDo: Add option to write to different path.
#####
#Credit: http://wuhrr.wordpress.com/2009/09/13/parse-command-line-in-a-tcl-script/
#####
#
#####
#Procedures to Execute
#####
proc ionize {param_list} {
    puts $param_list
    eval autoionize $param_list
}

#####
#Initialize Input Parameters
#####
#set required package
package require cmdline
package require autoionize

# Neutralize system?
  set pos [lsearch -exact $argv {-neutralize}]
  if { $pos != -1 } {
    set mode "-neutralize"
    set argv [lreplace $argv $pos $pos]
  }
  
# Get all options
set n [llength $argv]
  for { set i 0 } { $i < $n } { incr i 2 } {
    set key [lindex $argv $i]
    set val [lindex $argv [expr $i + 1]]
    set cmdline($key) $val
  }
  
# Verify required parameters
if { [info exists cmdline(-psf)] } {
    set psffile $cmdline(-psf)
  } else {
    error "Autoionize) ERROR: Missing psf file."
  }

  if { [info exists cmdline(-pdb)] } {
    set pdbfile $cmdline(-pdb)
  } else {
    error "Autoionize) ERROR: Missing pdb file."
  }
  
# Add the structure files to the command line
# Prepare list where full command is stored
set parameter_list {}
append parameter_list [concat "-psf" [format "{%s}" $psffile] "-pdb" [format "{%s}" $pdbfile]]

# Parse all options
  
  if { [info exists cmdline(-sc)] } {
     set saltConcentration $cmdline(-sc)
    if {$saltConcentration < 0} {
      error "Autoionize) ERROR: Cannot set the salt concentration to a negative value."
    }
    set mode [concat "-sc" $saltConcentration]
  }

  if { [info exists cmdline(-nions)] } {
    #Replace underscores in atomselection
    regsub -all {_} $cmdline(-nions) " " ion_list
    #foreach ion_num $ion_list {
     # set ion [lindex $ion_num 0]
    #  set num [lindex $ion_num 1]
#
   #   if {![string is integer $num] || $num < 0} {
   #     error "Autoionize) ERROR: Expected positive integer number of ions but got '$num'."
   #   } elseif {$num == 0} {
   #     puts "Autoionize) WARNING: Requested placement of 0 $ion ions. Ignoring..."
  #      continue
  #    }
  #  }
    set mode [concat "-nions"  $ion_list]
  }

# Add mode to the autoionize command
set parameter_list [concat $parameter_list $mode]
    
# set optional parameters
  if { [info exists cmdline(-o)] } {
    set prefix $cmdline(-o)
    set parameter_list [concat $parameter_list "-o" $prefix]
  } 

  if { [info exists cmdline(-from)] } {
    set from $cmdline(-from)
    set parameter_list [concat $parameter_list "-from" $from]
  } 
  if { [info exists cmdline(-between)] } {
    set between $cmdline(-between)
    set parameter_list [concat $parameter_list "-between" $between]
  } 
  if { [info exists cmdline(-seg)] } {
    set segname $cmdline(-seg)
    set parameter_list [concat $parameter_list "-seg" $segname]
  } 

  if { [info exists cmdline(-cation)] } {
    set cation $cmdline(-cation)
    puts $cation
        if {$mode == {nions}} {
      error "Autoionize) ERROR: Cannot use option -cation togeth with -nions."
    }
  #else {
    #set cation {SOD}
  #}
    set parameter_list [concat $parameter_list "-cation" $cation]
    }

  if { [info exists cmdline(-anion)] } {
    set anion $cmdline(-anion)
    set anionCharge [ionGetCharge $anion]

    if {$mode == {nions}} {
      error "Autoionize) ERROR: Cannot use option -anion togeth with -nions."
    }
  #else {
    #set anion {CLA}
  #}
    set parameter_list [concat $parameter_list "-anion" $anion]
}
#####
#Call Procedure(s)
#####

ionize "$parameter_list"



#####
#Close VMD
#####
exit

