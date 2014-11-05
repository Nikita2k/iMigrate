iMigrate
========

This small bash script helps you to migrate your project's images to Assets catalog (https://developer.apple.com/library/ios/recipes/xcode_help-image_catalog-1.0/Recipe.html). 

Usage
========
Scripts accepts 2 parameters: 
1. Image folder of your project
2. Path to assets catalog

Add +x permission to script and run in terminal.

Example:
./assets.sh /Users/nikitaTook/iMigrate/Images/ /Users/nikitaTook/iMigrate/Images.xcassets

Limitations
========
1. Script can migrate only @1x, @2x, @3x files (currently no support for device modifiers like ~ipad)
2. Don't preserve directory sctructure from your current image list
3. Don't search in nested folder in Assets catalog. This means if you have partially migrated to nested folders in assets (Images.xcassets/Main controller/Header/Background.imageset) your images and haven't deleted images it will be duplicated on top level
