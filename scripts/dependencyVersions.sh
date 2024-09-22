#!/bin/bash -

# This script prints the versions of the dependencies and software environment under which the book was built.

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

# get the script directory
scriptDir="$(dirname "$0")"

# Find the Python interpreter.
if [[ $(declare -p PYTHON_INTERPRETER 2>/dev/null) != declare\ ?x* ]]; then
  export PYTHON_INTERPRETER="$(readlink -f "$(which python3)")"
fi

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
osAndVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]][[:space:]][[:space:]]*/ /g' -e 's/\.*$//'<<<"${osAndVersion}")" || true
if [ -z "$osAndVersion" ]; then
  osAndVersion="$(( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)"
  osAndVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]][[:space:]][[:space:]]*/ /g' -e 's/\.*$//'<<<"${osAndVersion}")" || true
fi
if [ -n "$osAndVersion" ]; then
    echo "$osAndVersion"
fi

linuxVersion="$(uname -mrs 2>/dev/null )" || true
linuxVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]][[:space:]][[:space:]]*/ /g' -e 's/\.*$//'<<<"${linuxVersion}")" || true
if [ -n "$linuxVersion" ]; then
    echo "$linuxVersion"
fi

# separator
echo ""

# Print the python version.
pythonVersion="$("$PYTHON_INTERPRETER" --version 2>/dev/null | sed -n 's/.*Python\s*\([.0-9]*\)/\1/p')" || true
pythonVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]][[:space:]][[:space:]]*/ /g' -e 's/\.*$//'<<<"${pythonVersion}")" || true
if [ -n "$pythonVersion" ]; then
    echo "python: $pythonVersion"
fi

latexgitPyVersion="$("$PYTHON_INTERPRETER" -m pip freeze 2>/dev/null | grep latexgit | sed -n 's/.*==*\([.0-9]*\)/\1/p')" || true
latexgitPyVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]][[:space:]][[:space:]]*/ /g' -e 's/\.*$//'<<<"${latexgitPyVersion}")" || true
if [ -n "$latexgitPyVersion" ]; then
    echo "latexgit_py: $latexgitPyVersion"
fi

latexgitTexVersion="$(less $scriptDir/../styles/latexgit.sty 2>/dev/null | sed -n 's/.*\\ProvidesPackage{latexgit}\[[0-9\/]* *\([.0-9]*\) .*\].*/\1/p')" || true
latexgitTexVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]][[:space:]][[:space:]]*/ /g' -e 's/\.*$//'<<<"${latexgitTexVersion}")" || true
if [ -n "$latexgitTexVersion" ]; then
    echo "latexgit_tex: $latexgitTexVersion"
fi

pycommonsVersion="$("$PYTHON_INTERPRETER" -m pip freeze 2>/dev/null | grep pycommons | sed -n 's/.*==*\([.0-9]*\)/\1/p')" || true
pycommonsVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]][[:space:]][[:space:]]*/ /g' -e 's/\.*$//'<<<"${pycommonsVersion}")" || true
if [ -n "$pycommonsVersion" ]; then
    echo "pycommons: $pycommonsVersion"
fi

pdflatexVersion="$(pdflatex --version 2>/dev/null | grep 'pdfTeX 3')" || true
pdflatexVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]][[:space:]][[:space:]]*/ /g' -e 's/\.*$//'<<<"${pdflatexVersion}")" || true
if [ -n "$pdflatexVersion" ]; then
    echo "pdflatex: $pdflatexVersion"
fi

biberVersion="$(biber --version 2>/dev/null | sed -n 's/.*:\s*\([.0-9]*\)/\1/p')" || true
biberVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]][[:space:]][[:space:]]*/ /g' -e 's/\.*$//'<<<"${biberVersion}")" || true
if [ -n "$biberVersion" ]; then
    echo "biber: $biberVersion"
fi

makeglossariesVersion="$(makeglossaries --version 2>/dev/null | grep Version | sed -n 's/.*Version\s*\([.0-9]*\)/\1/p')" || true
makeglossariesVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]][[:space:]][[:space:]]*/ /g' -e 's/\.*$//'<<<"${makeglossariesVersion}")" || true
if [ -n "$makeglossariesVersion" ]; then
    echo "makeglossaries: $makeglossariesVersion"
fi

makeindexVersion="$(echo '' | makeindex  2>/dev/null | grep makeindex | sed -n 's/.*version\s*\([.0-9]*\)/\1/p')" || true
makeindexVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]][[:space:]][[:space:]]*/ /g' -e 's/\.*$//'<<<"${makeindexVersion}")" || true
if [ -n "$makeindexVersion" ]; then
    echo "makeindex: $makeindexVersion"
fi

ghostscriptVersion="$(gs --help 2>/dev/null | head -n 1 | sed -e 's/GPL//i' | sed -e 's/GhostScript//i')" || true
ghostscriptVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]][[:space:]][[:space:]]*/ /g' -e 's/\.*$//'<<<"${ghostscriptVersion}")" || true
if [ -z "$ghostscriptVersion" ]; then
  ghostscriptVersion="$(gs --version 2>/dev/null)" || true
  ghostscriptVersion="$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[[:space:]][[:space:]][[:space:]]*/ /g' -e 's/\.*$//'<<<"${ghostscriptVersion}")" || true
fi
if [ -n "$ghostscriptVersion" ]; then
    echo "ghostscript: $ghostscriptVersion"
fi

echo ""
echo "date: $(date +'%0Y-%0m-%0d %0R:%0S')"
