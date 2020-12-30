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

## build

The right combos for `lilac` are `aosp_g8441-userdebug` and `aosp_g8441-eng`

    $ lunch aosp_g8441-userdebug
    $ make -j$(nproc)

#### boot kernel temporarily

    $ fastboot boot <kernel> [<ramdisk> [<seconds>]]

## oem (factory reset)

download [zip archive][aospoem] from sony servers.

    $ fastboot flash oem SW_binaries_for_Xperia_AOSP_<version>_yoshino.img

## flash

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
