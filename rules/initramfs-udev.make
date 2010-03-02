# -*-makefile-*-
#
# Copyright (C) 2009 by Jon Ringle <jon@ringle.org>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_INITRAMFS_UDEV) += initramfs-udev

#
# Paths and names
#
INITRAMFS_UDEV             = initramfs-$(UDEV)
INITRAMFS_UDEV_SOURCE      = $(UDEV_SOURCE)
INITRAMFS_UDEV_DIR         = $(INITRAMFS_BUILDDIR)/$(UDEV)

ifdef PTXCONF_INITRAMFS_UDEV
$(STATEDIR)/klibc.targetinstall.post: $(STATEDIR)/initramfs-udev.targetinstall
endif

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

INITRAMFS_UDEV_PATH	:= PATH=$(INITRAMFS_PATH)
INITRAMFS_UDEV_ENV 	:= \
	$(INITRAMFS_ENV) \
	ac_cv_lib_c_inotify_init=yes

#
# autoconf
#
INITRAMFS_UDEV_AUTOCONF := \
	$(INITRAMFS_AUTOCONF) \
	--libexecdir=/lib/udev \
	--with-kernel-headers-dir=$(PTXDIST_SYSROOT_TOOLCHAIN_INITRAMFS)/usr/include \
	\
	--disable-dependency-tracking \
	--disable-introspection \
	--enable-shared

ifdef PTXCONF_INITRAMFS_UDEV_DEBUG
INITRAMFS_UDEV_AUTOCONF	+= --enable-debug
else
INITRAMFS_UDEV_AUTOCONF	+= --disable-debug
endif

ifdef PTXCONF_INITRAMFS_UDEV_LIBGUDEV
INITRAMFS_UDEV_AUTOCONF	+= --enable-gudev
else
UDEV_AUTOCONF	+= --disable-gudev
endif

ifeq ($(PTXCONF_ARCH_ARM)-$(PTXCONF_INITRAMFS_UDEV_EXTRA_HID2HCI),-y)
INITRAMFS_UDEV_AUTOCONF	+= --enable-bluetooth
else
INITRAMFS_UDEV_AUTOCONF	+= --disable-bluetooth
endif

ifdef PTXCONF_INITRAMFS_UDEV_EXTRA_KEYMAP
INITRAMFS_UDEV_AUTOCONF	+= --enable-keymap
else
INITRAMFS_UDEV_AUTOCONF	+= --disable-keymap
endif

ifdef PTXCONF_INITRAMFS_UDEV_EXTRA_UDEV_ACL
INITRAMFS_UDEV_AUTOCONF	+= --enable-acl
else
INITRAMFS_UDEV_AUTOCONF	+= --disable-acl
endif

ifdef PTXCONF_INITRAMFS_UDEV_EXTRA_USB_DB
INITRAMFS_UDEV_AUTOCONF	+= --enable-usbdb
else
INITRAMFS_UDEV_AUTOCONF	+= --disable-usbdb
endif

ifdef PTXCONF_INITRAMFS_UDEV_EXTRA_PCI_DB
INITRAMFS_UDEV_AUTOCONF	+= --enable-pcidb
else
INITRAMFS_UDEV_AUTOCONF	+= --disable-pcidb
endif

ifdef PTXCONF_INITRAMFS_UDEV_EXTRA_MODEM_MODESWITCH
INITRAMFS_UDEV_AUTOCONF	+= --enable-modem-modeswitch
else
INITRAMFS_UDEV_AUTOCONF	+= --disable-modem-modeswitch
endif

ifdef PTXCONF_INITRAMFS_UDEV_SELINUX
INITRAMFS_UDEV_AUTOCONF	+= --with-selinux
else
INITRAMFS_UDEV_AUTOCONF	+= --without-selinux
endif

ifdef PTXCONF_INITRAMFS_UDEV_SYSLOG
INITRAMFS_UDEV_AUTOCONF	+= --enable-logging
else
INITRAMFS_UDEV_AUTOCONF	+= --disable-logging
endif

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/initramfs-udev.targetinstall:
	@$(call targetinfo)

#	#
#	# binaries
#	#
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /sbin/udevd);
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /sbin/udevadm);
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, /etc/udev);
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, /lib/udev);
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, /lib/udev/rules.d);
ifdef PTXCONF_INITRAMFS_UDEV_INSTALL_TEST_UDEV
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, $(INITRAMFS_UDEV_DIR)/udev/test-udev, \
		/sbin/test-udev);
endif

#	#
#	# default rules
#	#

# install everything apart of drivers rule.
ifdef PTXCONF_UDEV_DEFAULT_RULES
	@cd $(UDEV_DIR)/rules/rules.d; \
	for file in `find . -type f ! -name "*drivers*"`; do \
		$(call install_initramfs, initramfs-udev, 0, 0, 0644, \
			$(UDEV_DIR)/rules/rules.d/$$file, \
			/lib/udev/rules.d/$$file, n); \
	done
