#Determines dihedral angles between residues averaged over all frames (I think)
#This script needs a lot of work!

#Read in the molecule based on the input psf and dcd files
set mol [mol load psf 2kwf_wbi.psf dcd 2kwf_wbi.dcd]

#Choose the the output file location
set outfile [open dihe.dat w]

#Determine the number of frames in the trajectory
set nf [molinfo $mol get numframes]  

# dihedral angle calculation loop  
for {set i 1} { $i <= $nf } { incr i } {  

    # C(i-1) N(i) CA(i) C(i)
    # N(i) CA(i) C(i) N(i+1)

    set phi4 [measure dihed {54 56 58 78} frame $i]
    set psi4 [measure dihed {56 58 78 80} frame $i]

    set phi5 [measure dihed {78 80 82 96} frame $i]
    set psi5 [measure dihed {80 82 96 98} frame $i]

    set phi6 [measure dihed {96 98 100 111} frame $i]
    set psi6 [measure dihed {98 100 111 113} frame $i]

    set phi7 [measure dihed {1520 1522 1524 1535} frame $i]
    set psi7 [measure dihed {1522 1524 1535 1537} frame $i]    

    set phi11 [measure dihed {1577 1579 1581 1596} frame $i]
    set psi11 [measure dihed {1579 1581 1596 1598} frame $i]

    set phi15 [measure dihed {1647 1649 1651 1658} frame $i]
    set psi15 [measure dihed {1649 1651 1658 1660} frame $i]

    # insert more here
    # format: measure dihed {atomnum1, atomnum2, atomnum3, atomnum4} frame #

    #Write output to the file
    puts $outfile "$i $phi4  $psi4  $phi5 $psi5  $phi6 $psi6 $phi7 $psi7 $phi11 $psi11 $phi15 $psi15"
     
}  
close $outfile 

exit
