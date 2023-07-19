#Get number of Atoms Wrapper
#Spetember 3, 2014
#Ryan Godwin
#####
#
#Example call to Get Number of Atoms tcl script
#vmd File.psf -dispdev text -e getAtomSelectionIndices.tcl -args -atomsel name_CA -outfile OutputFile.dat
#####
#ToDo:
#####
#Credit: http://wuhrr.wordpress.com/2009/09/13/parse-command-line-in-a-tcl-script/
#####

#####
#Initialize Input Parameters
#####
#set required package
package require cmdline
 
# Process the command line
set parameters {
    {atomsel.arg ""   "Which Atom Selection"}
    {outfile.arg ""   "Which output file"}
}

array set arg [cmdline::getoptions argv $parameters]
 
# Verify required parameters
set requiredParameters {atomsel outfile}
foreach parameter $requiredParameters {
    if {$arg($parameter) == ""} {
        puts stderr "Missing required parameter: -$parameter"
        exit 1
    }
}

#Replace underscores in atomselection
regsub -all {_} $arg(atomsel) " " atomsel

#Perform Operation
set sel [atomselect top "$atomsel"]
set indices [$sel list]

#Open and Write output file
set out [open "$arg(outfile)" w]
puts $out $indices
close $out

exit