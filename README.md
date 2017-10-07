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

    $ lunch

    You're building on Linux

    Lunch menu... pick a combo:
      1. aosp_arm-eng
      2. aosp_arm64-eng
      3. aosp_mips-eng
      4. aosp_mips64-eng
      5. aosp_x86-eng
      6. aosp_x86_64-eng
      7. full_fugu-userdebug
      8. aosp_fugu-userdebug
      9. car_emu_arm64-userdebug
      10. car_emu_arm-userdebug
      11. car_emu_x86_64-userdebug
      12. car_emu_x86-userdebug
      13. mini_emulator_arm64-userdebug
      14. m_e_arm-userdebug
      15. m_e_mips64-eng
      16. m_e_mips-userdebug
      17. mini_emulator_x86_64-userdebug
      18. mini_emulator_x86-userdebug
      19. aosp_dragon-userdebug
      20. aosp_dragon-eng
      21. aosp_marlin-userdebug
      22. aosp_marlin_svelte-userdebug
      23. aosp_sailfish-userdebug
      24. aosp_angler-userdebug
      25. aosp_bullhead-userdebug
      26. aosp_bullhead_svelte-userdebug
      27. hikey-userdebug
      28. aosp_f8131-userdebug
      29. aosp_f8132-userdebug
      30. aosp_f8331-userdebug
      31. aosp_f8332-userdebug
      32. aosp_g8231-userdebug
      33. aosp_g8232-userdebug
      34. aosp_f5321-userdebug
      35. aosp_g8441-userdebug
      36. aosp_g8141-userdebug
      37. aosp_g8142-userdebug
      38. aosp_g8341-userdebug
      39. aosp_g8342-userdebug
      40. aosp_f5121-userdebug
      41. aosp_f5122-userdebug
      42. aosp_e2303-userdebug
      43. aosp_e2333-userdebug

    Which would you like? [aosp_arm-eng] 35

    ============================================
    PLATFORM_VERSION_CODENAME=REL
    PLATFORM_VERSION=8.0.0
    TARGET_PRODUCT=aosp_g8441
    TARGET_BUILD_VARIANT=userdebug
    TARGET_BUILD_TYPE=release
    TARGET_PLATFORM_VERSION=OPR1
    TARGET_BUILD_APPS=
    TARGET_ARCH=arm64
    TARGET_ARCH_VARIANT=armv8-a
    TARGET_CPU_VARIANT=kryo
    TARGET_2ND_ARCH=arm
    TARGET_2ND_ARCH_VARIANT=armv7-a-neon
    TARGET_2ND_CPU_VARIANT=kryo
    HOST_ARCH=x86_64
    HOST_2ND_ARCH=x86
    HOST_OS=linux
    HOST_OS_EXTRA=Linux-4.13.3-1-ARCH-x86_64-with-Ubuntu-16.04-xenial
    HOST_CROSS_OS=windows
    HOST_CROSS_ARCH=x86
    HOST_CROSS_2ND_ARCH=x86_64
    HOST_BUILD_TYPE=release
    BUILD_ID=OPR3.170623.008
    OUT_DIR=out
    AUX_OS_VARIANT_LIST=
    ============================================
    $
    $ make # number of cpu's are autodetected in alias

## flash

Turn off your device, hold down the **volume up** and connect the device to your computer.
The notification light should shine **blue** to confirm it's in fastboot mode.

    $ fastboot -s 256M flash boot out/target/product/<device>/boot.img
    $ fastboot -s 256M flash system out/target/product/<device>/system.img
    $ fastboot -s 256M flash userdata out/target/product/<device>/userdata.img

## reboot

    $ fastboot reboot
