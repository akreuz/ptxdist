# -*-makefile-*-
# $Id: clementine.make,v 1.1 2003/08/21 07:29:21 robert Exp $
#
# (c) 2003 by Robert Schwebel <r.schwebel@pengutronix.de>
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXDIST project and license conditions
# see the README file.
#

#
# We provide this package
#
ifdef PTXCONF_CLEMENTINE
PACKAGES += clementine
endif

#
# Paths and names
#
CLEMENTINE_VERSION	= 0.0.7
CLEMENTINE		= clementine-$(CLEMENTINE_VERSION)
CLEMENTINE_SUFFIX	= tar.gz
CLEMENTINE_URL		= http://belnet.dl.sourceforge.net/sourceforge/clementine/$(CLEMENTINE).$(CLEMENTINE_SUFFIX)
CLEMENTINE_SOURCE	= $(SRCDIR)/$(CLEMENTINE).$(CLEMENTINE_SUFFIX)
CLEMENTINE_DIR		= $(BUILDDIR)/$(CLEMENTINE)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

clementine_get: $(STATEDIR)/clementine.get

clementine_get_deps	=  $(CLEMENTINE_SOURCE)

$(STATEDIR)/clementine.get: $(clementine_get_deps)
	@$(call targetinfo, clementine.get)
	touch $@

$(CLEMENTINE_SOURCE):
	@$(call targetinfo, $(CLEMENTINE_SOURCE))
	@$(call get, $(CLEMENTINE_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

clementine_extract: $(STATEDIR)/clementine.extract

clementine_extract_deps	=  $(STATEDIR)/clementine.get

$(STATEDIR)/clementine.extract: $(clementine_extract_deps)
	@$(call targetinfo, clementine.extract)
	@$(call clean, $(CLEMENTINE_DIR))
	@$(call extract, $(CLEMENTINE_SOURCE))
	touch $@

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

clementine_prepare: $(STATEDIR)/clementine.prepare

#
# dependencies
#
clementine_prepare_deps =  \
	$(STATEDIR)/clementine.extract \
	$(STATEDIR)/glib1210.install \
#	$(STATEDIR)/virtual-xchain.install

CLEMENTINE_PATH	=  PATH=$(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/bin:$(CROSS_PATH)
CLEMENTINE_ENV 	=  $(CROSS_ENV)

$(STATEDIR)/clementine.prepare: $(clementine_prepare_deps)
	@$(call targetinfo, clementine.prepare)
	@$(call clean, $(CLEMENTINE_BUILDDIR))
	touch $@

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

clementine_compile: $(STATEDIR)/clementine.compile

clementine_compile_deps =  $(STATEDIR)/clementine.prepare

$(STATEDIR)/clementine.compile: $(clementine_compile_deps)
	@$(call targetinfo, clementine.compile)
	$(CLEMENTINE_PATH) $(CLEMENTINE_ENV) make -C $(CLEMENTINE_DIR)
	touch $@

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

clementine_install: $(STATEDIR)/clementine.install

$(STATEDIR)/clementine.install: $(STATEDIR)/clementine.compile
	@$(call targetinfo, clementine.install)
	touch $@

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

clementine_targetinstall: $(STATEDIR)/clementine.targetinstall

clementine_targetinstall_deps	=  $(STATEDIR)/clementine.compile

$(STATEDIR)/clementine.targetinstall: $(clementine_targetinstall_deps)
	@$(call targetinfo, clementine.targetinstall)
	install -d $(ROOTDIR)/usr/X11R6/bin
	install $(CLEMENTINE_DIR)/clementine $(ROOTDIR)/usr/X11R6/bin/
	touch $@

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

clementine_clean:
	rm -rf $(STATEDIR)/clementine.*
	rm -rf $(CLEMENTINE_DIR)

# vim: syntax=make
