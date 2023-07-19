#####
#Name of Script: Solvate
#Date: September 17, 2015
#Name: Ryan Melvin
#####
#
#####
#Example calls to tcl script
#vmd -dispdev text -e NameOfScript.tcl -args -psf File.psf -pdb File.pdb -t 10 -o outputName

#####
#
#####
#ToDo: Add ability to make cube. Also, any parameters other than -t and -o are not read. 
#####
#Credit: http://wuhrr.wordpress.com/2009/09/13/parse-command-line-in-a-tcl-script/
#####
#
#####
#Procedures to Execute
#####
proc Solvate {parameters} {
    eval solvate $parameters
}
#####
#Initialize Input Parameters
#####
#set required package
package require cmdline
package require solvate

# Process the command line
set n [llength $argv]
set parameter_list {}

 # Get all command line options
set n [llength $argv]
  for { set i 0 } { $i < $n } { incr i 2 } {
    set key [lindex $argv $i]
    set val [lindex $argv [expr $i + 1]]
    set cmdline($key) $val
  }
  
# Verify and set required parameters
if { [info exists cmdline(-psf)] } {
    set psffile $cmdline(-psf)
  } else {
    error "Solvate) ERROR: Missing psf file."
  }

  if { [info exists cmdline(-pdb)] } {
    set pdbfile $cmdline(-pdb)
  } else {
    error "Solvate) ERROR: Missing pdb file."
  }

append parameter_list [concat [format $psffile] [format "{%s}" $pdbfile]]

# set optional parameters
#Output file
  if { [info exists cmdline(-o)] } {
    set prefix $cmdline(-o)
    set parameter_list [concat $parameter_list "-o" $prefix]
  }
  
#Padding
   if { [info exists cmdline(-t)] } {
    set padding $cmdline(-t)
    set parameter_list [concat $parameter_list "-t" $padding]
  }
  
#####
#Call Procedure(s)
#####
#Solvate
Solvate $parameter_list

#####
#Close VMD
#####
exit

