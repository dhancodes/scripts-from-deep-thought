#!/bin/bash

__ScriptVersion="0.1.0"

#===  FUNCTION  ================================================================
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#===============================================================================
function usage ()
{
	echo "Usage :  $0 [options] [--]

	This just scans a folder for pdf and displays it in default
	PDF reader. If no match is found the command will redirect
	to google using firefox.

	Dependencies: Firefox, Xdg-open, Zathura (not neccessary)

    Options:
	-h|help       Display this message
	-v|version    Display script version
	-z|zathura    Opens the pdf file using zathura
	-p|path       Select PDF path other than Documents"

}    # ----------  end of function usage  ----------

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

while getopts ":hv" opt
do
  case $opt in

	h|help     )  usage; exit 0   ;;

	p|path     )  search_path=$OPTARG ;;

	v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;

	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))

cd ${PATH:-~/Documents}
pdf_file="$(find -L . -type f -iname *.pdf | rofi -i -dmenu -p "Select file")"
[ -z "$pdf_file" ] && exit 0
[ -f "$pdf_file" ] && ${open:-xdg-open} "$(realpath "$pdf_file")" || firefox "https://google.com/search?q=${pdf_file%.pdf}"
