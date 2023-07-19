#2JVX Renderer
#July 7. 2016
#Ryan Godwin
#####

#set sel1 [atomselect top all]
#set sel2 [atomselect top ions]
#set sel3 [atomselect top "resid 6 9 22 26"]

proc renderPDB {filename} {
    mol delrep 0 0
    source /Volumes/Planck/Research/Trajectories/NEMOMutants/DataFiles/Clustering/Stride2_3pt5_NameCA/2JVY/RepPDBs/2JVY_viewpoint.tcl

    scale by 1.7
    
    mol color Structure 
    mol representation NewCartoon 0.300000 42.000000 4.100000 0
    mol selection all
    mol material Opaque
    mol addrep 0
    
    mol color Name
    mol representation Licorice 0.300000 42.000000 42.000000
    mol selection resid 6 9 22 26
    mol material Opaque
    mol addrep 0
    
    mol color ColorID 7
    mol representation VDW 0.800000 42.000000
    mol selection ions
    mol material Opaque
    mol addrep 0
    puts $filename
    render Tachyon $filename "/Applications/VMD1.9.1.app/Contents/vmd/tachyon_MACOSXX86" -aasamples 12 %s -format TARGA -o %s.tga
}

#####
#Initialize Input Parameters
#####
#Call Packages
package require cmdline

#Process the Command line
set parameters {
    outfile.arg "" "Which file?"
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

renderPDB $arg(outfile)

quit