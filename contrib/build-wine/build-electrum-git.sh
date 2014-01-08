#!/bin/bash

# You probably need to update only this link
ELECTRUM_GIT_URL=git://github.com/spesmilo/shuttle.git
BRANCH=master
NAME_ROOT=shuttle

# These settings probably don't need any change
export WINEPREFIX=/opt/wine-shuttle
PYHOME=c:/python26
PYTHON="wine $PYHOME/python.exe -OO -B"

# Let's begin!
cd `dirname $0`
set -e

cd tmp

if [ -d "shuttle-git" ]; then
    # GIT repository found, update it
    echo "Pull"

    cd shuttle-git
    git pull
    cd ..

else
    # GIT repository not found, clone it
    echo "Clone"

    git clone -b $BRANCH $ELECTRUM_GIT_URL shuttle-git
fi

cd shuttle-git
COMMIT_HASH=`git rev-parse HEAD | awk '{ print substr($1, 0, 11) }'`
echo "Last commit: $COMMIT_HASH"
cd ..


rm -rf $WINEPREFIX/drive_c/shuttle
cp -r shuttle-git $WINEPREFIX/drive_c/shuttle
cp shuttle-git/LICENCE .

# Build Qt resources
wine $WINEPREFIX/drive_c/Python26/Lib/site-packages/PyQt4/pyrcc4.exe C:/shuttle/icons.qrc -o C:/shuttle/lib/icons_rc.py

# Copy ZBar libraries to shuttle
#cp "$WINEPREFIX/drive_c/Program Files (x86)/ZBar/bin/"*.dll "$WINEPREFIX/drive_c/shuttle/"

cd ..

rm -rf dist/

# For building standalone compressed EXE, run:
$PYTHON "C:/pyinstaller/pyinstaller.py" --noconfirm --ascii -w --onefile "C:/shuttle/shuttle"

# For building uncompressed directory of dependencies, run:
$PYTHON "C:/pyinstaller/pyinstaller.py" --noconfirm --ascii -w deterministic.spec

# For building NSIS installer, run:
wine "$WINEPREFIX/drive_c/Program Files (x86)/NSIS/makensis.exe" shuttle.nsi
#wine $WINEPREFIX/drive_c/Program\ Files\ \(x86\)/NSIS/makensis.exe shuttle.nsis

DATE=`date +"%Y%m%d"`
cd dist
mv shuttle.exe $NAME_ROOT-$DATE-$COMMIT_HASH.exe
mv shuttle $NAME_ROOT-$DATE-$COMMIT_HASH
mv shuttle-setup.exe $NAME_ROOT-$DATE-$COMMIT_HASH-setup.exe
zip -r $NAME_ROOT-$DATE-$COMMIT_HASH.zip $NAME_ROOT-$DATE-$COMMIT_HASH
