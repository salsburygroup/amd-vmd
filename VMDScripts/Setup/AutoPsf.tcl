#####
#Name of Script:Autopsf Wrapper
#Date: Tue Oct 20 13:56:10 EDT 2015
#Name: Ryan Melvin
#####
# 
#####
#Example call to tcl script
#vmd input.pdb -dispdev text -e AutoPsf.tcl 
#Separate words im atomselection with underscores
#####
#
#####
#ToDo: Add actual options
#####
#Credit: Based on a script sent to me by Jiajie Xiao 
#####
#
#####
#Procedures to Execute
#####

package require cmdline
package require autopsf
autopsf -mol 0
exit
