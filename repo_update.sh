#!/bin/bash

# replace old precompiled lilac kernel
cp ${ANDROID_BUILD_TOP}/vendor/xperia-xz1-compact/kernel/v4.14.208/kernel-dtb-lilac \
  ${ANDROID_BUILD_TOP}/kernel/sony/msm-4.14/common-kernel/kernel-dtb-lilac
