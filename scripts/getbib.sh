#!/usr/bin/env bash

usage(){
	echo "Usage :  $0 [options] [--]

	Takes a pdf file or an doi as input. The script scrapes the pdf
	metadata and the pdf itself to get the doi, with which
	using the crossref api we get the bibliography in the
	bibtex format.

	NB: If the cross-ref api fail as a failsafe the doi is
	directed to the google scholar website.

	Dependencies: curl, firefox, pdfinfo and pdftext."

}

[[ -z "$1" ]] && usage && exit

if [ -f "$1" ]; then
	doi=$( pdfinfo "$1" | grep -io "doi:.*" -m 1 | grep -o '10\.[0-9]*[4679]\/[\_\;\-\.A-Z0-9a-z\-]*[0-9]' )
	[[ -z $doi ]] && doi=$( pdftotext "$1" 2>/dev/null - | grep -i "doi" -m 1 | grep -o '10\.[0-9]*[4679]/[\_\;\-\.A-Z0-9a-z\-]*[0-9]')
else
	doi="$1"
fi

if [[ -z $doi ]]; then
	echo "No doi found"
	firefox "https://scholar.google.com/scholar?hl=en&as_sdt=0%2C5&q=${1%.pdf}" 2>/dev/null
else
	text=$(curl -s "http://api.crossref.org/works/$doi/transform/application/x-bibtex" -w "\\n")
	[[ $text~="Resource not found." ]] || echo "$test" && exit 0
	firefox "https://scholar.google.com/scholar?hl=en&as_sdt=0%2C5&q=${1%.pdf}" 2>/dev/null
fi
