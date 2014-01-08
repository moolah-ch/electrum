#!/bin/bash

# You probably need to update only this link
ELECTRUM_URL=http://shuttle.dogecoin.cz/download/Shuttle-1.6.1.tar.gz
NAME_ROOT=shuttle-1.6.1

# These settings probably don't need any change
export WINEPREFIX=/opt/wine-shuttle
PYHOME=c:/python26
PYTHON="wine $PYHOME/python.exe -OO -B"

# Let's begin!
cd `dirname $0`
set -e

cd tmp

# Download and unpack Shuttle
wget -O shuttle.tgz "$ELECTRUM_URL"
tar xf shuttle.tgz
mv Shuttle-* shuttle
rm -rf $WINEPREFIX/drive_c/shuttle
cp shuttle/LICENCE .
mv shuttle $WINEPREFIX/drive_c

# Copy ZBar libraries to shuttle
#cp "$WINEPREFIX/drive_c/Program Files (x86)/ZBar/bin/"*.dll "$WINEPREFIX/drive_c/shuttle/"

cd ..

rm -rf dist/$NAME_ROOT
rm -f dist/$NAME_ROOT.zip
rm -f dist/$NAME_ROOT.exe
rm -f dist/$NAME_ROOT-setup.exe

# For building standalone compressed EXE, run:
$PYTHON "C:/pyinstaller/pyinstaller.py" --noconfirm --ascii -w --onefile "C:/shuttle/shuttle"

# For building uncompressed directory of dependencies, run:
$PYTHON "C:/pyinstaller/pyinstaller.py" --noconfirm --ascii -w deterministic.spec

# For building NSIS installer, run:
wine "$WINEPREFIX/drive_c/Program Files (x86)/NSIS/makensis.exe" shuttle.nsi
#wine $WINEPREFIX/drive_c/Program\ Files\ \(x86\)/NSIS/makensis.exe shuttle.nsis

cd dist
mv shuttle.exe $NAME_ROOT.exe
mv shuttle $NAME_ROOT
mv shuttle-setup.exe $NAME_ROOT-setup.exe
zip -r $NAME_ROOT.zip $NAME_ROOT
