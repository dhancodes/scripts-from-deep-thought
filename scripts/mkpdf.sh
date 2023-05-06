#!/bin/sh
#Making pdf from anything.

__ScriptVersion="1.0.0"

#===  FUNCTION  ================================================================
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#===============================================================================
function usage ()
{
	echo "Usage :  $0 [options] [--]
	Converts some file formats to pdf. Helpful if you don't want to
	remember a lot of commands and very helpful if use bind it to a
	shortcut in filemanager ( like thunar,vifm,ranger ... )

    Options:
    -h|help       Display this message
    -v|version    Display script version"

}    # ----------  end of function usage  ----------

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

while getopts ":hvi" opt
do
  case $opt in

	h|help     )  usage; exit 0   ;;

	# i|install  )  sudo apt install

	v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;

	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))

file=$(readlink -f "$1")
dir=${file%/*}
base="${1%.*}"
ext="${file##*.}"

cd "$dir" || exit 1

textype() { \
	command="pdflatex"
	( head -n5 "$file" | grep -qi 'xelatex' ) && command="xelatex"
 	( head -n1 "$file" | grep -qi 'handout' ) && $command --output-directory="$dir" --jobname="$base""_handout" "\PassOptionsToClass{handout}{beamer} \input{$base}" && bibtex "$base""_handout.aux" 
	$command --output-directory="$dir" "$base" &&
	bibtex "$base".aux
	$command --output-directory="$dir" "$base"
 	( head -n1 "$file" | grep -qi 'handout' ) && $command --output-directory="$dir" --jobname="$base""_handout" "\PassOptionsToClass{handout}{beamer} \input{$base}"
}

mdtype() { \
	command="md1"
	( head -n5 "$file" | grep -qi 'beamer' ) && command="beamer"
	( head -n5 "$file" | grep -qi 'twoside' ) && command="md2"
     	~/.scripts/pandoc.sh $1 $command
}

case "$ext" in
	djvu) ddjvu -format=pdf "$1" "$base".pdf;;
	md) mdtype "$1" ;;
	ps) ps2pdf "$1";;
	odt) unoconv -f pdf "$1";;
	ods) unoconv -f pdf "$1";;
	xlsx) unoconv -f pdf "$1";;
	doc) unoconv -f pdf "$1";;
	ppt) unoconv -f pdf "$1";;
	pptx) unoconv -f pdf "$1";;
	docx) unoconv -f pdf "$1";;
	txt) enscript -j -p -B --margins=10:10: -X dos -o "$base.ps" "$1" && ps2pdf "$base.ps" "$base.pdf" && rm "$base.ps" ;;
	chm) chm2pdf --book $1 $base.pdf;;
	epub) pandoc -s --pdf-engine=xelatex -t latex "$1" -o "$base.pdf" ;;
	tex) textype "$file" ;;
	bib) pandoc "$file" --csl ieee.csl -s -o "$base".pdf ;;
	*) head -n1 "$file" | grep "^#!/" | sed "s/^#!//" | xargs -r -I % "$file" ;;
esac
