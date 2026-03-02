#!/bin/bash -

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Welcome to the sources download script."

curDir="$(pwd)"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The current directory is '$curDir'."

scriptDir="$(realpath "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/bookbase/scripts")"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The script directory is '$scriptDir'."

gitDownload="$(realpath "$scriptDir/gitDownload.sh")"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The git download script is 'gitDownload'."

downloadDir="programmingWithPython_sources_$(date +"%Y%m%d")"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We will use the download directory '$downloadDir'."
mkdir -p "$downloadDir"
cd "$downloadDir"

"$gitDownload" "programmingWithPython"
"$gitDownload" "programmingWithPythonQuestions"
"$gitDownload" "programmingWithPythonSlidesDE"
"$gitDownload" "programmingWithPythonSlidesDE2"
"$gitDownload" "programmingWithPythonCode"

"$scriptDir/downloadStandardSources.sh"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Done with the sources download script."
