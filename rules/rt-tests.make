# -*-makefile-*-
#
# Copyright (C) 2008 by Robert Schwebel
#               2009 by Marc Kleine-Budde <mkl@pengutronix.de>
#               2009 by Wolfram Sang <w.sang@pengutronix.de>
#               2011 by Michael Olbrich <m.olbrich@pengutronix.de>
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
RT_TESTS_VERSION	:= 0.73
RT_TESTS_MD5		:= 98da46135f0a91c96cb7e5b27c7e3bb6
RT_TESTS_LICENSE	:= GPLv2, GPLv2+
RT_TESTS		:= rt-tests-$(RT_TESTS_VERSION)
RT_TESTS_SUFFIX		:= tar.bz2
RT_TESTS_URL		:= http://www.kernel.org/pub/linux/kernel/people/clrkwllms/rt-tests/$(RT_TESTS).$(RT_TESTS_SUFFIX)
RT_TESTS_SOURCE		:= $(SRCDIR)/$(RT_TESTS).$(RT_TESTS_SUFFIX)
RT_TESTS_DIR		:= $(BUILDDIR)/$(RT_TESTS)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

RT_TESTS_CONF_TOOL	:= NO
RT_TESTS_MAKE_OPT	:= $(CROSS_ENV_CC) prefix=/usr
RT_TESTS_INSTALL_OPT	:= $(RT_TESTS_MAKE_OPT) install

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

RT_TESTS_BIN-$(PTXCONF_RT_TESTS_CYCLICTEST)		+= cyclictest
RT_TESTS_BIN-$(PTXCONF_RT_TESTS_HACKBENCH)		+= hackbench
RT_TESTS_BIN-$(PTXCONF_RT_TESTS_PIP)			+= pip_stress
RT_TESTS_BIN-$(PTXCONF_RT_TESTS_PI_STRESS)		+= pi_stress
RT_TESTS_BIN-$(PTXCONF_RT_TESTS_PMQTEST)		+= pmqtest
RT_TESTS_BIN-$(PTXCONF_RT_TESTS_PTSEMATEST)		+= ptsematest
RT_TESTS_BIN-$(PTXCONF_RT_TESTS_RT_MIGRATE_TEST)	+= rt-migrate-test
RT_TESTS_BIN-$(PTXCONF_RT_TESTS_SENDME)			+= sendme
RT_TESTS_BIN-$(PTXCONF_RT_TESTS_SIGNALTEST)		+= signaltest
RT_TESTS_BIN-$(PTXCONF_RT_TESTS_SIGWAITTEST)		+= sigwaittest
RT_TESTS_BIN-$(PTXCONF_RT_TESTS_SVSEMATEST)		+= svsematest


$(STATEDIR)/rt-tests.targetinstall:
	@$(call targetinfo)

	@$(call install_init, rt-tests)
	@$(call install_fixup, rt-tests,PRIORITY,optional)
	@$(call install_fixup, rt-tests,SECTION,base)
	@$(call install_fixup, rt-tests,AUTHOR,"Robert Schwebel")
	@$(call install_fixup, rt-tests,DESCRIPTION,missing)

	@$(foreach tool, $(RT_TESTS_BIN-y), \
		$(call install_copy, rt-tests, 0, 0, 0755, -, \
		/usr/bin/$(tool));)

	@$(call install_finish, rt-tests)

	@$(call touch)

# vim: syntax=make

