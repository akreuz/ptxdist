# -*-makefile-*-
# $Id: template-make 9053 2008-11-03 10:58:48Z wsa $
#
# Copyright (C) 2009 by Robert Schwebel <r.schwebel@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBIODBC) += libiodbc

#
# Paths and names
#
LIBIODBC_VERSION	:= 3.52.5
LIBIODBC		:= libiodbc-$(LIBIODBC_VERSION)
LIBIODBC_SUFFIX		:= tar.gz
LIBIODBC_URL		:= $(PTXCONF_SETUP_SFMIRROR)/iodbc/$(LIBIODBC).$(LIBIODBC_SUFFIX)
LIBIODBC_SOURCE		:= $(SRCDIR)/$(LIBIODBC).$(LIBIODBC_SUFFIX)
LIBIODBC_DIR		:= $(BUILDDIR)/$(LIBIODBC)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(LIBIODBC_SOURCE):
#	@$(call targetinfo)
#	@$(call get, LIBIODBC)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

#$(STATEDIR)/libiodbc.extract:
#	@$(call targetinfo)
#	@$(call clean, $(LIBIODBC_DIR))
#	@$(call extract, LIBIODBC)
#	@$(call patchin, LIBIODBC)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

LIBIODBC_PATH	:= PATH=$(CROSS_PATH)
LIBIODBC_ENV 	:= $(CROSS_ENV)

#
# autoconf
#
LIBIODBC_AUTOCONF := \
	$(CROSS_AUTOCONF_USR) \
	--enable-libodbc \
	--disable-gtktest \
	--enable-pthreads

ifdef PTXCONF_LIBIODBC_GUI
LIBIODBC_AUTOCONF += --enable-gui
else
LIBIODBC_AUTOCONF += --disable-gui
endif

ifdef PTXCONF_LIBIODBC_DRIVER_VERSION_3
LIBIODBC_AUTOCONF += --enable-odbc3
else
LIBIODBC_AUTOCONF += --disable-odbc3
endif

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

#$(STATEDIR)/libiodbc.compile:
#	@$(call targetinfo)
#	cd $(LIBIODBC_DIR) && $(LIBIODBC_PATH) $(MAKE) $(PARALLELMFLAGS)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/libiodbc.install:
#	@$(call targetinfo)
#	@$(call install, LIBIODBC)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libiodbc.targetinstall:
	@$(call targetinfo)

	@$(call install_init,  libiodbc)
	@$(call install_fixup, libiodbc,PACKAGE,libiodbc)
	@$(call install_fixup, libiodbc,PRIORITY,optional)
	@$(call install_fixup, libiodbc,VERSION,$(LIBIODBC_VERSION))
	@$(call install_fixup, libiodbc,SECTION,base)
	@$(call install_fixup, libiodbc,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, libiodbc,DEPENDS,)
	@$(call install_fixup, libiodbc,DESCRIPTION,missing)

	@$(call install_copy, libiodbc, 0, 0, 0755, -, /usr/lib/libiodbc.so)
	@$(call install_copy, libiodbc, 0, 0, 0755, -, /usr/lib/libiodbcinst.so.2)

	@$(call install_finish, libiodbc)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

libiodbc_clean:
	rm -rf $(STATEDIR)/libiodbc.*
	rm -rf $(PKGDIR)/libiodbc_*
	rm -rf $(LIBIODBC_DIR)

# vim: syntax=make