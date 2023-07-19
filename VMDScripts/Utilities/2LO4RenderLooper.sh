#!/bin/bash
#

FILES=/Volumes/Planck/Research/Trajectories/NEMOMutants/DataFiles/Clustering/Stride10_5pt0_NameCA/2LO4/RepPDBs/rep*.pdb

for i in $FILES
do
#    echo ${i}
#    echo ${i%.pdb}.out
    /Applications/VMD\ 1.9.2.app/Contents/MacOs/startup.command ${i} -dispdev text -e /Users/fwamps/AutoMolDy/amd-vmd/VMDScripts/Utilities/2LO4Renderer.tcl -args -outfile ${i%.pdb}
done

