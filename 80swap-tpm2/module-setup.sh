#!/usr/bin/bash

DEFAULT_SECRET_FILE="/swap.key"
DEFAULT_SWAP_PARTITION="/dev/disk/by-partlabel/Swap"
DEFAULT_HANDLE="0x81000000"
DEFAULT_AUTH="pcr:sha1:0,2,4,7"

check() {
    require_binaries "tpm2_unseal"

    if ! tpm2_pcrread > /dev/null; then
        echo "No TPM detected"
        return 1
    fi

    # Taken from crypt module
    #TODO: deprecate?
    [[ $hostonly ]] || [[ $mount_needs ]] && {
        for fs in "${host_fs_types[@]}"; do
            [[ $fs = "crypto_LUKS" ]] && return 0
        done
        return 255
    }

    return 0
}

cmdline() {
    printf '%s' " rd.swap_tpm2_output=$SECRET_FILE"
    printf '%s' " rd.swap_tpm2_partition=$SWAP_PARTITION"
    printf '%s' " rd.swap_tpm2_auth=$DEFAULT_AUTH"
    printf '%s' " rd.swap_tpm2_handle=$DEFAULT_HANDLE"
}

depends() {
    echo 'crypt systemd dracut-systemd'
    return 0
}

installkernel() {
    hostonly='' instmods rng_core tpm tpm_tis_core tpm_crb tpm_tis dm_crypt
}

install() {
    # For tpm2_unseal
    inst "/usr/bin/tpm2_unseal"
    inst "/usr/lib/libtss2-tcti-device.so"

    # Probe TPM modules
    inst_hook cmdline 10 "$moddir/probe-luks-tpm2.sh"

    # Unseal script
    inst "$moddir/unseal-tpm.sh" "/usr/bin/unseal-tpm.sh"

    # Unseal service
    inst "$moddir/unseal-tpm-swap@.service" "/usr/lib/systemd/system/unseal-tpm-swap@.service"

    # Enable cryptsetup-pre.target
    inst "$systemdsystemunitdir/cryptsetup-pre.target"

    # TODO: Get this from dracut cmdline?
    # Enable service
    systemctl -q --root "$initdir" enable unseal-tpm@tpmrm0.service

    # Rules to trigger service
    inst_rules "$moddir/90-tpmrm.rules"
}

