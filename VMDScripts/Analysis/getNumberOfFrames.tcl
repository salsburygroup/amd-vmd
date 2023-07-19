#Get number of Frames Code
#Spetember 11, 2014
#Ryan Godwin
#####
#
#Example call to Get Number of Frames tcl script
#vmd File.dcd -dispdev text -e getNumberofFrames.tcl -args -outfile OutputFile.dat
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
    {outfile.arg ""   "Which output file"}
}

array set arg [cmdline::getoptions argv $parameters]
 
# Verify required parameters
set requiredParameters {outfile}
foreach parameter $requiredParameters {
    if {$arg($parameter) == ""} {
        puts stderr "Missing required parameter: -$parameter"
        exit 1
    }
}

#Perform Operation
set nf [molinfo top get numframes]

#Open and Write output file
set out [open "$arg(outfile)" w]
puts $out $nf
close $out

exit