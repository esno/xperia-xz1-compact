![android](https://c1.staticflickr.com/7/6021/5979551591_e61f575354_m_d.jpg "android")

Build instructions to compile AOSP for Sony Xperia XZ1 Compact device.
It requires `lxc` to setup a clean development environment.

The Xperia XZ1 compact is based on the `yoshino` platform and also known as `lilac`.

# development environment

## system requirements

| component | minimum     |
| --------- | ----------- |
| OS        | 64bit/linux |
| HDD       | 250GB       |
| RAM/Swap  | 16GB        |

## setup the toolchain

    $ git clone https://github.com/esno/xperia-xz1-compact.git
    $ bash ./env.sh <container>

## update the toolchain

    $ bash ./env.sh <container>

## enter development environment

    $ lxc-attach -n <container> -- /bin/su -l user

## prepare sources

    $ cd /var/lib/aosp8
    $ repo sync
    $ ./repo-update.sh

# handling

## build

The right combo for `lilac` is `aosp_g8441-userdebug`

    $ lunch aosp_g8441-userdebug
    $ make # number of cpu's are autodetected in alias

### kernel

The Xperia XZ1 compact does **not** boot with the precompiled kernel.
When your device stuck in boot splash (white screen with sony brand) press **volume up** and **power**.
The device vibrates once to notify a reboot. If you want to shutdown the device keep this buttons pressed until
it vibrates three times.

    $ rm -r device/sony/common-kernel
    $ make bootimage

#### boot kernel temporarily

    $ fastboot boot <kernel> [<ramdisk> [<seconds>]]

## flash

Turn off your device, hold down the **volume up** and connect the device to your computer.
The notification light should shine **blue** to confirm it's in fastboot mode.

    $ fastboot -S 256M flash boot out/target/product/<device>/boot.img
    $ fastboot -S 256M flash system out/target/product/<device>/system.img
    $ fastboot -S 256M flash userdata out/target/product/<device>/userdata.img

## oem (factory reset)

download [zip archive][aosp8oem] from sony servers.

    $ fastboot flash oem SW_binaries_for_Xperia_AOSP_<version>_yoshino.img


## cleanup

    $ fastboot erase cache

## reboot

    $ fastboot reboot

[aosp8oem]: https://developer.sonymobile.com/downloads/software-binaries/software-binaries-for-aosp-oreo-android-8-kernel-4-4-yoshino/
