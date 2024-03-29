# TPM-backed swap encryption with hibernate support

This is my dracut config to encrypt swap with a random key at shutdown, which is then unsealed from TPM to support hibernation.

## Install

On Arch Linux, install the [`dracut-swap-tpm2-git`](https://aur.archlinux.org/packages/dracut-swap-tpm2-git) package from AUR.

Otherwise, run `make install` after cloning this repository.

## Setup

This script creates a dracut module called `swap-tpm2`. Below is an example config file:

```sh
add_dracutmodules+=" swap-tpm2 crypt "

kernel_cmdline+=" rd.swap_tpm2_partition=/dev/sda3 rd.swap_tpm2_handle=0x81000000 rd.swap_tpm2_auth=pcr:sha256:0,2,4,7 "
```

You also need to enable `tpm2-rotate-swapkey.service` in order to enable regenerating the encrypted swap partition. This unit reads kernel command line options and may not work before a reboot.
