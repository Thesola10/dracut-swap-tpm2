PREFIX:=/usr
DESTDIR:=

install: tpm2-rotate-swapkey tpm2-rotate-swapkey.service.in 80swap-tpm2
	install tpm2-rotate-swapkey -Dm755 ${DESTDIR}${PREFIX}/bin/tpm2-rotate-swapkey
	mkdir -p ${DESTDIR}${PREFIX}/lib/systemd/system
	env PREFIX=${PREFIX} envsubst < tpm2-rotate-swapkey.service.in > ${DESTDIR}${PREFIX}/lib/systemd/system/tpm2-rotate-swapkey.service
	mkdir -p ${DESTDIR}${PREFIX}/lib/dracut/modules.d
	cp -r 80swap-tpm2 ${DESTDIR}${PREFIX}/lib/dracut/modules.d/

.PHONY: install
