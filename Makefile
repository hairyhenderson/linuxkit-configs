FWURL := https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree
FWPATH := firmware/ath10k/QCA988X/hw2.0
SD_DEV ?= /dev/rdisk2

images/:
	mkdir -p $@

wpa_supplicant.conf: wpa_supplicant.conf.tmpl wifi-config.yml
	@gomplate -d wifi-config.yml -f $< -o $@

images/boot.ipxe: images/router-initrd.img boot.ipxe
	@gomplate -d cmdline=./images/router-cmdline -f boot.ipxe -o images/boot.ipxe

images/router-bios.img: router.yml wpa_supplicant.conf images/
	linuxkit build -format raw-bios dir images $<

#$(FWPATH)/board.bin $(FWPATH)/firmware-4.bin $(FWPATH)/firmware-5.bin
images/router-initrd.img: router.yml wpa_supplicant.conf images/
	linuxkit build -format kernel+initrd -dir images $<

clean:
	-rm -f wpa_supplicant.conf
	-rm -rf images/

sd: router-bios.img
	dd if=$< bs=1M status=progress of=$(SD_DEV)

ipxe: images/router-initrd.img images/boot.ipxe
	linuxkit serve -directory images/

.PHONY: clean sd