endif

# install drivers rules.
ifdef PTXCONF_UDEV_DEFAULT_DRIVERS_RULES
	@cd $(UDEV_DIR)/rules/rules.d; \
	for file in `find . -type f -name "*drivers*"`; do \
		$(call install_initramfs, initramfs-udev, 0, 0, 0644, \
			$(UDEV_DIR)/rules/rules.d/$$file, \
			/lib/udev/rules.d/$$file, n); \
	done
endif

# install default keymaps.
ifdef PTXCONF_UDEV_DEFAULT_KEYMAPS
	@cd $(UDEV_PKGDIR)/lib/udev/keymaps; \
	for file in `find . -type f`; do \
		$(call install_initramfs, initramfs-udev, 0, 0, 0644, \
			$(UDEV_PKGDIR)/lib/udev/keymaps/$$file, \
			/lib/udev/keymaps/$$file, n); \
	done
endif

ifdef PTXCONF_UDEV_COMMON_RULES
#
# these rules are not installed by default
#
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, \
		$(UDEV_DIR)/rules/packages/40-isdn.rules, \
		/lib/udev/rules.d/40-isdn.rules, n);
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, \
		$(UDEV_DIR)/rules/packages/40-zaptel.rules, \
		/lib/udev/rules.d/40-zaptel.rules, n);
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, \
		$(UDEV_DIR)/rules/packages/40-s390.rules, \
		/lib/udev/rules.d/40-s390.rules, n);
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, \
		$(UDEV_DIR)/rules/packages/40-pilot-links.rules, \
		/lib/udev/rules.d/40-pilot-links.rules, n);
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, \
		$(UDEV_DIR)/rules/packages/40-ppc.rules, \
		/lib/udev/rules.d/40-ppc.rules, n);
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, \
		$(UDEV_DIR)/rules/packages/40-infiniband.rules, \
		/lib/udev/rules.d/40-infiniband.rules, n);
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, \
		$(UDEV_DIR)/rules/packages/40-ia64.rules, \
		/lib/udev/rules.d/40-ia64.rules, n);
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, \
		$(UDEV_DIR)/rules/packages/64-device-mapper.rules, \
		/lib/udev/rules.d/64-device-mapper.rules, n);
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, \
		$(UDEV_DIR)/rules/packages/64-md-raid.rules, \
		/lib/udev/rules.d/64-md-raid.rules, n);
endif

ifdef PTXCONF_UDEV_CUST_RULES
	@if [ -d $(PTXDIST_WORKSPACE)/projectroot/lib/udev/rules.d/ ]; then \
		cd $(PTXDIST_WORKSPACE)/projectroot/lib/udev/rules.d/; \
		for file in `find . -type f`; do \
			$(call install_initramfs, initramfs-udev, 0, 0, 0644, \
				$(PTXDIST_WORKSPACE)/projectroot/lib/udev/rules.d/$$file, \
				/lib/udev/rules.d/$$file, n); \
		done; \
	else \
		echo "UDEV_CUST_RULES is enabled but Directory containing" \
			"customized udev rules is missing!"; \
		exit 1; \
	fi
endif

#	#
#	# startup script
#	#
ifdef PTXCONF_UDEV_STARTSCRIPT
ifdef PTXCONF_INITMETHOD_BBINIT
	@$(call install_initramfs_alt, initramfs-udev, 0, 0, 0755, /etc/init.d/udev)
endif
ifdef PTXCONF_INITMETHOD_UPSTART
	@$(call install_initramfs_alt, initramfs-udev, 0, 0, 0644, /etc/init/udev.conf)
	@$(call install_initramfs_alt, initramfs-udev, 0, 0, 0644, /etc/init/udevmonitor.conf)
	@$(call install_initramfs_alt, initramfs-udev, 0, 0, 0644, /etc/init/udevtrigger.conf)
	@$(call install_initramfs_alt, initramfs-udev, 0, 0, 0644, /etc/init/udev-finish.conf)
endif
endif


#	#
#	# Install a configuration on demand only
#	#
ifdef PTXCONF_UDEV_ETC_CONF
	@$(call install_initramfs_alt, initramfs-udev, 0, 0, 0644, /etc/udev/udev.conf)
endif

#	#
#	# utilities from extra/
#	#
ifdef PTXCONF_UDEV_EXTRA_ATA_ID
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /lib/udev/ata_id)
endif

ifdef PTXCONF_UDEV_EXTRA_CDROM_ID
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /lib/udev/cdrom_id)
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, -, \
		/lib/udev/rules.d/60-cdrom_id.rules,n)
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, -, \
		/lib/udev/rules.d/75-cd-aliases-generator.rules,n)
endif

ifdef PTXCONF_UDEV_EXTRA_COLLECT
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /lib/udev/collect)
endif

