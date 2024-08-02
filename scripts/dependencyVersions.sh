#!/bin/bash -

# This script prints the versions of the dependencies and software environment under which the book was built.

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

# get the script directory
scriptDir="$(dirname "$0")"

# print operating systems infos
( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1
uname -mrs
echo ""
# Print the python version.
echo "python: $(python3 --version | sed -n 's/.*Python\s*\([.0-9]*\)/\1/p')"
echo "latexgit_py: $(pip freeze | grep latexgit | sed -n 's/.*==*\([.0-9]*\)/\1/p')"
echo "latexgit_tex: $(less $scriptDir/../styles/latexgit.sty | sed -n 's/.*\\ProvidesPackage{latexgit}\[[0-9\/]* *\([.0-9]*\) .*\].*/\1/p')"
echo "pycommons: $(pip freeze | grep pycommons | sed -n 's/.*==*\([.0-9]*\)/\1/p')"
echo "pdflatex: $(pdflatex --version | grep 'pdfTeX 3')"
echo "biber: $(biber --version | sed -n 's/.*:\s*\([.0-9]*\)/\1/p')"
echo "makeglossaries: $(makeglossaries --version | grep Version | sed -n 's/.*Version\s*\([.0-9]*\)/\1/p')"
echo "makeindex: $(echo '' | makeindex  2>&1 | grep makeindex | sed -n 's/.*version\s*\([.0-9]*\)/\1/p')"
echo "ghostscript: $(ghostscript --version)"
