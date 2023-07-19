#####
#Name of Script:
#Date: 
#Name: 
#####
#
#####
#Example call to tcl script
#vmd File.psf File.dcd -dispdev text -e NameOfScript.tcl -args -atomsel name_CA -outfile OutputFile.dat
#Separate words im atomselection with underscores
#####
#
#####
#ToDo:
#####
#Credit: http://wuhrr.wordpress.com/2009/09/13/parse-command-line-in-a-tcl-script/
#####
#
#####
#Procedures to Execute
#####
proc calcRMSF {atomsel first last stride} {

set sel [atomselect top "$atomsel"]
set rmsfout [measure rmsf $sel first $first last $last step $stride]
return $rmsfout
}

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

#####
#Call Procedure(s)
#####

#Calculate RMSF 
set rmsfToWrite [calcRMSF $atomsel $first $last $stride]

#####
#Report Results to data file
#####
set out [open "$arg(outfile)" w]
puts $out $na
close $out

#####
#Close VMD
#####
exit

