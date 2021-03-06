# -*-makefile-*-
#
# Copyright (C) 2009 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
LAZY_PACKAGES-$(PTXCONF_HOST_AUTOTOOLS_AUTOCONF) += host-autotools-autoconf

#
# Paths and names
#
HOST_AUTOTOOLS_AUTOCONF_VERSION	:= 2.67
HOST_AUTOTOOLS_AUTOCONF_MD5	:= 3fbf92eb8eaca1e0d33dff9710edb5f0
HOST_AUTOTOOLS_AUTOCONF		:= autoconf-$(HOST_AUTOTOOLS_AUTOCONF_VERSION)
HOST_AUTOTOOLS_AUTOCONF_SUFFIX	:= tar.bz2
HOST_AUTOTOOLS_AUTOCONF_URL	:= $(PTXCONF_SETUP_GNUMIRROR)/autoconf/$(HOST_AUTOTOOLS_AUTOCONF).$(HOST_AUTOTOOLS_AUTOCONF_SUFFIX)
HOST_AUTOTOOLS_AUTOCONF_SOURCE	:= $(SRCDIR)/$(HOST_AUTOTOOLS_AUTOCONF).$(HOST_AUTOTOOLS_AUTOCONF_SUFFIX)
HOST_AUTOTOOLS_AUTOCONF_DIR	:= $(HOST_BUILDDIR)/$(HOST_AUTOTOOLS_AUTOCONF)
HOST_AUTOTOOLS_AUTOCONF_DEVPKG	:= NO

$(STATEDIR)/autogen-tools: $(STATEDIR)/host-autotools-autoconf.install.post

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(HOST_AUTOTOOLS_AUTOCONF_SOURCE):
	@$(call targetinfo)
	@$(call get, HOST_AUTOTOOLS_AUTOCONF)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
HOST_AUTOTOOLS_AUTOCONF_CONF_TOOL	:= autoconf

# vim: syntax=make
