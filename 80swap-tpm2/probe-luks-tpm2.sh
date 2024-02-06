#!/usr/bin/bash

TPM_MODULES=("rng_core" "tpm" "tpm_tis_core" "tpm_crb" "tpm_tis" "dm_crypt")

for m in "${TPM_MODULES[@]}"; do
    modprobe "$m"
done
