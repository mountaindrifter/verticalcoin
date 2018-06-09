#!/bin/bash

OUTDIR=$TRAVIS_BUILD_DIR/out/$TRAVIS_PULL_REQUEST/$TRAVIS_JOB_NUMBER-$HOST
mkdir -p $OUTDIR/bin

ARCHIVE_CMD="zip"

if [[ $HOST = "i686-w64-mingw32" ]]; then
  ARCHIVE_NAME="windows-x86.zip"
elif [[ $HOST = "x86_64-w64-mingw32" ]]; then
    ARCHIVE_NAME="windows-x64.zip"
elif [[ $HOST = "arm-linux-gnueabihf" ]]; then
    ARCHIVE_NAME="arm-x86.tar.gz"
    ARCHIVE_CMD="tar -czf"
elif [[ $HOST = "aarch64-linux-gnu" ]]; then
    ARCHIVE_NAME="arm-x64.tar.gz"
    ARCHIVE_CMD="tar -czf"
elif [[ $HOST = "x86_64-unknown-linux-gnu" ]]; then
    ARCHIVE_NAME="linux-x64.tar.gz"
    ARCHIVE_CMD="tar -czf"
elif [[ $HOST = "x86_64-apple-darwin10" ]]; then
    ARCHIVE_NAME="osx-10-x64.zip"
elif [[ $HOST = "x86_64-apple-darwin11" ]]; then
    ARCHIVE_NAME="osx-11-x64.zip"
elif [[ $HOST = "x86_64-apple-darwin12" ]]; then
    ARCHIVE_NAME="osx-12-x64.zip"
elif [[ $HOST = "x86_64-apple-darwin13" ]]; then
    ARCHIVE_NAME="osx-13-x64.zip"
fi

cp $TRAVIS_BUILD_DIR/src/qt/verticalcoin-qt $OUTDIR/bin/ || cp $TRAVIS_BUILD_DIR/src/qt/verticalcoin-qt.exe $OUTDIR/bin/ || echo "no QT Wallet"
cp $TRAVIS_BUILD_DIR/src/verticalcoind $OUTDIR/bin/ || cp $TRAVIS_BUILD_DIR/verticalcoind.exe $OUTDIR/bin/
cp $TRAVIS_BUILD_DIR/src/verticalcoin-cli $OUTDIR/bin/ || cp $TRAVIS_BUILD_DIR/src/verticalcoin-cli.exe $OUTDIR/bin/
strip "$OUTDIR/bin"/* || echo "nothing to strip"
ls -lah $OUTDIR/bin

cd $OUTDIR/bin
ARCHIVE_CMD="$ARCHIVE_CMD $ARCHIVE_NAME *"
eval $ARCHIVE_CMD

mkdir -p $OUTDIR/zip
mv $ARCHIVE_NAME $OUTDIR/zip

sleep $[ ( $RANDOM % 6 )  + 1 ]s