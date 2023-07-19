#####
#GelatoTrajectoryMovie.tcl   
#Jan 9 2015
#Ryan Godwin
#####
#
#####
#Example call to tcl script
#vmd File.psf File.dcd -dispdev text -e NameOfScript.tcl -args -outfile OutputFile.dat
#Separate words im atomselection with underscores
#####
#TODO: add ability to reference crystal or average structure
#####
#Procedures to Execute
#####
#set out [open "$arg(outfile)" w]
cd C:/Users/Ryan/Desktop/TestAuto/
play D:/BitSync/RyanG/Conferences/2016_Colloquim/simsetup/VisualizationState.vmd

for {set i 0} {$i<=200} {incr i} {
        # update frame
        animate goto ${i}
        display update
        #Render new image
        render Gelato HQ_Render_${i}.pyg gelato %s

}
    

#########################################
#Initialize Input Parameters
#####
#set required package
#package require cmdline
# 
# Process the command line
#set parameters {
#    {atomsel.arg ""   "Which Atom Selection"}
#    {first.arg   ""   "Which initial frame"}
#    {refFrame.arg ""  "Which Ref Frame"}
#    {outfile.arg ""   "Which output file"}
#}
#
#array set arg [cmdline::getoptions argv $parameters]
# 
# Verify required parameters
#set requiredParameters {atomsel first refFrame outfile}
#foreach parameter $requiredParameters {
#    if {$arg($parameter) == ""} {
#        puts stderr "Missing required parameter: -$parameter"
#        exit 1
#    }
#}
#
#Replace underscores in atomselection
#regsub -all {_} $arg(atomsel) " " atomsel
############################################

#####
#Call Procedure(s)
#####

#Calculate RMSF
#set out [open "$arg(outfile)" w]
#calcRMSD $atomsel $arg(first) $arg(refFrame) $out

#####
#Close VMD
#####
exit

