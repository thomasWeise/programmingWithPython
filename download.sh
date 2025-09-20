#!/bin/bash -

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Welcome to the download script."

curDir="$(pwd)"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The current directory is '$curDir'."

scriptDir="$(realpath "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/bookbase/scripts")"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The script directory is '$scriptDir'."

downloadScript="$(realpath "$scriptDir/download.sh")"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The download script directory is 'downloadScript'."

downloadDir="programmingWithPython_$(date +"%Y%m%d")"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We will use the download directory 'downloadDir'."
mkdir -p "$downloadDir"
cd "$downloadDir"



mkdir "original"
mkdir "filtered"


download () {
  url="https://thomasweise.github.io/$1/$2"
  echo "Now downloading '$url'."
  download.sh "$url"
  cp "$2" "original/"
  echo "Finished downloading '$url', now canonicalizing."
  filterPdfExact.sh "$2"
  mv "$2" "filtered/"
  rm "${2%%.*}.original.pdf"
  echo "Finished."
}


download "programmingWithPython" "programmingWithPython.pdf"

download "programmingWithPythonSlidesDE" "01_organisation.pdf"

download "programmingWithPythonSlidesDE" "02_einleitung.pdf"

download "programmingWithPythonSlidesDE" "03_python_installieren.pdf"

download "programmingWithPythonSlidesDE" "04_pycharm_installieren.pdf"

download "programmingWithPythonSlidesDE" "05_programme_erstellen_und_ausführen.pdf"

download "programmingWithPythonSlidesDE" "06_beispiele_herunterladen.pdf"

download "programmingWithPythonSlidesDE" "07_int.pdf"

download "programmingWithPythonSlidesDE" "08_float.pdf"

download "programmingWithPythonSlidesDE" "09_dokumentation.pdf"

download "programmingWithPythonSlidesDE" "10_bool.pdf"

download "programmingWithPythonSlidesDE" "11_str.pdf"

download "programmingWithPythonSlidesDE" "12_none.pdf"

download "programmingWithPythonSlidesDE" "13_variablen_wertzuweisung.pdf"

download "programmingWithPythonSlidesDE" "14_fehler_im_kode_mit_exceptions_und_ide_finden.pdf"

download "programmingWithPythonSlidesDE" "15_variablen_typen_und_type_hints.pdf"

download "programmingWithPythonSlidesDE" "16_gleichheit_und_identität.pdf"

download "programmingWithPythonSlidesDE" "17_listen.pdf"

download "programmingWithPythonSlidesDE" "18_ruff.pdf"

download "programmingWithPythonSlidesDE" "19_tupel.pdf"

download "programmingWithPythonSlidesDE" "20_mengen.pdf"

download "programmingWithPythonSlidesDE" "21_dictionaries.pdf"

download "programmingWithPythonSlidesDE" "22_alternativen_mit_if.pdf"

download "programmingWithPythonSlidesDE" "23_schleifen_mit_for.pdf"

download "programmingWithPythonSlidesDE" "24_enumerate_und_pylint.pdf"

download "programmingWithPythonSlidesDE" "25_schleifen_mit_while.pdf"

download "programmingWithPythonSlidesDE" "26_funktionen_definieren_und_aufrufen.pdf"

download "programmingWithPythonSlidesDE" "27_funktionen_in_modulen.pdf"

download "programmingWithPythonSlidesDE" "28_unit_tests.pdf"

download "programmingWithPythonSlidesDE" "29_funktionsargumente.pdf"

cd "$curDir"
xzCompress.sh "$downloadDir"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Done with the download script."
