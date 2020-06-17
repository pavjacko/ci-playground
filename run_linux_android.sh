#!/usr/bin/env bash

# RUN CHECK
echo "CURRENT ENV:: TRAVIS_BRANCH: $TRAVIS_BRANCH, TRAVIS_PULL_REQUEST: $TRAVIS_PULL_REQUEST, TRAVIS_TAG: $TRAVIS_TAG , TRAVIS_OS_NAME: $TRAVIS_OS_NAME"

# DEFINITIONS

# SETUP
set -e
set -o xtrace
set -o verbose
set -o pipefail

mkdir -p $HOME/android-sdk-dl
mkdir -p $HOME/android-sdk
if test ! -e $HOME/android-sdk-dl/sdk-tools.zip ; then curl https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip > $HOME/android-sdk-dl/sdk-tools.zip ; fi
unzip -qq -n $HOME/android-sdk-dl/sdk-tools.zip -d $HOME/android-sdk
echo y | $HOME/android-sdk/tools/bin/sdkmanager 'tools' > /dev/null
echo y | $HOME/android-sdk/tools/bin/sdkmanager 'platform-tools' > /dev/null
echo y | $HOME/android-sdk/tools/bin/sdkmanager 'build-tools;28.0.2' > /dev/null
echo y | $HOME/android-sdk/tools/bin/sdkmanager 'platforms;android-27' > /dev/null
echo y | $HOME/android-sdk/tools/bin/sdkmanager 'platforms;android-22' > /dev/null
echo y | $HOME/android-sdk/tools/bin/sdkmanager 'extras;google;m2repository' > /dev/null
echo y | $HOME/android-sdk/tools/bin/sdkmanager 'extras;android;m2repository' > /dev/null
echo y | $HOME/android-sdk/tools/bin/sdkmanager 'extras;google;google_play_services' > /dev/null
echo y | $HOME/android-sdk/tools/bin/sdkmanager 'emulator' > /dev/null
echo yes | $HOME/android-sdk/tools/bin/sdkmanager --licenses

export ANDROID_HOME=$HOME/android-sdk/
export ANDROID_SDK_ROOT=$HOME/android-sdk/
export PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools
echo yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses
$ANDROID_HOME/tools/bin/sdkmanager "system-images;android-22;default;armeabi-v7a" > /dev/null
$ANDROID_HOME/tools/bin/sdkmanager --list | head -15
echo yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses
echo no | $ANDROID_HOME/tools/bin/avdmanager create avd --force -n test -k "system-images;android-22;default;armeabi-v7a"
$ANDROID_HOME/emulator/emulator -avd test -no-audio -no-window &
$ANDROID_HOME/platform-tools/adb wait-for-device shell 'while [[ -z $(getprop init.svc.bootanim) ]]; do sleep 1; done; input keyevent 82'
$ANDROID_HOME/platform-tools/adb shell settings put global window_animation_scale 0 &
$ANDROID_HOME/platform-tools/adb shell settings put global transition_animation_scale 0 &
$ANDROID_HOME/platform-tools/adb shell settings put global animator_duration_scale 0 &
$ANDROID_HOME/platform-tools/adb shell settings put secure show_ime_with_hard_keyboard 0 &
$ANDROID_HOME/platform-tools/adb shell input keyevent 82 &


echo "done"
