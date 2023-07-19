
#####
#RGYR.tcl   
#October 9, 2014 
#Ryan Godwin
#####
#
#####
#Example call to tcl script
#vmd -dispdev text -e NameOfScript.tcl -args -topo /input/topology/file.txt -xplorpsf /input/psf/file.psf -outfile OutputFile.dat
#Separate words im atomselection with underscores
#####
#
#####
#Procedures to Execute
#####
#Convert XPLOR psf to charmm psf

proc xplorToCharmm {topologyFile xplorpsf output} {
    

resetpsf

topology $topologyFile

readpsf $xplorpsf

##################################################################################################
### Build and Patch Segments Here                                                              ###
##################################################################################################

##################################################################################################
### End Build and Patch Segments                                                               ###
##################################################################################################

writepsf charmm nocmap $output


}

####
#Initialize Input Parameters
#####
#set required package
package require cmdline
package require psfgen
 
# Process the command line
set parameters {
    {topo.arg ""   "Which Atom Selection"}
    {xplorpsf.arg   ""    "Which initial frame"}
    {outfile.arg ""   "Which output file"}
}

array set arg [cmdline::getoptions argv $parameters]
 
# Verify required parameters
set requiredParameters {topo xplorpsf outfile}
foreach parameter $requiredParameters {
    if {$arg($parameter) == ""} {
        puts stderr "Missing required parameter: -$parameter"
        exit 1
    }
}

xplorToCharmm $arg(topo) $arg(xplorpsf) $arg(outfile)

exit
