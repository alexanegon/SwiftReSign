# !/bin/bash

#
#  xresign.sh
#  XReSign
#
#  Copyright © 2017 xndrs. All rights reserved.
#

usage="Usage example:
$(basename "$0") -s path -c certificate [-p path] [-g google_service] [-b identifier]

where:
-s  path to ipa file which you want to sign/resign
-c  signing certificate Common Name from Keychain
-p  path to mobile provisioning file (Optional)
-g  path to Google Service Info file (Optional)
-b  Bundle identifier (Optional)"


while getopts s:c:p:g:b: option
do
    case "${option}"
    in
      s) SOURCEIPA=${OPTARG}
         ;;
      c) DEVELOPER=${OPTARG}
         ;;
      p) MOBILEPROV=${OPTARG}
         ;;
      g) GOOGLESERVINFO=${OPTARG}
         ;;
      b) BUNDLEID=${OPTARG}
         ;;
     \?) echo "invalid option: -$OPTARG" >&2
         echo "$usage" >&2
         exit 1
         ;;
      :) echo "missing argument for -$OPTARG" >&2
         echo "$usage" >&2
         exit 1
         ;;
    esac
done


echo "Start resign the app..."

OUTDIR=$(dirname "${SOURCEIPA}")
TMPDIR="$OUTDIR/tmp"
APPDIR="$TMPDIR/app"


mkdir -p "$APPDIR"
unzip -qo "$SOURCEIPA" -d "$APPDIR"

APPLICATION=$(ls "$APPDIR/Payload/")


if [ -z "${MOBILEPROV}" ]; then
    echo "Sign process using existing provisioning profile from payload"
else
    echo "Coping provisioning profile into application payload"
    cp "$MOBILEPROV" "$APPDIR/Payload/$APPLICATION/embedded.mobileprovision"
fi

echo "Extract entitlements from mobileprovisioning"
security cms -D -i "$APPDIR/Payload/$APPLICATION/embedded.mobileprovision" > "$TMPDIR/provisioning.plist"
/usr/libexec/PlistBuddy -x -c 'Print:Entitlements' "$TMPDIR/provisioning.plist" > "$TMPDIR/entitlements.plist"

if [ -z "${GOOGLESERVINFO}" ]; then
    echo "Sign process using existing GoogleService-Info.plist from payload"
else
    echo "Changing GoogleService-Info.plist with : $GOOGLESERVINFO"
    cp "$GOOGLESERVINFO" "$APPDIR/Payload/$APPLICATION/GoogleService-Info.plist"
fi


if [ -z "${BUNDLEID}" ]; then
    echo "Sign process using existing bundle identifier from payload"
else
    echo "Changing BundleID with : $BUNDLEID"
    /usr/libexec/PlistBuddy -c "Set:CFBundleIdentifier $BUNDLEID" "$APPDIR/Payload/$APPLICATION/Info.plist"
fi

echo "Remove Code Signature folders"
find "$APPDIR" -name "_CodeSignature" -type d -delete

echo "Get list of frameworks and resign with certificate: $DEVELOPER"
find -d "$APPDIR" -name "*.framework" > "$TMPDIR/frameworks.txt"
var=$((0))
while IFS='' read -r line || [[ -n "$line" ]]; do
    /usr/bin/codesign --continue -f -s "$DEVELOPER" "$line"
done < "$TMPDIR/frameworks.txt"

echo "Get list of apps and extensions and resign with certificate: $DEVELOPER"
find -d "$APPDIR" \( -name "*.app" -o -name "*.appex" \) > "$TMPDIR/components.txt"
var=$((0))
while IFS='' read -r line || [[ -n "$line" ]]; do
	if [[ ! -z "${BUNDLEID}" ]] && [[ "$line" == *".appex"* ]]; then
	   echo "Changing .appex BundleID with : $BUNDLEID.extra$var"
	   /usr/libexec/PlistBuddy -c "Set:CFBundleIdentifier $BUNDLEID.extra$var" "$line/Info.plist"
	   var=$((var+1))
	fi    
    /usr/bin/codesign --continue -f -s "$DEVELOPER" --entitlements "$TMPDIR/entitlements.plist" "$line"
done < "$TMPDIR/components.txt"


echo "Creating the signed ipa"
cd "$APPDIR"
filename=$(basename "$APPLICATION")
filename="${filename%.*}-resigned.ipa"
zip -qr "../$filename" *
cd ..
mv $filename "$OUTDIR"

echo "Clear temporary files"
rm -rf "$APPDIR"
rm "$TMPDIR/frameworks.txt"
rm "$TMPDIR/components.txt"
rm "$TMPDIR/provisioning.plist"
rm "$TMPDIR/entitlements.plist"

echo "SUCCESS"

# Reveal resigned IPA file in the Finder.
open -R "$OUTDIR/$filename"
