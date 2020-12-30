#!/bin/bash

# replace old precompiled lilac kernel
cp ${ANDROID_BUILD_TOP}/vendor/xperia-xz1-compact/kernel/v4.14.208/kernel-dtb-lilac \
  ${ANDROID_BUILD_TOP}/kernel/sony/msm-4.14/common-kernel/kernel-dtb-lilac

# remove default apps
cd ${ANDROID_BUILD_TOP}/build
patch -N -p 1 < ${ANDROID_BUILD_TOP}/vendor/xperia-xz1-compact/patches/remove-apps.patch
cd ${ANDROID_BUILD_TOP}
