#!/usr/bin/env bash

__ScriptVersion="0.1.0"

#===  FUNCTION  ================================================================
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#===============================================================================
function usage () {
	echo "Usage :  $0 [options] [--]

	Dependencies: locate (or) find, rofi (or) dmenu, and xdg-open

	Options:
	-r|Rofi       Use rofi instead of dmenu
	-l|Locate     Use locate instead of find
	-h|help       Display this message
	-v|version    Display script version

 ( NB: Locate will be faster compared to find, but it might not be a fresh scan )"


}    # ----------  end of function usage  ----------

function find_locate() {
	if [[ $LOCATE = 1 ]]; then
		locate media home
	else
		find ~
	fi
}

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------
 
while getopts ":hvrl" opt
do
  case $opt in

	h|help     )  usage; exit 0   ;;

	r|rofi     )  ROFI=1;;

	l|locate     )  LOCATE=1;;

	v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;

	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))

if [[ $ROFI==0 ]]; then
	choice=$( find_locate | dmenu -i -l 20 -p "Select file")
else
	choice=$( find_locate | rofi -dmenu -i "Select file")
fi

[[ -z $choice ]] && exit 1
setsid xdg-open "$choice" &
