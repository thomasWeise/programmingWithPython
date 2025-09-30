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

download="$(realpath "$scriptDir/downloadMulti.sh")"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The download script directory is '$download'."

downloadDir="programmingWithPython_$(date +"%Y%m%d")"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We will use the download directory '$downloadDir'."
mkdir -p "$downloadDir"
cd "$downloadDir"

"$download" "programmingWithPython" "programmingWithPython.pdf"

mkdir slidesDE
cd slidesDE

"$download" "programmingWithPythonSlidesDE" "01_organisation.pdf" "02_einleitung.pdf" "03_python_installieren.pdf" "04_pycharm_installieren.pdf" "05_programme_erstellen_und_ausführen.pdf" "06_beispiele_herunterladen.pdf" "07_int.pdf" "08_float.pdf" "09_dokumentation.pdf" "10_bool.pdf" "11_str.pdf" "12_none.pdf" "13_variablen_wertzuweisung.pdf" "14_fehler_im_kode_mit_exceptions_und_ide_finden.pdf" "15_variablen_typen_und_type_hints.pdf" "16_gleichheit_und_identität.pdf" "17_listen.pdf" "18_ruff.pdf" "19_tupel.pdf" "20_mengen.pdf" "21_dictionaries.pdf" "22_alternativen_mit_if.pdf" "23_schleifen_mit_for.pdf" "24_enumerate_und_pylint.pdf" "25_schleifen_mit_while.pdf" "26_funktionen_definieren_und_aufrufen.pdf" "27_funktionen_in_modulen.pdf" "28_unit_tests.pdf" "29_funktionsargumente.pdf" "30_callables_und_lambdas.pdf" "31_ausnahmen_auslösen.pdf" "32_ausnahmen_verarbeiten.pdf" "33_testen_auf_ausnahmen.pdf" "34_iteration.pdf" "35_list_comprehension.pdf" "36_doctests.pdf" "37_set_und_dictionary_comprehension.pdf" "38_generator_ausdrücke.pdf" "39_generator_funktionen.pdf"

"$download" "programmingWithPythonSlidesDE2" "40_operationen_für_iteratoren.pdf" "41_klassen_grundlagen.pdf" "42_klassen_kapselung.pdf" "43_klassen_vererbung.pdf" "44_klassen_dunder_str_rep_eq.pdf" "45_klassen_dunder_hash.pdf" "46_klassen_dunder_math.pdf" "47_debugger.pdf"

cd ..
git clone --depth 1 https://github.com/thomasWeise/programmingWithPythonCode
mv programmingWithPythonCode examples
rm -rf examples/.git

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Done with the download script."
