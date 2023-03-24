#!/usr/bin/env bash

__ScriptVersion="0.1.0"

#===  FUNCTION  ================================================================
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#===============================================================================
function usage ()
{
	echo "Usage :  $0 [options] [--]

	Launches a rofi window to select the process which you want to kill.
	NB: Works best if you bind this to a keyboard shortcut.

	Dependencies: notify-send

    Options:
    -h|help       Display this message
    -v|version    Display script version"

}    # ----------  end of function usage  ----------

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

while getopts ":hv" opt
do
  case $opt in

	h|help     )  usage; exit 0   ;;

	v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;

	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))

choice=$(ps -u $USER -o pid,%mem,%cpu,comm | sort -b -k2 -r | sed -n '1!p' | rofi -i -dmenu -p "Kill" | awk '{print $1, $4}')
[[ $choice == "" ]] && exit 1
pid=$(echo $choice | cut -d" " -f1)
name=$(echo $choice | cut -d" " -f2)
kill -15 $pid 2>/dev/null
notify-send "Process Terminated" "Successfully terminated $name..."
