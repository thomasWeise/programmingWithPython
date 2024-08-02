#!/bin/bash -

# This script prints the versions of the dependencies and software environment under which the book was built.

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

# get the script directory
scriptDir="$(dirname "$0")"

# see https://unix.stackexchange.com/questions/6345
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    osName=$NAME
    osVersion=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    osName="$(lsb_release -si)"
    osVersion="$(lsb_release -sr)"
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    osName="$DISTRIB_ID"
    osVersion="$DISTRIB_RELEASE"
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    osName="Debian"
    osVersion="$(cat /etc/debian_version)"
elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    osName="Old SuSE"
    osVersion=""
elif [ -f /etc/redhat-release ]; then
    osName="Old ReadHat"
    osVersion=""
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    osName="$(uname -s)"
    osVersion="$(uname -r)"
fi

osAndVersion="$osName $osVersion"
osAndVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]]+/[[:space:]]/'<<<"${osAndVersion}")" || true
if [ -z "$osAndVersion" ]; then
  osAndVersion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  osAndVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]]+/[[:space:]]/'<<<"${osAndVersion}")" || true
fi
if [ -n "$osAndVersion" ]; then
    echo "$osAndVersion"
fi

linuxVersion="$(uname -mrs)" || true
linuxVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]]+/[[:space:]]/'<<<"${linuxVersion}")" || true
if [ -n "$linuxVersion" ]; then
    echo "$linuxVersion"
fi

# separator
echo ""

# Print the python version.
pythonVersion="$(python3 --version | sed -n 's/.*Python\s*\([.0-9]*\)/\1/p')" || true
pythonVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]]+/[[:space:]]/'<<<"${pythonVersion}")" || true
if [ -n "$pythonVersion" ]; then
    echo "python: $pythonVersion"
fi

latexgitPyVersion="$(pip freeze | grep latexgit | sed -n 's/.*==*\([.0-9]*\)/\1/p')" || true
latexgitPyVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]]+/[[:space:]]/'<<<"${latexgitPyVersion}")" || true
if [ -n "$latexgitPyVersion" ]; then
    echo "latexgit_py: $latexgitPyVersion"
fi

latexgitTexVersion="$(less $scriptDir/../styles/latexgit.sty | sed -n 's/.*\\ProvidesPackage{latexgit}\[[0-9\/]* *\([.0-9]*\) .*\].*/\1/p')" || true
latexgitTexVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]]+/[[:space:]]/'<<<"${latexgitTexVersion}")" || true
if [ -n "$latexgitTexVersion" ]; then
    echo "latexgit_tex: $latexgitTexVersion"
fi

pycommonsVersion="$(pip freeze | grep pycommons | sed -n 's/.*==*\([.0-9]*\)/\1/p')" || true
pycommonsVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]]+/[[:space:]]/'<<<"${pycommonsVersion}")" || true
if [ -n "$pycommonsVersion" ]; then
    echo "pycommons: $pycommonsVersion"
fi

pdflatexVersion="$(pdflatex --version | grep 'pdfTeX 3')" || true
pdflatexVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]]+/[[:space:]]/'<<<"${pdflatexVersion}")" || true
if [ -n "$pdflatexVersion" ]; then
    echo "pdflatex: $pdflatexVersion"
fi

biberVersion="$(biber --version | sed -n 's/.*:\s*\([.0-9]*\)/\1/p')" || true
biberVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]]+/[[:space:]]/'<<<"${biberVersion}")" || true
if [ -n "$biberVersion" ]; then
    echo "biber: $biberVersion"
fi

makeglossariesVersion="$(makeglossaries --version | grep Version | sed -n 's/.*Version\s*\([.0-9]*\)/\1/p')" || true
makeglossariesVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]]+/[[:space:]]/'<<<"${makeglossariesVersion}")" || true
if [ -n "$makeglossariesVersion" ]; then
    echo "makeglossaries: $makeglossariesVersion"
fi

makeindexVersion="$(echo '' | makeindex  2>&1 | grep makeindex | sed -n 's/.*version\s*\([.0-9]*\)/\1/p')" || true
makeindexVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]]+/[[:space:]]/'<<<"${makeindexVersion}")" || true
if [ -n "$makeindexVersion" ]; then
    echo "makeindex: $makeindexVersion"
fi

ghostscriptVersion="$(ghostscript --help | head -n 1 | sed -e 's/GPL//i' | sed -e 's/GhostScript//i')" || true
ghostscriptVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]]+/[[:space:]]/'<<<"${ghostscriptVersion}")" || true
if [ -z "$ghostscriptVersion" ]; then
  ghostscriptVersion="$(ghostscript --version)" || true
  ghostscriptVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]]+/[[:space:]]/'<<<"${ghostscriptVersion}")" || true
fi
if [ -n "$ghostscriptVersion" ]; then
    echo "ghostscript: $ghostscriptVersion"
fi

echo ""
echo "date: $(date +'%0Y-%0m-%0d %0R:%0S')"
