flutter clean
flutter build appbundle --release
flutter build ios --release --no-codesign
cd android
fastlane deploy
cd ../ios
fastlane release
