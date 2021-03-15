#!/bin/bash
NPMINSTALL="node_modules/elm/bin"
ELMVERSION="elm@latest-0.19.1"

echo "Check for installation"

if [ ! -z $1 ]
then
    NPMINSTALL=$1 
fi
echo "Looking for elm in ${NPMINSTALL}"

if [ ! -z $2 ]
then
    ELMVERSION="elm@latest-${2}"
    echo "Elm version set to ${2}"
fi

if [ -e "${NPMINSTALL}/elm" ]
then
    echo "Elm found as installed NPM package"
else
    echo "Elm not found in expected location ${NPMINSTALL}, installing"
    npm install $ELMVERSION
fi
