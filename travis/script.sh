#!/bin/sh
set -e

xctool -project Demo/COSlideMenuDemo.xcodeproj -scheme COSlideMenuDemo build test -sdk iphonesimulator

