# -*-makefile-*-
# $Id$
#
# Copyright (C) 2006 by Robert Schwebel
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_UTIL_LINUX) += util-linux

#
# Paths and names
#
UTIL_LINUX_VERSION	:= 2.13-pre7
UTIL_LINUX		:= util-linux-$(UTIL_LINUX_VERSION)
UTIL_LINUX_SUFFIX	:= tar.bz2
UTIL_LINUX_URL		:= http://www.kernel.org/pub/linux/utils/util-linux/testing/$(UTIL_LINUX).$(UTIL_LINUX_SUFFIX)
UTIL_LINUX_SOURCE	:= $(SRCDIR)/$(UTIL_LINUX).$(UTIL_LINUX_SUFFIX)
UTIL_LINUX_DIR		:= $(BUILDDIR)/$(UTIL_LINUX)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(UTIL_LINUX_SOURCE):
	@$(call targetinfo)
	@$(call get, UTIL_LINUX)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

UTIL_LINUX_PATH	:= PATH=$(CROSS_PATH)
UTIL_LINUX_ENV 	:= \
	$(CROSS_ENV) \
	ac_cv_lib_termcap_tgetnum=no \
	ac_cv_lib_z_crc32=no

#
# autoconf
#
UTIL_LINUX_AUTOCONF := \
	$(CROSS_AUTOCONF_USR) \

ifndef PTXCONF_UTIL_LINUX_NCURSES
UTIL_LINUX_ENV += $(CROSS_ENV_AC_NO_NCURSES)
endif


# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/util-linux.targetinstall:
	@$(call targetinfo)

	@$(call install_init, util-linux)
	@$(call install_fixup,util-linux,PACKAGE,util-linux)
	@$(call install_fixup,util-linux,PRIORITY,optional)
	@$(call install_fixup,util-linux,VERSION,$(UTIL_LINUX_VERSION))
	@$(call install_fixup,util-linux,SECTION,base)
	@$(call install_fixup,util-linux,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup,util-linux,DEPENDS,)
	@$(call install_fixup,util-linux,DESCRIPTION,missing)

# FIXME (rsc):
#
# - add more utilities, for example schedutils
# - audit for autodetected things (i.e. ionice)

ifdef PTXCONF_UTIL_LINUX_MKSWAP
	@$(call install_copy, util-linux, 0, 0, 0755, $(UTIL_LINUX_DIR)/disk-utils/mkswap, /sbin/mkswap)
endif
ifdef PTXCONF_UTIL_LINUX_SWAPON
	@$(call install_copy, util-linux, 0, 0, 0755, $(UTIL_LINUX_DIR)/mount/swapon, /sbin/swapon)
endif
ifdef PTXCONF_UTIL_LINUX_MOUNT
	@$(call install_copy, util-linux, 0, 0, 0755, $(UTIL_LINUX_DIR)/mount/mount, /bin/mount)
endif
ifdef PTXCONF_UTIL_LINUX_UMOUNT
	@$(call install_copy, util-linux, 0, 0, 0755, $(UTIL_LINUX_DIR)/mount/umount, /bin/umount)
endif
ifdef PTXCONF_UTIL_LINUX_IPCS
	@$(call install_copy, util-linux, 0, 0, 0755, $(UTIL_LINUX_DIR)/sys-utils/ipcs, /usr/bin/ipcs)
endif
ifdef PTXCONF_UTIL_LINUX_READPROFILE
	@$(call install_copy, util-linux, 0, 0, 0755, $(UTIL_LINUX_DIR)/sys-utils/readprofile, /usr/sbin/readprofile)
endif
ifdef PTXCONF_UTIL_LINUX_FDISK
	@$(call install_copy, util-linux, 0, 0, 0755, $(UTIL_LINUX_DIR)/fdisk/fdisk, /usr/sbin/fdisk)
endif
ifdef PTXCONF_UTIL_LINUX_SFDISK
	@$(call install_copy, util-linux, 0, 0, 0755, $(UTIL_LINUX_DIR)/fdisk/sfdisk, /usr/sbin/sfdisk)
endif
ifdef PTXCONF_UTIL_LINUX_CFDISK
	@$(call install_copy, util-linux, 0, 0, 0755, $(UTIL_LINUX_DIR)/fdisk/cfdisk, /usr/sbin/cfdisk)
endif
ifdef PTXCONF_UTIL_LINUX_SETTERM
	@$(call install_copy, util-linux, 0, 0, 0755, $(UTIL_LINUX_DIR)/misc-utils/setterm, /usr/bin/setterm)
endif

	@$(call install_finish,util-linux)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

util-linux_clean:
	rm -rf $(STATEDIR)/util-linux.*
	rm -rf $(PKGDIR)/util-linux_*
	rm -rf $(UTIL_LINUX_DIR)

# vim: syntax=make
