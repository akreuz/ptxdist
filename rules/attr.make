# -*-makefile-*-
#
# Copyright (C) 2008 by Robert Schwebel
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_ATTR) += attr

#
# Paths and names
#
ATTR_VERSION	:= 2.4.44
ATTR_MD5	:= d132c119831c27350e10b9f885711adc
ATTR		:= attr-$(ATTR_VERSION)
ATTR_SUFFIX	:= tar.gz
ATTR_SOURCE	:= $(SRCDIR)/$(ATTR).src.$(ATTR_SUFFIX)
ATTR_DIR	:= $(BUILDDIR)/$(ATTR)

ATTR_URL	:= \
	http://download.savannah.gnu.org/releases/attr/$(ATTR).src.$(ATTR_SUFFIX) \
	http://mirrors.zerg.biz/nongnu/attr/$(ATTR).src.$(ATTR_SUFFIX)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(ATTR_SOURCE):
	@$(call targetinfo)
	@$(call get, ATTR)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

ATTR_PATH	:= PATH=$(CROSS_PATH)
ATTR_ENV 	:= $(CROSS_ENV)

ATTR_INSTALL_OPT := \
	DIST_ROOT=$(ATTR_PKGDIR) \
	install \
	install-lib \
	install-dev

#
# autoconf
#
ATTR_AUTOCONF := \
	$(CROSS_AUTOCONF_USR) \
	--libexecdir=/usr/lib

ifdef PTXCONF_ATTR_SHARED
ATTR_AUTOCONF += --enable-shared
else
ATTR_AUTOCONF += --disable-shared
endif

ifdef PTXCONF_ATTR_GETTEXT
ATTR_AUTOCONF += --enable-gettext
else
ATTR_AUTOCONF += --disable-gettext
endif

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/attr.targetinstall:
	@$(call targetinfo)

	@$(call install_init, attr)
	@$(call install_fixup, attr,PRIORITY,optional)
	@$(call install_fixup, attr,SECTION,base)
	@$(call install_fixup, attr,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, attr,DESCRIPTION,missing)

ifdef PTXCONF_ATTR_TOOLS
	@$(call install_copy, attr, 0, 0, 0755, -, /usr/bin/attr)
	@$(call install_copy, attr, 0, 0, 0755, -, /usr/bin/setfattr)
	@$(call install_copy, attr, 0, 0, 0755, -, /usr/bin/getfattr)
endif

ifdef PTXCONF_ATTR_SHARED
	@$(call install_lib, attr, 0, 0, 0644, libattr)
endif
	@$(call install_finish, attr)

	@$(call touch)

# vim: syntax=make
