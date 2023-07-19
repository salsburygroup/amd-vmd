#Radial Distribution Function Wrapper
#Mon Feb 23 12:59:58 EST 2015
#Ryan Melvin
#####
#Purpose: Calculate the radial pair distribution g(R)
#Example call to VMD gofr
#vmd File.psf File.dcd -dispdev text -e TCLScript.tcl -args -atomid1 2 -atomid2 294 -frames all -outfile OutputFile.dat
#Note that the columns in output are 1) r, 2) g(r), 3) int(g(r))
#####

#ToDo:Add frame range selection

#Initialize Procedure
proc calcGofR {s1 s2 del rm pflag uflag start end step} {
	set atomselection1 [atomselect top "$s1"]
	set atomselection2 [atomselect top "$s2"]
        set GofRout [measure gofr $atomselection1 $atomselection2 delta $del rmax $rm usepbc $pflag selupdate $uflag first $start last $end step $step]

}

#####
#Initialize Input Parameters
#####
#Call Packages
package require cmdline

#Process the Command line
set parameters {
    selection1.arg "" "Selection 1?"
    selection2.arg "" "Selection 2?"
    delta.arg   "" "Delta?"
    rmax.arg	"" "Maximum r value?"
    usepbc.arg	"" "Are periodic boundary conditions set? If not, normalization is nonsense."
    selupdate.arg	"" "Update selection every frame? Generally, this should be false"
    first.arg 	"" "Starting frame?"
    last.arg	"" "Ending frame?"
    stride.arg	"" "Stride?"
    outfile.arg "" "Which output file?"
}
array set arg [cmdline::getoptions argv $parameters]

# Verify required parameters
set requiredParameters {selection1 selection2 delta rmax usepbc selupdate first last stride outfile}
foreach parameter $requiredParameters {
    if {$arg($parameter) == ""} {
        puts stderr "Missing required parameter: -$parameter"
        exit 1
    }
}
#Replace underscores in atomselection
regsub -all {_} $arg(selection1) " " sel1
regsub -all {_} $arg(selection2) " " sel2

#Calculate R
set GofRmessy [calcGofR $sel1 $sel2 $arg(delta) $arg(rmax) $arg(usepbc) $arg(selupdate) $arg(first) $arg(last) $arg(stride)]

#Parse into columns
set r [lindex $GofRmessy 0]
set gr [lindex $GofRmessy 1]
set intgr [lindex $GofRmessy 2]

#Set & Write output file with formatted columns
set out [open "$arg(outfile)" w]
foreach j $r k $gr l $intgr {
	puts $out "$j $k $l"
}

close $out

exit

