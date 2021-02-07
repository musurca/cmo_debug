#!/bin/bash
# CMO DEBUG - BUILD SCRIPT

# Release path: compiled, minified
IKE_RELEASE_PATH="./release"
IKE_RELEASE_NAME="debug_min.lua"
# Debug path: compiled, unminified
IKE_DEBUG_PATH="./debug"
IKE_DEBUG_NAME="debug_debug.lua"

# The path to the source files
IKE_SRC_PATH="./src"

# Edit these lines to add new source files to the build.
# Files are added in the order that they are listed.
IKE_LOADER_INCLUDE=("util.lua" "geo.lua" "logistics.lua" "side.lua" "editor.lua" "debug.lua")
IKE_WIZARD_INCLUDE=("main.lua")

# -------DO NOT EDIT BELOW THIS LINE--------
IKE_COMMENTS="xx_comments.lua"
IKE_LOADERINIT="xx_loader.lua"
IKE_FINALINIT="xx_finalinit.lua"
IKE_EVERYLOAD="xx_everyload.lua"

if [ "$1" = "debug" ]; then
    IKE_BUILD_PATH="$IKE_DEBUG_PATH"
    IKE_FINAL_PATH="$IKE_DEBUG_PATH/$IKE_DEBUG_NAME"
else
    IKE_BUILD_PATH="$IKE_RELEASE_PATH"
    IKE_FINAL_PATH="$IKE_RELEASE_PATH/$IKE_RELEASE_NAME"
fi

mkdir tmp
if [ -d $IKE_BUILD_PATH ]; then
    if [ -f $IKE_FINAL_PATH ]; then
        rm $IKE_FINAL_PATH
    fi
else
    mkdir $IKE_BUILD_PATH
fi

# build IKE loader
for f in ${IKE_LOADER_INCLUDE[@]}; do
    cat $IKE_SRC_PATH/$f >> tmp/header.lua
done
cat tmp/header.lua > tmp/loader.lua
cat $IKE_SRC_PATH/$IKE_EVERYLOAD >> tmp/loader.lua
if [ "$1" = "debug" ]; then
    cat tmp/loader.lua > tmp/loader_min.lua
else
    luamin -f tmp/loader.lua > tmp/loader_min.lua
fi

# build the escape string for loading
python3 escape.py tmp/loader_min.lua tmp/loader_escaped.txt

# build IKE wizard
for f in ${IKE_WIZARD_INCLUDE[@]}; do
    cat $IKE_SRC_PATH/$f >> tmp/header.lua
done
cat $IKE_SRC_PATH/$IKE_LOADERINIT >> tmp/header.lua
cat tmp/loader_escaped.txt >> tmp/header.lua
cat $IKE_SRC_PATH/$IKE_FINALINIT >> tmp/header.lua

# combine into final compiled minified lua
if [ "$1" = "debug" ]; then
    cat tmp/header.lua > tmp/final_min.lua
else
    luamin -f tmp/header.lua > tmp/final_min.lua
fi

cat $IKE_SRC_PATH/$IKE_COMMENTS > $IKE_FINAL_PATH
cat tmp/final_min.lua >> $IKE_FINAL_PATH

echo "Success! CMO DEBUG has been compiled to $IKE_FINAL_PATH."

# clear the temporary directory
rm -rf tmp

