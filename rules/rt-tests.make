# -*-makefile-*-
# $Id: template-make 8785 2008-08-26 07:48:06Z wsa $
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
PACKAGES-$(PTXCONF_RT_TESTS) += rt-tests

#
# Paths and names
#
RT_TESTS_VERSION	:= v0.27
RT_TESTS		:= rt-tests-$(RT_TESTS_VERSION)
RT_TESTS_SUFFIX		:= tar.bz2
RT_TESTS_URL		:= http://www.pengutronix.de/software/rt-tests/download/$(RT_TESTS).$(RT_TESTS_SUFFIX)
RT_TESTS_SOURCE		:= $(SRCDIR)/$(RT_TESTS).$(RT_TESTS_SUFFIX)
RT_TESTS_DIR		:= $(BUILDDIR)/$(RT_TESTS)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(RT_TESTS_SOURCE):
	@$(call targetinfo)
	@$(call get, RT_TESTS)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/rt-tests.extract:
	@$(call targetinfo)
	@$(call clean, $(RT_TESTS_DIR))
	@$(call extract, RT_TESTS)
	@$(call patchin, RT_TESTS)
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

RT_TESTS_PATH	:= PATH=$(CROSS_PATH)
RT_TESTS_ENV 	:= $(CROSS_ENV)

$(STATEDIR)/rt-tests.prepare:
	@$(call targetinfo)
	@$(call clean, $(RT_TESTS_DIR)/config.cache)
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/rt-tests.compile:
	@$(call targetinfo)
	cd $(RT_TESTS_DIR) && $(RT_TESTS_PATH) $(MAKE) $(PARALLELMFLAGS) CC=$(CROSS_CC)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/rt-tests.install:
	@$(call targetinfo)
	@$(call install, RT_TESTS)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/rt-tests.targetinstall:
	@$(call targetinfo)

	@$(call install_init, rt-tests)
	@$(call install_fixup, rt-tests,PACKAGE,rt-tests)
	@$(call install_fixup, rt-tests,PRIORITY,optional)
	@$(call install_fixup, rt-tests,VERSION,$(RT_TESTS_VERSION))
	@$(call install_fixup, rt-tests,SECTION,base)
	@$(call install_fixup, rt-tests,AUTHOR,"Robert Schwebel <your@email.please>")
	@$(call install_fixup, rt-tests,DEPENDS,)
	@$(call install_fixup, rt-tests,DESCRIPTION,missing)

ifdef PTXCONF_RT_TESTS_CYCLICTEST
	@$(call install_copy, rt-tests, 0, 0, 0755, $(RT_TESTS_DIR)/cyclictest, /usr/bin/cyclictest)
endif
ifdef PTXCONF_RT_TESTS_SIGNALTEST
	@$(call install_copy, rt-tests, 0, 0, 0755, $(RT_TESTS_DIR)/cyclictest, /usr/bin/signaltest)
endif
ifdef PTXCONF_RT_TESTS_CLASSICPI
	@$(call install_copy, rt-tests, 0, 0, 0755, $(RT_TESTS_DIR)/cyclictest, /usr/bin/classic_pi)
endif
ifdef PTXCONF_RT_TESTS_PI_STRESS
	@$(call install_copy, rt-tests, 0, 0, 0755, $(RT_TESTS_DIR)/cyclictest, /usr/bin/pi_stress)
endif

	@$(call install_finish, rt-tests)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

rt-tests_clean:
	rm -rf $(STATEDIR)/rt-tests.*
	rm -rf $(PKGDIR)/rt-tests_*
	rm -rf $(RT_TESTS_DIR)

# vim: syntax=make
