#/bin/sh

rm -rf build


if [ $1 ]
then

target=$1

else

target=Release

fi


xcodebuild -configuration $target
xcodebuild -sdk iphonesimulator7.1 -configuration $target
cp -a build/$target-iphoneos build/$target
lipo -create build/$target-iphoneos/vTeam.framework/vTeam build/$target-iphonesimulator/vTeam.framework/vTeam -output build/$target/vTeam.framework/vTeam



