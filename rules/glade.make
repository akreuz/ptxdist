# -*-makefile-*-
#
# Copyright (C) 2007, 2009 by Marc Kleine-Buddde <mkl@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_GLADE) += glade

#
# Paths and names
#
GLADE_VERSION	:= 3.4.0
GLADE_MD5	:= 7d9354a92d3d95417d1e2d0bc3ebf4f5
GLADE		:= glade3-$(GLADE_VERSION)
GLADE_SUFFIX	:= tar.bz2
GLADE_URL	:= http://ftp.gnome.org/pub/GNOME/sources/glade3/3.4/$(GLADE).$(GLADE_SUFFIX)
GLADE_SOURCE	:= $(SRCDIR)/$(GLADE).$(GLADE_SUFFIX)
GLADE_DIR	:= $(BUILDDIR)/$(GLADE)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(GLADE_SOURCE):
	@$(call targetinfo)
	@$(call get, GLADE)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

GLADE_PATH	:= PATH=$(CROSS_PATH)
GLADE_ENV 	:= $(CROSS_ENV)

#
# autoconf
#
GLADE_AUTOCONF := \
	$(CROSS_AUTOCONF_USR) \
	--disable-gnome \
	--disable-scrollkeeper \
	--disable-python

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/glade.targetinstall:
	@$(call targetinfo)

	@$(call install_init, glade)
	@$(call install_fixup, glade,PRIORITY,optional)
	@$(call install_fixup, glade,SECTION,base)
	@$(call install_fixup, glade,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, glade,DESCRIPTION,missing)

	@$(call install_copy, glade, 0, 0, 0755, -, /usr/bin/glade-3)
	@$(call install_lib, glade, 0, 0, 0644, libgladeui-1)

	@$(call install_finish, glade)

	@$(call touch)

# vim: syntax=make
