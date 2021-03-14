#!/bin/bash

REPOURL="https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz"
INSTALLOCATION="/usr/local/bin"

echo "Check for installation"
if [ ! -e "${INSTALLOCATION}/elm" ]
then
    echo "No installation detected at ${INSTALLOCATION}, installing..."
    echo "Download code from ${REPOURL}"
    curl -L -o elm.gz $REPOURL
    echo "Unzip"
    gunzip elm.gz
    echo "Mark elm executable as, well, executable"
    chmod +x elm
    echo "Move elm to some file in PATH ${INSTALLOCATION}"
    sudo mv elm $INSTALLOCATION
else
    echo "Elm detected in ${INSTALLOCATION}, all in order"
fi

