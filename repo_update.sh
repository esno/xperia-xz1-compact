#!/bin/bash

source ./build/envsetup.sh
PLATFORM_VERSION=$(printconfig | grep -E "^PLATFORM_VERSION=" | awk -F '=' '{ print $2 }')

update_aosp9() {
  # remove default apps
  cd ./build
  patch -N -p 1 < ../vendor/xperia-xz1-compact/aosp9/patches/remove-apps.patch
  cd ..
}

update_aosp10() {
  # remove default apps
  cd ./build
  patch -N -p 1 < ../vendor/xperia-xz1-compact/aosp10/patches/remove-apps.patch
  cd ..
}

update_aosp11() {
  # replace old precompiled lilac kernel
  cp ${ANDROID_BUILD_TOP}/vendor/xperia-xz1-compact/kernel/v4.14.208/kernel-dtb-lilac \
    ${ANDROID_BUILD_TOP}/kernel/sony/msm-4.14/common-kernel/kernel-dtb-lilac

  # remove default apps
  cd ${ANDROID_BUILD_TOP}/build
  patch -N -p 1 < ${ANDROID_BUILD_TOP}/vendor/xperia-xz1-compact/aosp11/patches/remove-apps.patch
  cd ${ANDROID_BUILD_TOP}
}

case "${PLATFORM_VERSION}" in
  9)
    update_aosp9
    ;;
  10)
    update_aosp10
    ;;
  11)
    update_aosp11
    ;;
esac
