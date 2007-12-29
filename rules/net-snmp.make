# -*-makefile-*-
# $Id: net-snmp.make$
#
# Copyright (C) 2006 by Randall Loomis <rloomis@solectek.com>
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_NET_SNMP) += net-snmp

#
# Paths and names
#
NET_SNMP_VERSION	= 5.3.1
NET_SNMP		= net-snmp-$(NET_SNMP_VERSION)
NET_SNMP_SUFFIX		= tar.gz
NET_SNMP_URL		= $(PTXCONF_SETUP_SFMIRROR)/net-snmp/$(NET_SNMP).$(NET_SNMP_SUFFIX)
NET_SNMP_SOURCE		= $(SRCDIR)/$(NET_SNMP).$(NET_SNMP_SUFFIX)
NET_SNMP_DIR		= $(BUILDDIR)/$(NET_SNMP)


# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

net-snmp_get: $(STATEDIR)/net-snmp.get

$(STATEDIR)/net-snmp.get: $(net-snmp_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(NET_SNMP_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, NET_SNMP)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

net-snmp_extract: $(STATEDIR)/net-snmp.extract

$(STATEDIR)/net-snmp.extract: $(net-snmp_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(NET_SNMP_DIR))
	@$(call extract, NET_SNMP)
	@$(call patchin, NET_SNMP)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

net-snmp_prepare: $(STATEDIR)/net-snmp.prepare

NET_SNMP_PATH	=  PATH=$(CROSS_PATH)
NET_SNMP_ENV 	=  $(CROSS_ENV)

#
# autoconf
#
NET_SNMP_AUTOCONF	=  $(CROSS_AUTOCONF_USR)

# don't prompt for anything that's not explicitly set below
NET_SNMP_AUTOCONF	+= --with-defaults

# we don't need no stinking manuals
NET_SNMP_AUTOCONF	+= --disable-manuals

# FIXME rsc: should be well known in PTXdist, but isn't currently?
ifdef PTXCONF_NET_SNMP_LITTLE_ENDIAN
NET_SNMP_AUTOCONF	+= --with-endianness=little
else
NET_SNMP_AUTOCONF	+= --with-endianness=big
endif

ifdef PTXCONF_NET_SNMP_MINI_AGENT
NET_SNMP_AUTOCONF	+= --enable-mini-agent
else
NET_SNMP_AUTOCONF	+= --disable-mini-agent
endif

ifdef PTXCONF_NET_SNMP_AGENT
NET_SNMP_AUTOCONF	+= --enable-agent
else
NET_SNMP_AUTOCONF	+= --disable-agent
endif

ifdef PTXCONF_NET_SNMP_APPLICATIONS
NET_SNMP_AUTOCONF	+= --enable-applications
else
NET_SNMP_AUTOCONF	+= --disable-applications
endif

ifdef PTXCONF_NET_SNMP_SCRIPTS
NET_SNMP_AUTOCONF	+= --enable-scripts
else
NET_SNMP_AUTOCONF	+= --disable-scripts
endif

ifdef PTXCONF_NET_SNMP_MIBS
NET_SNMP_AUTOCONF	+= --enable-mibs
else
NET_SNMP_AUTOCONF	+= --disable-mibs
endif

ifdef PTXCONF_NET_SNMP_MIB_LOADING
NET_SNMP_AUTOCONF	+= --enable-mib-loading
else
NET_SNMP_AUTOCONF	+= --disable-mib-loading
endif

ifdef PTXCONF_NET_SNMP_SNMPV1
NET_SNMP_AUTOCONF	+= --enable-snmpv1
else
NET_SNMP_AUTOCONF	+= --disable-snmpv1
endif

ifdef PTXCONF_NET_SNMP_SNMPV2C
NET_SNMP_AUTOCONF	+= --enable-snmpv2c
else
NET_SNMP_AUTOCONF	+= --disable-snmpv2c
endif

ifdef PTXCONF_NET_SNMP_DES
NET_SNMP_AUTOCONF	+= --enable-des
else
NET_SNMP_AUTOCONF	+= --disable-des
endif

ifdef PTXCONF_NET_SNMP_MD5
NET_SNMP_AUTOCONF	+= --enable-md5
else
NET_SNMP_AUTOCONF	+= --disable-md5
endif

ifdef PTXCONF_NET_SNMP_SNMPTRAPD
NET_SNMP_AUTOCONF	+= --enable-snmptrapd-subagent
else
NET_SNMP_AUTOCONF	+= --disable-snmptrapd-subagent
endif

ifdef PTXCONF_NET_SNMP_IPV6
NET_SNMP_AUTOCONF	+= --enable-ipv6
else
NET_SNMP_AUTOCONF	+= --disable-ipv6
endif

ifdef PTXCONF_NET_SNMP_LOCAL_SMUX
NET_SNMP_AUTOCONF	+= --enable-local-smux
else
NET_SNMP_AUTOCONF	+= --disable-local-smux
endif

ifdef PTXCONF_NET_SNMP_DEBUGGING
NET_SNMP_AUTOCONF	+= --enable-debugging
else
NET_SNMP_AUTOCONF	+= --disable-debugging
endif

ifdef PTXCONF_NET_SNMP_DEVELOPER
NET_SNMP_AUTOCONF	+= --enable-developer
else
NET_SNMP_AUTOCONF	+= --disable-developer
endif

ifdef PTXCONF_NET_SNMP_PRIVACY
NET_SNMP_AUTOCONF	+= --enable-privacy
else
NET_SNMP_AUTOCONF	+= --disable-privacy
endif

ifdef PTXCONF_NET_SNMP_INTERNAL_MD5
NET_SNMP_AUTOCONF	+= --enable-internal-md5
else
NET_SNMP_AUTOCONF	+= --disable-internal-md5
endif

ifdef PTXCONF_NET_SNMP_AGENTX_DOM_SOCK_ONLY
NET_SNMP_AUTOCONF	+= --enable-agentx-dom-sock-only
else
NET_SNMP_AUTOCONF	+= --disable-agentx-dom-sock-only
endif

ifdef PTXCONF_NET_SNMP_MIB_CONFIG_CHECKING
NET_SNMP_AUTOCONF	+= --enable-mib-config-checking
else
NET_SNMP_AUTOCONF	+= --disable-mib-config-checking
endif

ifdef PTXCONF_NET_SNMP_MFD_REWRITES
NET_SNMP_AUTOCONF	+= --enable-mfd-rewrites
else
NET_SNMP_AUTOCONF	+= --disable-mfd-rewrites
endif

ifdef PTXCONF_NET_SNMP_TESTING_CODE
NET_SNMP_AUTOCONF	+= --enable-testing-code
else
NET_SNMP_AUTOCONF	+= --disable-testing-code
endif

ifdef PTXCONF_NET_SNMP_REENTRANT
NET_SNMP_AUTOCONF	+= --enable-reentrant
else
NET_SNMP_AUTOCONF	+= --disable-reentrant
endif

ifdef PTXCONF_NET_SNMP_EMBEDDED_PERL
NET_SNMP_AUTOCONF	+= --enable-embedded-perl
else
NET_SNMP_AUTOCONF	+= --disable-embedded-perl
endif

ifdef PTXCONF_NET_SNMP_UCD_COMPAT
NET_SNMP_AUTOCONF	+= --enable-ucd-snmp-compatibility
else
NET_SNMP_AUTOCONF	+= --disable-ucd-snmp-compatibility
endif

NET_SNMP_AUTOCONF	+= --with-mib-modules=$(PTXCONF_NET_SNMP_MIB_MODULES)
NET_SNMP_AUTOCONF	+= --with-mibs=$(PTXCONF_NET_SNMP_DEFAULT_MIBS)

NET_SNMP_AUTOCONF	+= --with-logfile=$(call remove_quotes,$(PTXCONF_NET_SNMP_LOGFILE))
NET_SNMP_AUTOCONF	+= --with-persistent-directory=$(call remove_quotes,$(PTXCONF_NET_SNMP_PERSISTENT_DIR))

NET_SNMP_AUTOCONF	+= --with-default-snmp-version=$(call remove_quotes,$(PTXCONF_NET_SNMP_DEFAULT_VERSION))
NET_SNMP_AUTOCONF	+= --enable-shared
NET_SNMP_AUTOCONF	+= --disable-static

##NET_SNMP_AUTOCONF	+= --with-mib-modules=mibII
##NET_SNMP_AUTOCONF	+= --with-sys-contact=root@localhost
##NET_SNMP_AUTOCONF	+= --with-sys-location=unknown

$(STATEDIR)/net-snmp.prepare: $(net-snmp_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(NET_SNMP_DIR)/config.cache)
	cd $(NET_SNMP_DIR) && \
		$(NET_SNMP_PATH) $(NET_SNMP_ENV) \
		./configure $(NET_SNMP_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

net-snmp_compile: $(STATEDIR)/net-snmp.compile

$(STATEDIR)/net-snmp.compile: $(net-snmp_compile_deps_default)
	@$(call targetinfo, $@)
	$(NET_SNMP_PATH) make -C $(NET_SNMP_DIR) $(NET_SNMP_MAKEVARS)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

net-snmp_install: $(STATEDIR)/net-snmp.install

$(STATEDIR)/net-snmp.install: $(net-snmp_install_deps_default)
	@$(call targetinfo, $@)
	@$(call install, NET_SNMP)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

net-snmp_targetinstall:	$(STATEDIR)/net-snmp.targetinstall

NET_SNMP_LIBMAJOR = 10
NET_SNMP_LIBMINOR = 0.1
NET_SNMP_LIBVER=$(NET_SNMP_LIBMAJOR).$(NET_SNMP_LIBMINOR)

NET_SNMP_V1MIBS = RFC1155-SMI.txt RFC1213-MIB.txt RFC-1215.txt

NET_SNMP_V2MIBS = SNMPv2-CONF.txt SNMPv2-SMI.txt SNMPv2-TC.txt SNMPv2-TM.txt SNMPv2-MIB.txt

NET_SNMP_V3MIBS = SNMP-FRAMEWORK-MIB.txt SNMP-MPD-MIB.txt SNMP-TARGET-MIB.txt \
			SNMP-NOTIFICATION-MIB.txt SNMP-PROXY-MIB.txt \
			SNMP-USER-BASED-SM-MIB.txt SNMP-VIEW-BASED-ACM-MIB.txt \
			SNMP-COMMUNITY-MIB.txt TRANSPORT-ADDRESS-MIB.txt

NET_SNMP_AGENTMIBS = AGENTX-MIB.txt SMUX-MIB.txt

NET_SNMP_IANAMIBS = IANAifType-MIB.txt IANA-LANGUAGE-MIB.txt \
			IANA-ADDRESS-FAMILY-NUMBERS-MIB.txt

NET_SNMP_RFCMIBS = IF-MIB.txt IF-INVERTED-STACK-MIB.txt \
			EtherLike-MIB.txt \
			IP-MIB.txt IP-FORWARD-MIB.txt IANA-RTPROTO-MIB.txt \
			TCP-MIB.txt UDP-MIB.txt \
			INET-ADDRESS-MIB.txt HCNUM-TC.txt \
			HOST-RESOURCES-MIB.txt HOST-RESOURCES-TYPES.txt \
			RMON-MIB.txt \
			IPV6-TC.txt IPV6-MIB.txt IPV6-ICMP-MIB.txt IPV6-TCP-MIB.txt \
			IPV6-UDP-MIB.txt \
			DISMAN-EVENT-MIB.txt DISMAN-SCRIPT-MIB.txt DISMAN-SCHEDULE-MIB.txt \
			NOTIFICATION-LOG-MIB.txt SNMP-USM-AES-MIB.txt \
			SNMP-USM-DH-OBJECTS-MIB.txt

NET_SNMP_NETSNMPMIBS = NET-SNMP-TC.txt NET-SNMP-MIB.txt NET-SNMP-AGENT-MIB.txt \
			NET-SNMP-EXAMPLES-MIB.txt NET-SNMP-EXTEND-MIB.txt

NET_SNMP_UCDMIBS = UCD-SNMP-MIB.txt UCD-DEMO-MIB.txt UCD-IPFWACC-MIB.txt \
			UCD-DLMOD-MIB.txt UCD-DISKIO-MIB.txt

## FIXME:  for now, you need to manually edit this list to represent what mibs to install on target.
NET_SNMP_MIBS = $(NET_SNMP_V1MIBS) $(NET_SNMP_V2MIBS) $(NET_SNMP_V3MIBS) \
	$(NET_SNMP_AGENTMIBS) $(NET_SNMP_IANAMIBS) $(NET_SNMP_RFCMIBS) $(NET_SNMP_NETSNMPMIBS) $(NET_SNNP_UCDMIBS)

$(STATEDIR)/net-snmp.targetinstall:	$(net-snmp_targetinstall_deps_default)
	@$(call targetinfo, $@)

	@$(call install_init, net-snmp)
	@$(call install_fixup, net-snmp,PACKAGE,net-snmp)
	@$(call install_fixup, net-snmp,PRIORITY,optional)
	@$(call install_fixup, net-snmp,VERSION,$(NET_SNMP_VERSION))
	@$(call install_fixup, net-snmp,SECTION,base)
	@$(call install_fixup, net-snmp,AUTHOR,"Randall Loomis <rloomis\@solectek.com>")
	@$(call install_fixup, net-snmp,DEPENDS,)
	@$(call install_fixup, net-snmp,DESCRIPTION,missing)

ifdef PTXCONF_NET_SNMP_AGENT
	@$(call install_copy, net-snmp, 0, 0, 0644, \
		$(NET_SNMP_DIR)/agent/.libs/libnetsnmpagent.so.$(NET_SNMP_LIBVER), \
		/usr/lib/libnetsnmpagent.so.$(NET_SNMP_LIBVER))
	@$(call install_link, net-snmp, libnetsnmpagent.so.$(NET_SNMP_LIBVER), \
		/usr/lib/libnetsnmpagent.so.$(NET_SNMP_LIBMAJOR))
	@$(call install_link, net-snmp, libnetsnmpagent.so.$(NET_SNMP_LIBVER), \
		/usr/lib/libnetsnmpagent.so)

# agent mib libs
	@$(call install_copy, net-snmp, 0, 0, 0644, \
		$(NET_SNMP_DIR)/agent/.libs/libnetsnmpmibs.so.$(NET_SNMP_LIBVER), \
		/usr/lib/libnetsnmpmibs.so.$(NET_SNMP_LIBVER))
	@$(call install_link, net-snmp, libnetsnmpmibs.so.$(NET_SNMP_LIBVER), \
		/usr/lib/libnetsnmpmibs.so.$(NET_SNMP_LIBMAJOR))
	@$(call install_link, net-snmp, libnetsnmpmibs.so.$(NET_SNMP_LIBVER), \
		/usr/lib/libnetsnmpmibs.so)

# agent binary
	@$(call install_copy, net-snmp, 0, 0, 0755, $(NET_SNMP_DIR)/agent/.libs/snmpd, \
		/usr/sbin/snmpd)

# agent helper libs
	@$(call install_copy, net-snmp, 0, 0, 0644, \
		$(NET_SNMP_DIR)/agent/helpers/.libs/libnetsnmphelpers.so.$(NET_SNMP_LIBVER), \
		/usr/lib/libnetsnmphelpers.so.$(NET_SNMP_LIBVER))
	@$(call install_link, net-snmp, libnetsnmphelpers.so.$(NET_SNMP_LIBVER), \
		/usr/lib/libnetsnmphelpers.so.$(NET_SNMP_LIBMAJOR))
	@$(call install_link, net-snmp, libnetsnmphelpers.so.$(NET_SNMP_LIBVER), \
		/usr/lib/libnetsnmphelpers.so)
endif

ifdef PTXCONF_NET_SNMP_APPLICATIONS
# apps libs
	@$(call install_copy, net-snmp, 0, 0, 0644, \
		$(NET_SNMP_DIR)/apps/.libs/libnetsnmptrapd.so.$(NET_SNMP_LIBVER), \
		/usr/lib/libnetsnmptrapd.so.$(NET_SNMP_LIBVER))
	@$(call install_link, net-snmp, libnetsnmptrapd.so.$(NET_SNMP_LIBVER), \
		/usr/lib/libnetsnmptrapd.so.$(NET_SNMP_LIBMAJOR))
	@$(call install_link, net-snmp, libnetsnmptrapd.so.$(NET_SNMP_LIBVER), \
		/usr/lib/libnetsnmptrapd.so)

# apps binaries
##ifdef PTXCONF_NET_SNMP_MINI_AGENT
##	@$(call install_copy, net-snmp, 0, 0, 0755, $(NET_SNMP_DIR)/apps/.libs/lt-snmpget, /usr/bin/lt-snmpget)
##	@$(call install_copy, net-snmp, 0, 0, 0755, $(NET_SNMP_DIR)/apps/.libs/lt-snmpwalk, /usr/bin/lt-snmpwalk)
##endif
	@$(call install_copy, net-snmp, 0, 0, 0755, $(NET_SNMP_DIR)/apps/.libs/snmpbulkget, /usr/bin/snmpbulkget)
	@$(call install_copy, net-snmp, 0, 0, 0755, $(NET_SNMP_DIR)/apps/.libs/snmpbulkwalk, /usr/bin/snmpbulkwalk)
	@$(call install_copy, net-snmp, 0, 0, 0755, $(NET_SNMP_DIR)/apps/.libs/snmpdelta, /usr/bin/snmpdelta)
	@$(call install_copy, net-snmp, 0, 0, 0755, $(NET_SNMP_DIR)/apps/.libs/snmpdf, /usr/bin/snmpdf)
	@$(call install_copy, net-snmp, 0, 0, 0755, $(NET_SNMP_DIR)/apps/.libs/snmpget, /usr/bin/snmpget)
	@$(call install_copy, net-snmp, 0, 0, 0755, $(NET_SNMP_DIR)/apps/.libs/snmpgetnext, /usr/bin/snmpgetnext)
	@$(call install_copy, net-snmp, 0, 0, 0755, $(NET_SNMP_DIR)/apps/.libs/snmpset, /usr/bin/snmpset)
	@$(call install_copy, net-snmp, 0, 0, 0755, $(NET_SNMP_DIR)/apps/.libs/snmpstatus, /usr/bin/snmpstatus)
	@$(call install_copy, net-snmp, 0, 0, 0755, $(NET_SNMP_DIR)/apps/.libs/snmptable, /usr/bin/snmptable)
	@$(call install_copy, net-snmp, 0, 0, 0755, $(NET_SNMP_DIR)/apps/.libs/snmptest, /usr/bin/snmptest)
	@$(call install_copy, net-snmp, 0, 0, 0755, $(NET_SNMP_DIR)/apps/.libs/snmptranslate, /usr/bin/snmptranslate)
	@$(call install_copy, net-snmp, 0, 0, 0755, $(NET_SNMP_DIR)/apps/.libs/snmptrap, /usr/bin/snmptrap)
	@$(call install_copy, net-snmp, 0, 0, 0755, $(NET_SNMP_DIR)/apps/.libs/snmptrapd, /usr/bin/snmptrapd)
	@$(call install_copy, net-snmp, 0, 0, 0755, $(NET_SNMP_DIR)/apps/.libs/snmpusm, /usr/bin/snmpusm)
	@$(call install_copy, net-snmp, 0, 0, 0755, $(NET_SNMP_DIR)/apps/.libs/snmpvacm, /usr/bin/snmpvacm)
	@$(call install_copy, net-snmp, 0, 0, 0755, $(NET_SNMP_DIR)/apps/.libs/snmpwalk, /usr/bin/snmpwalk)

# apps snmpstat
	@$(call install_copy, net-snmp, 0, 0, 0755, $(NET_SNMP_DIR)/apps/snmpnetstat/.libs/snmpnetstat, /usr/bin/snmpnetstat)

endif

# snmplib
	@$(call install_copy, net-snmp, 0, 0, 0644, \
		$(NET_SNMP_DIR)/snmplib/.libs/libnetsnmp.so.$(NET_SNMP_LIBVER), \
		/usr/lib/libnetsnmp.so.$(NET_SNMP_LIBVER))
	@$(call install_link, net-snmp, libnetsnmp.so.$(NET_SNMP_LIBVER), \
		/usr/lib/libnetsnmp.so.$(NET_SNMP_LIBMAJOR))
	@$(call install_link, net-snmp, libnetsnmp.so.$(NET_SNMP_LIBVER), \
		/usr/lib/libnetsnmp.so)

# MIB files <TODO: install specified set of mib files>
ifdef PTXCONF_NET_SNMP_MIBS

	@for i in $(NET_SNMP_MIBS) ; do \
		$(call install_copy, net-snmp, 0, 0, 0644, \
		$(NET_SNMP_DIR)/mibs/$$i, \
		$(call remove_quotes,$(PTXCONF_NET_SNMP_MIB_INSTALL_DIR))/$$i, n) ; \
	done
endif

	@$(call install_finish, net-snmp)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

net-snmp_clean:
	rm -rf $(STATEDIR)/net-snmp.*
	rm -rf $(NET_SNMP_DIR)

# vim: syntax=make
