#!/usr/bin/bash

. /lib/dracut-lib.sh

secret_file="/secret.key"
part="$(getarg rd.swap_tpm2_partition=)"
handle="$(getarg rd.swap_tpm2_handle=)"
auth="$(getarg rd.swap_tpm2_auth=)"

info "Got rd.swap_tpm2_handle=$handle and rd.swap_tpm2_auth=$auth"

info "Attempting to unseal TPM..."
tpm2_unseal -c "$handle" -p "$auth" -o "$secret_file"

res="$?"

if [[ "$res" -eq 0 ]]; then
    info "TPM successfully unsealed"

    cryptsetup open --key-file=$secret_file $part swap

    # Attempt to restore hibernation context
    echo "/dev/mapper/swap" > /sys/power/resume
else
    warn "TPM could not unseal"
fi

exit "$res"
