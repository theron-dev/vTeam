#/bin/sh

rm -rf build

xcodebuild
xcodebuild -sdk iphonesimulator7.1
cp -a build/Release-iphoneos build/Release
lipo -create build/Release-iphoneos/vTeam.framework/vTeam build/Release-iphonesimulator/vTeam.framework/vTeam -output build/Release/vTeam.framework/vTeam



