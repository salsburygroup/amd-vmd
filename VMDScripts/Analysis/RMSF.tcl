#RMSF Wrapper
#August 22, 2014
#Ryan Godwin
#####

#Example call to RMSF Wrapper tcl script
#vmd File.psd File.dcd -dispdev text -e TCLScript.tcl -args -atomsel all -first 1 -last -1 -stride 1 -outfile OutputFile.dat
#####

#Initialize Procedure
proc calcRMSF {atomsel first last stride out} {

    set sel [atomselect top "$atomsel"]
    set rmsfout [measure rmsf $sel first $first last $last step $stride]
    foreach atom $rmsfout {
        set rmsfRnd [expr {double(round(1000*$atom))/1000}]
        puts $out $rmsfRnd
    }
}

#####
#Initialize Input Parameters
#####
#Call Packages
package require cmdline

#Process the Command line
set parameters {
    atomsel.arg "" "Which atom selection?"
    first.arg   "" "Which starting frame?"
    last.arg    "" "Which final frame?"
    stride.arg    "" "What stride?"
    outfile.arg "" "Which output file?"
}

array set arg [cmdline::getoptions argv $parameters]

# Verify required parameters
set requiredParameters {atomsel first last stride outfile}
foreach parameter $requiredParameters {
    if {$arg($parameter) == ""} {
        puts stderr "Missing required parameter: -$parameter"
        exit 1
    }
}

#Replace underscores in atomselection
regsub -all {_} $arg(atomsel) " " atomsel

#Set & Write output file
set out [open "$arg(outfile)" w]

#Calculate RMSF 
set rmsfToWrite [calcRMSF $atomsel $arg(first) $arg(last) $arg(stride) $out]


#puts $out $rmsfToWrite

close $out
quit



