![android](https://c1.staticflickr.com/7/6021/5979551591_e61f575354_m_d.jpg "android")

Build instructions to compile AOSP for Sony Xperia XZ1 Compact device (yoshino).
It requires `lxc` to setup a clean development environment.

# development environment

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

    $ lunch
    $ make # number of cpu's are autodetected in alias

## flash

Turn off your device, hold down the **volume up** and connect the device to your computer.
The notification light should shine **blue** to confirm it's in fastboot mode.

    $ fastboot -s 256M flash boot out/target/product/<device>/boot.img
    $ fastboot -s 256M flash system out/target/product/<device>/system.img
    $ fastboot -s 256M flash userdata out/target/product/<device>/userdata.img

## reboot

    $ fastboot reboot
