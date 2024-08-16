#!/bin/bash -

# This script filters a PDF file and attempts to include as many fonts as possible.

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Welcome to the pdf filtering script."

currentDir="$(pwd)"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We are working in directory: '$currentDir'."

fileIn="$(readlink -f "$1")"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The full input document path is '$fileIn'."

fileOut="$2"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We will filter the input document '$fileIn' to '$fileOut'."

tempDir="$(mktemp -d)"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We will use the temporary directory '$tempDir'."

cd "$tempDir"

tempFileSrc="$(mktemp --tmpdir="$tempDir")"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We will first copy '$fileIn' to '$tempFileSrc'."
cp "$fileIn" "$tempFileSrc"
fileSize="$(stat -c%s "$tempFileSrc")"
oldFileSize=""
cycle=0

while :
do
  cycle=$((cycle+1))
  tempFileDst="$(mktemp --tmpdir="$tempDir")"
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now beginning filter cycle $cycle with destination '$tempFileDst'."

  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We use ghostscript to filter '$tempFileSrc' to '$tempFileDst'."
  gs -dAntiAliasColorImages=true \
     -dAntiAliasGrayImages=true \
     -dAntiAliasMonoImages=true \
     -dAutoFilterColorImages=false \
     -dAutoFilterGrayImages=false \
     -dAutoRotatePages=/None \
     -dBATCH \
     -dCannotEmbedFontPolicy=/Error \
     -dColorConversionStrategy=/LeaveColorUnchanged \
     -dColorImageFilter=/FlateEncode \
     -dCompatibilityLevel=1.4 \
     -dCompressFonts=true \
     -dCompressStreams=true \
     -dCreateJobTicket=false \
     -dDetectDuplicateImages=true \
     -dDoThumbnails=false \
     -dDownsampleColorImages=false \
     -dDownsampleGrayImages=false \
     -dDownsampleMonoImages=false \
     -dEmbedAllFonts=true \
     -dFastWebView=false \
     -dGrayImageFilter=/FlateEncode \
     -dHaveTransparency=true \
     -dMaxBitmap=2147483647 \
     -dNOPAUSE \
     -dOptimize=true \
     -dPassThroughJPEGImages=true \
     -dPassThroughJPXImages=true \
     -dPDFSTOPONERROR=true \
     -dPDFSTOPONWARNING=true \
     -dPreserveCopyPage=false \
     -dPreserveEPSInfo=false \
     -dPreserveHalftoneInfo=false \
     -dPreserveOPIComments=false \
     -dPreserveOverprintSettings=false \
     -dPreserveSeparation=false \
     -dPreserveDeviceN=false \
     -dPreserveMarkedContent=false \
     -dPrinted=false \
     -dOmitInfoDate=true \
     -dOmitID=true \
     -dOmitXMP=true \
     -dQUIET \
     -dSAFER \
     -dSubsetFonts=true \
     -dUCRandBGInfo=/Remove \
     -dUNROLLFORMS \
     -sDEVICE=pdfwrite \
     -sOutputFile="$tempFileDst" "$tempFileSrc" \
     -c "<</NeverEmbed [ ]>> setdistillerparams" \
     -c "/PreserveAnnotTypes [/Link] def" \
     -q

  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We filtered '$tempFileSrc' to '$tempFileDst' using ghostscript."
  oldFileSize="$fileSize"
  echo "--- the size of the old file '$tempFileSrc': $oldFileSize"
  fileSize="$(stat -c%s "$tempFileDst")"
  echo "--- the size of the new file '$tempFileDst': $fileSize"

  if (("$cycle" > 3)) ; then
    if (("$fileSize" >= "$oldFileSize")) ; then
      echo "--- We completed $cycle cycles and the new file is not smaller than the old file, so we stop and use the old file."
      rm "$tempFileDst"
      break
    else
      echo "--- We completed $cycle cycles and the new file is smaller than the old file, so we continue."
    fi
  else
    echo "--- We completed only $cycle cycles, so we continue."
  fi

  rm "$tempFileSrc"
  tempFileSrc="$tempFileDst"
  done

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now moving '$tempFileSrc' to '$fileOut'."
cd "$currentDir"
mv "$tempFileSrc" "$fileOut"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now cleaning up '$tempDir'."
rm -rf "$tempDir"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Successfully finished filtering '$fileIn' to '$fileOut using ghostscript."
