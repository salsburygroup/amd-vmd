## Orient a molecule to its primary principal axis and move center of mass to origin
#
#
package require Orient
namespace import Orient::orient

# get the number of frames in the movie
set num [molinfo top get numframes]
# loop through the frames
for {set i 0} {$i < $num} {incr i} {
	# go to the given frame
    animate goto $i
    set all [atomselect top "all"]
    set sel [atomselect top "segid P2"]
    set com [measure center $sel]
    $all moveby [vecscale -1.0 $com]
    set I [draw principalaxes $sel]
    set A [orient $all [lindex $I 0] {0 1 0}]
    $all move $A 
    set I [draw principalaxes $sel]
}

animate write dcd PAalign.dcd
quit


