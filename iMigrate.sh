#!/bin/bash

#
#  Created by Nikita Took on 04.11.14.
#

# TODO:
#    1. Support ~ipad/~iphone file names (in search)
#    2. Support iphone/ipad specific files in Content.json
#    3. Move to functions
#    4. Add tabs in output json
#    5. Keep directory structure while moving to assets
#    6. Check nested folders in assets catalog

echo 'Images catalog:' "$1"
echo 'Assets catalog: ' "$2"
for filepath in "$1"*.png "$1"**/*.png;
do
    echo 'Processing file at path:' "$filepath"

    # filenameWithExtension holds full image name:
    # <ImageName><resolution_modifier><device_modifier>.<filename_extension>
    # for example, planet@2x~ipad.png or (more common) plane@2x.png
    filenameWithExtension=$(basename "$filepath")

    # filenameWithDevices holds full image name without extension (png)
    filenameWithDevice="${filenameWithExtension%.*}"
    echo 'Device-specific name:' "$filenameWithDevice"

    # split filename into imageName and the rest
    # preserve old IFS
    OIFS=$IFS
    IFS='@'
    read -ra FNAME <<< "$filenameWithDevice"
    IFS=$OIFS

    # filename holds real image name (plane)
    filename=${FNAME[0]}
    resolutionAndDeviceModifier=${FNAME[1]}
    echo 'Filename:' "$filename"

    # getting assets catalog folder name: imageName.imageset (plane.imageset)
    assetDirectoryPath="$2/$filename.imageset"
    echo 'Checking if assets catalog folder exists' "$assetDirectoryPath"

    # check if asset catalog already exists
    if [ ! -d "$assetDirectoryPath" ]; then
        echo 'No assets folder. Creating folder:' "$assetDirectoryPath"
        mkdir "$assetDirectoryPath"
    fi

    # at that point we already have imageName.imageset folder in assets catalog
    contentsJsonFilePath="$assetDirectoryPath/Contents.json"
    echo 'Checking if Contents.json exists' "$contentsJsonFilePath"

    # create Contents.json file if not exists and populate it with default json
    if [ ! -f "$contentsJsonFilePath" ]; then
        echo 'No Contents.json. Creating file:' "$contentsJsonFilePath"
        touch "$contentsJsonFilePath"
read -d '' defaultJson << EOF
{
    "images" : [
    {
        "idiom" : "universal",
        "scale" : "1x"
        },
        {
        "idiom" : "universal",
        "scale" : "2x"
        },
        {
        "idiom" : "universal",
        "scale" : "3x"
        }
    ],
    "info" : {
        "version" : 1,
        "author" : "xcode"
    }
}
EOF
    echo "$defaultJson" > "$contentsJsonFilePath"
    fi

    echo 'Resolution and device modifier:' "$resolutionAndDeviceModifier"

    # move files to assets catalog
    cp "$filepath" "$assetDirectoryPath/$filenameWithExtension"

    # check resolution and device modifiers to add corresponding json

    # here goes all @1x resources (so resolutionAndDeviceModifier should be empty or starts with ~ for ~ipad)
    if [ -z "$resolutionAndDeviceModifier" ] || [[ $resolutionAndDeviceModifier == ~* ]]
    then
        echo 'Adding @1x resources'

        # TODO: add tab symbol
        sed -i '' '/1x/a\
            '",\"filename\" : \"$filenameWithExtension\""'\
            ' "$contentsJsonFilePath"
    fi

    # here goes all @2x resources
    if [[ $resolutionAndDeviceModifier == 2* ]]
    then
        echo 'Adding @2x resource'
        # TODO: add tab symbol
        sed -i '' '/2x/a\
            '",\"filename\" : \"$filenameWithExtension\""'\
            ' "$contentsJsonFilePath"
    fi

    # here goes all @3x resources
    if [[ $resolutionAndDeviceModifier == 3* ]]
    then
        echo 'Adding @3x resource'
        # TODO: add tab symbol
        sed -i '' '/3x/a\
            '",\"filename\" : \"$filenameWithExtension\""'\
            ' "$contentsJsonFilePath"
    fi
done
