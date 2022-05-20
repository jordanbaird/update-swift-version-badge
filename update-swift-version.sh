#!/bin/bash

verify() {
    if test ! -f "Package.swift"; then
        echo 'No "Package.swift" file exists.'
        exit 1
    fi

    if test ! -f "README.md"; then
        echo 'No "README.md" file exists.'
        exit 1
    fi
}

performReplace() {
    if [[ $OSTYPE == darwin* ]]; then
        sed -ri "" -e "s/(Swift-)([0-9]+.[0-9]+)/\1$VERSION/g" ./README.md
    else
        sed -ri -e "s/(Swift-)([0-9]+.[0-9]+)/\1$VERSION/g" ./README.md
    fi
}

verify

STV="swift-tools-version:"
VERSION=$(cat ./Package.swift | grep $STV | sed -e "s/$STV/ /" | awk {'print $NF'})

if cat ./README.md | grep -qE "!\[Swift Version\]\(.+\)"; then
    echo "UPDATING..."
    performReplace
else
    echo 'README file does not contain a "![Swift Version](...)" tag. Appending new tag instead...'
    echo "![Swift Version](https://img.shields.io/badge/Swift-$VERSION%2B-orange)" >> ./README.md
fi
