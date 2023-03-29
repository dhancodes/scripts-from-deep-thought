#!/usr/bin/env bash

function usage () {
	echo "Usage :  $0 [options] [--]

    Options:
	-h|help       Display this message
	-v|version    Display script version
	-s|simple     Simple texfile without other dependencies
	-b|beamer     Beamer template"

}    # ----------  end of function usage  ----------

function simptex() {
filename="$(date +"%Y%m%d")_$loc.tex"
echo '\documentclass[a3paper,12pt]{article}
\usepackage{mathtools}
\usepackage{amssymb,amsthm}
\usepackage{cite}
\usepackage{geometry}
\usepackage{graphicx}
\usepackage{fancyhdr}
% \usepackage{tikz-cd}%For commutative diagram.
\usepackage[english]{babel}
\usepackage[utf8]{inputenc}

\title{Title}
\author{xxx}
\date{\today}

%Theorem environments
\newtheorem{prop}{Proposition}
\newtheorem{lemma}{Lemma}
\newtheorem{cor}{Corollary}
\newtheorem{thm}{Theorem}
\newtheorem*{obs}{Observation}
\theoremstyle{remark}
\newtheorem*{rmk}{Remark}
\theoremstyle{definition}
\newtheorem{defn}{Definition}

%Some quick get arounds.
\newcommand{\R}{\mathbb{R}}
\newcommand{\Q}{\mathbb{Q}}
\newcommand{\Z}{\mathbb{Z}}
\newcommand{\N}{\mathbb{N}}
\newcommand{\m}{\mathfrak{m}}
\renewcommand{\S}{\mathcal{S}}
\renewcommand{\a}{\mathfrak{a}}

\begin{document}
\maketitle

	
\end{document}
' > "$filename"

exit 0
}

function cptex() {
	filename="$(date +"%Y%m%d")_$loc.tex"
	( cd ~/Templates && [[ -d latex ]] || git clone "git@github.com:dhancodes/latex.git" ) &&\
	[[ -L preamble ]] || ln -s ~/Templates/latex/preamble .
	[[ -f "$filename" ]] || cp ~/Templates/latex/$file ./"$filename"
}


__ScriptVersion="0.1.0"
#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

if (( $OPTIND == 1 )); then
   file=article.tex; loc="$1"
fi

while getopts ":hvl:s:b:a:" opt
do
  case $opt in

	h|help     )  usage; exit 0   ;;

	v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;

	a|article  ) file=article.tex; loc=${OPTARG} ;;

	b|beamer  )  file=slides.tex; loc=${OPTARG} ;;

	s|simple   )  loc=${OPTARG};simptex ;;

	l|letter   )  file=letter.tex; loc=${OPTARG} ;;

	* )  echo -e "\n  Option does not exist : $OPTARG\n"
		  usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))

cptex &&\
vim "$filename"
