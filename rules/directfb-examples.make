# -*-makefile-*-
# $Id: template 6655 2007-01-02 12:55:21Z rsc $
#
# Copyright (C) 2007-2008 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_DIRECTFB_EXAMPLES) += directfb-examples

#
# Paths and names
#
DIRECTFB_EXAMPLES_VERSION	:= 1.0.0
DIRECTFB_EXAMPLES		:= DirectFB-examples-$(DIRECTFB_EXAMPLES_VERSION)
DIRECTFB_EXAMPLES_SUFFIX	:= tar.gz
DIRECTFB_EXAMPLES_SOURCE	:= $(SRCDIR)/$(DIRECTFB_EXAMPLES).$(DIRECTFB_EXAMPLES_SUFFIX)
DIRECTFB_EXAMPLES_DIR		:= $(BUILDDIR)/$(DIRECTFB_EXAMPLES)

DIRECTFB_EXAMPLES_URL := \
	http://www.directfb.org/downloads/Extras/$(DIRECTFB_EXAMPLES).$(DIRECTFB_EXAMPLES_SUFFIX) \
	http://www.directfb.org/downloads/Old/$(DIRECTFB_EXAMPLES).$(DIRECTFB_EXAMPLES_SUFFIX)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(DIRECTFB_EXAMPLES_SOURCE):
	@$(call targetinfo)
	@$(call get, DIRECTFB_EXAMPLES)


# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

DIRECTFB_EXAMPLES_PATH	:= PATH=$(CROSS_PATH)
DIRECTFB_EXAMPLES_ENV 	:= $(CROSS_ENV)

#
# autoconf
#
DIRECTFB_EXAMPLES_AUTOCONF := $(CROSS_AUTOCONF_USR)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/directfb-examples.targetinstall:
	@$(call targetinfo)

	@$(call install_init, directfb-examples)
	@$(call install_fixup, directfb-examples,PACKAGE,directfb-examples)
	@$(call install_fixup, directfb-examples,PRIORITY,optional)
	@$(call install_fixup, directfb-examples,VERSION,$(DIRECTFB_EXAMPLES_VERSION))
	@$(call install_fixup, directfb-examples,SECTION,base)
	@$(call install_fixup, directfb-examples,AUTHOR,"Robert Schwebel <r.schwebel\@pengutronix.de>")
	@$(call install_fixup, directfb-examples,DEPENDS,)
	@$(call install_fixup, directfb-examples,DESCRIPTION,missing)

# installs the binaries
	@cd $(DIRECTFB_EXAMPLES_DIR)/src && \
	find . -perm /u+x -type f ! -name "*.[h|c]" | \
		while read file; do \
		$(call install_copy, directfb-examples, 0, 0, 0755, \
			$(DIRECTFB_EXAMPLES_DIR)/src/$$file, \
			/usr/bin/$${file##*/} \
		) \
	done

# install the datafiles
	@cd $(DIRECTFB_EXAMPLES_DIR)/data && \
	find . -type f -a ! -name "*akefile*" -a ! -name "*.ttf" | \
		while read file; do \
		$(call install_copy, directfb-examples, 0, 0, 0644, \
			$(DIRECTFB_EXAMPLES_DIR)/data/$$file, \
			/usr/share/directfb-examples/$${file##*/}, n \
		) \
	done; \

	find . -type f -a ! -name "*akefile*" -a -name "*.ttf" | \
		while read file; do \
		$(call install_copy, directfb-examples, 0, 0, 0644, \
			$(DIRECTFB_EXAMPLES_DIR)/data/$$file, \
			/usr/share/directfb-examples/fonts/$${file##*/}, n \
		) \
	done

	@$(call install_finish,directfb-examples)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

directfb-examples_clean:
	rm -rf $(STATEDIR)/directfb-examples.*
	rm -rf $(PKGDIR)/directfb-examples_*
	rm -rf $(DIRECTFB_EXAMPLES_DIR)

# vim: syntax=make