ifdef PTXCONF_UDEV_EXTRA_EDD_ID
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /lib/udev/edd_id)
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, -, \
		/lib/udev/rules.d/61-persistent-storage-edd.rules,n)
endif

ifdef PTXCONF_UDEV_EXTRA_FINDKEYBOARDS
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /lib/udev/findkeyboards)
endif

ifdef PTXCONF_UDEV_EXTRA_FIRMWARE
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /lib/udev/firmware)
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, -, \
		/lib/udev/rules.d/50-firmware.rules,n)
endif

ifdef PTXCONF_UDEV_EXTRA_FLOPPY
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, \
		/lib/udev/create_floppy_devices)
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, -, \
		/lib/udev/rules.d/60-floppy.rules)
endif

ifdef PTXCONF_UDEV_EXTRA_FSTAB_IMPORT
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /lib/udev/fstab_import)
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, -, \
		/lib/udev/rules.d/79-fstab_import.rules)
endif

ifndef PTXCONF_ARCH_ARM
ifdef PTXCONF_UDEV_EXTRA_HID2HCI
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /lib/udev/hid2hci)
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, -, \
		/lib/udev/rules.d/70-hid2hci.rules,n)
endif
endif

ifdef PTXCONF_UDEV_EXTRA_INPUT_ID
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /lib/udev/input_id)
endif

ifdef PTXCONF_UDEV_EXTRA_KEYBOARD_FORCE_RELEASE
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /lib/udev/keyboard-force-release.sh, n)
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, -, \
		/lib/udev/rules.d/95-keyboard-force-release.rules,n)
endif

ifdef PTXCONF_UDEV_EXTRA_KEYMAP
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /lib/udev/keymap)
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, -, \
		/lib/udev/rules.d/95-keymap.rules,n)
endif

ifdef PTXCONF_UDEV_EXTRA_MODEM_MODESWITCH
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /lib/udev/modem-modeswitch)
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, -, \
		/lib/udev/rules.d/61-option-modem-modeswitch.rules,n)
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, -, \
		/lib/udev/rules.d/61-mobile-action.rules,n)
endif

ifdef PTXCONF_UDEV_EXTRA_PATH_ID
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /lib/udev/path_id)
endif

ifdef PTXCONF_UDEV_EXTRA_PCI_DB
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /lib/udev/pci-db)
endif

ifdef PTXCONF_UDEV_EXTRA_RULE_GENERATOR
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, \
		/lib/udev/rule_generator.functions)
endif

ifdef PTXCONF_UDEV_EXTRA_SCSI_ID
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /lib/udev/scsi_id)
endif

ifdef PTXCONF_UDEV_EXTRA_UDEV_ACL
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /lib/udev/udev-acl)
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, -, \
		/lib/udev/rules.d/70-acl.rules,n)
	@$(call install_initramfs_link, initramfs-udev, ../../udev/udev-acl, \
		/lib/ConsoleKit/run-seat.d/udev-acl.ck)
endif

ifdef PTXCONF_UDEV_EXTRA_USB_DB
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /lib/udev/usb-db)
endif

ifdef PTXCONF_UDEV_EXTRA_USB_ID
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /lib/udev/usb_id)
endif

ifdef PTXCONF_UDEV_EXTRA_V4L_ID
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /lib/udev/v4l_id)
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, -, \
		/lib/udev/rules.d/60-persistent-v4l.rules,n)
endif

ifdef PTXCONF_UDEV_EXTRA_WRITE_CD_RULES
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /lib/udev//write_cd_rules)
endif

ifdef PTXCONF_UDEV_EXTRA_WRITE_NET_RULES
	@$(call install_initramfs, initramfs-udev, 0, 0, 0755, -, /lib/udev//write_net_rules)
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, -, \
		/lib/udev/rules.d/75-net-description.rules,n)
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, -, \
		/lib/udev/rules.d/75-persistent-net-generator.rules,n)
endif

ifdef PTXCONF_UDEV_LIBUDEV
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, -, /lib/libudev.so.0.6.0)
	@$(call install_initramfs_link, initramfs-udev, libudev.so.0.6.0, /lib/libudev.so.0)
	@$(call install_initramfs_link, initramfs-udev, libudev.so.0.6.0, /lib/libudev.so)
endif

ifdef PTXCONF_UDEV_LIBGUDEV
	@$(call install_initramfs, initramfs-udev, 0, 0, 0644, -, /lib/libgudev-1.0.so.0.0.1)
	@$(call install_initramfs_link, initramfs-udev, libgudev-1.0.so.0.0.1, /lib/libgudev-1.0.so.0)
	@$(call install_initramfs_link, initramfs-udev, libgudev-1.0.so.0.0.1, /lib/libgudev-1.0.so)
endif

	@$(call touch)

# vim: syntax=make