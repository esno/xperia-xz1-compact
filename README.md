![android](https://c1.staticflickr.com/7/6021/5979551591_e61f575354_m_d.jpg "android")

Build instructions to compile AOSP for Sony Xperia XZ1 Compact device.
The Xperia XZ1 compact is based on the `yoshino` platform and also known as `lilac`.

# development environment

## system requirements

    | component | minimum     |
    | --------- | ----------- |
    | OS        | 64bit/linux |
    | HDD       | 250GB       |
    | RAM/Swap  | 16GB        |

## setup the toolchain

    lxc-create -n aosp -t download -- -d ubuntu -r bionic -a amd64
    lxc-start -n aosp
    lxc-attach -n aosp --clear-env -- /bin/su -l root

## install dependencies

    dpkg --add-architecture i386
    apt-get update
    apt-get install openjdk-11-jdk bison g++-multilib git gperf libxml2-utils make zlib1g-dev:i386 zip liblz4-tool libncurses5 libssl-dev bc flex curl python gnupg2 rsync git build-essential repo

## prepare aosp tree

    git config --global user.name "aosp"
    git config --global user.email "aosp@localhost"

    mkdir aosp; cd aosp
    repo init repo init -u https://android.googlesource.com/platform/manifest -b android-11.0.0_r18
    cd .repo
    git clone -b android-11.0.0_r18 https://github.com/sonyxperiadev/local_manifests
    repo sync -d -q -c -j8

    ./repo_update.sh

### customize the builds

    git clone https://github.com/esno/xperia-xz1-compact.git vendor/xperia-xz1-compact
    source build/envsetup.sh
    ./vendor/xperia-xz1/compact/repo_update.sh

# handling

## build aosp

The right combos for `lilac` are `aosp_g8441-userdebug` and `aosp_g8441-eng`

    $ lunch aosp_g8441-userdebug
    $ make -j$(nproc)

## build vendor kernel from source

### prepare toolchain

    # gcc
    git clone -b android-11.0.0_r18 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 ~/aosp-gcc-aarch64
    git clone -b android-11.0.0_r18 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 ~/aosp-gcc-arm

    # clang
    wget https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/tags/android-11.0.0_r18/clang-r370808.tar.gz
    mkdir ~/aosp-clang
    tar xzf clang-r370808.tar.gt -C ~/aosp-clang

### compile kernel

    export PATH="~/aosp-gcc-aarch64/bin:~/aosp-gcc-arm/bin:~/aosp-clang/bin:${PATH}"

    git clone -b aosp/LA.UM.7.1.r1 https://github.com/sonyxperiadev/kernel.git ~/kernel-sony
    cd ~/kernel-sony

    make ARCH=arm64 SUBARCH=arm64 \
      CC=clang CLANG_TRIPLE=aarch64-linux-gnu \
      CROSS_COMPILE=aarch64-linux-android- \
      CROSS_COMPILE_ARM32=arm-linux-androideabi- \
      aosp_yoshino_lilac_defconfig

    make ARCH=arm64 SUBARCH=arm64 \
      CC=clang CLANG_TRIPLE=aarch64-linux-gnu \
      CROSS_COMPILE=aarch64-linux-android- \
      CROSS_COMPILE_ARM32=arm-linux-androideabi- \
      -j$(nproc)

    cp arch/arm64/boot/Image.gz-dtb ~/aosp/kernel/sony/msm-4.14/common-kernel/kernel-dtb-lilac

### create boot.img

    $ source build/envsetup.sh && lunch
    including vendor/qcom/opensource/core-utils/vendorsetup.sh
    
    You're building on Linux
    
    Lunch menu... pick a combo:
         1. aosp_arm-eng
         2. aosp_arm64-eng
         3. aosp_blueline_car-userdebug
         4. aosp_bonito_car-userdebug
         5. aosp_bramble-userdebug
         6. aosp_coral_car-userdebug
         7. aosp_crosshatch_car-userdebug
         8. aosp_flame_car-userdebug
         9. aosp_g8141-eng
         10. aosp_g8141-userdebug
         11. aosp_g8142-eng
         12. aosp_g8142-userdebug
         13. aosp_g8341-eng
         14. aosp_g8341-userdebug
         15. aosp_g8342-eng
         16. aosp_g8342-userdebug
         17. aosp_g8441-eng
         18. aosp_g8441-userdebug
         [...]

    Which would you like? [aosp_arm-eng] 17

    $ make -j$(nproc) bootimage

### boot kernel temporarily

    $ fastboot boot <kernel> [<ramdisk> [<seconds>]]

## flash OEM binaries

download [zip archive][aospoem] from sony servers.

    $ fastboot flash oem SW_binaries_for_Xperia_AOSP_<version>_yoshino.img

## flash aosp

Turn off your device, hold down the **volume up** and connect the device to your computer.
The notification light should shine **blue** to confirm it's in fastboot mode.

    fastboot flash boot out/target/product/lilac/boot.img
    fastboot flash recovery out/target/product/lilac/recovery.img
    fastboot flash system out/target/product/lilac/system.img
    fastboot flash vendor out/target/product/lilac/vendor.img
    fastboot flash userdata out/target/product/lilac/userdata.img

## cleanup

    $ fastboot erase cache

## reboot

    $ fastboot reboot

[aospoem]: https://developer.sony.com/develop/open-devices/downloads/software-binaries
