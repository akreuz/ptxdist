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
PACKAGES-$(PTXCONF_CLASSPATH) += classpath

ifdef PTXCONF_CLASSPATH
ifeq ($(shell test -x $(PTXCONF_SETUP_JAVA_SDK)/bin/javac || echo no),no)
    $(warning *** javac is mandatory to build classpath)
    $(warning *** please run 'ptxdist setup' and set the path to the java sdk)
    $(error )
endif
endif

#
# Paths and names
#
CLASSPATH_VERSION	:= 0.98
CLASSPATH		:= classpath-$(CLASSPATH_VERSION)
CLASSPATH_SUFFIX	:= tar.gz
CLASSPATH_URL		:= ftp://ftp.gnu.org/gnu/classpath/$(CLASSPATH).$(CLASSPATH_SUFFIX)
CLASSPATH_SOURCE	:= $(SRCDIR)/$(CLASSPATH).$(CLASSPATH_SUFFIX)
CLASSPATH_DIR		:= $(BUILDDIR)/$(CLASSPATH)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(CLASSPATH_SOURCE):
	@$(call targetinfo)
	@$(call get, CLASSPATH)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/classpath.extract:
	@$(call targetinfo)
	@$(call clean, $(CLASSPATH_DIR))
	@$(call extract, CLASSPATH)
	@$(call patchin, CLASSPATH)
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

CLASSPATH_PATH	:= PATH=$(CROSS_PATH)
CLASSPATH_ENV 	:= \
	$(CROSS_ENV) \
	JAVAC=$(PTXCONF_SETUP_JAVA_SDK)/bin/javac \
	JAVA=$(PTXCONF_SETUP_JAVA_SDK)/bin/java \
	CLASSPATH=$(PTXCONF_SETUP_JAVA_SDK)/jre/lib \
	ac_cv_prog_javac_is_gcj=no

#
# autoconf
#
CLASSPATH_AUTOCONF := \
	$(CROSS_AUTOCONF_USR) \
	--enable-option-checking \
	--disable-collections \
	--enable-jni \
	--enable-default-preferences-peer=file \
	--disable-gconf-peer \
	--disable-gstreamer-peer \
	--disable-Werror \
	--disable-xmlj \
	--disable-alsa \
	--disable-dependency-tracking \
	--disable-dssi \
	--disable-gtk-peer \
	--disable-qt-peer \
	--disable-plugin \
	--disable-gmp \
	--disable-gjdoc \
	--enable-regen-headers \
	--enable-regen-gjdoc-parser \
	--disable-tool-wrappers \
	--enable-static \
	--enable-shared \
	--disable-fast-install \
	--enable-libtool-lock \
	--disable-rpath \
	--disable-maintainer-mode \
	--disable-debug \
	--disable-load-library \
	--disable-java-lang-system-explicit-initialization \
	--disable-examples \
	--enable-tools \
	--enable-portable-native-sync \
	--disable-local-sockets \
	--with-gnu-ld \
	--with-pic \
	--without-x \
	--with-glibj=zip \
	--with-gjdoc=no

#
# FIXME:
#
# --enable-default-preferences-peer=<gconf|file|memory|FQCN>
# --enable-default-toolkit (?)
#   --with-native-libdir    sets the installation directory for native libraries
#                           default='${libdir}/${PACKAGE}'
#   --with-glibj-dir        sets the installation directory for glibj.zip
#                           default='${libdir}/${PACKAGE}'
#   --with-antlr-jar=file   Use ANTLR from the specified jar file
#   --with-tags[=TAGS]      include additional configurations [automatic]
#   --with-libiconv-prefix[=DIR]  search for libiconv in DIR/include and DIR/lib
#   --without-libiconv-prefix     don't search for libiconv in includedir and libdir
#   --with-javah            specify path or name of a javah-like program
#   --with-vm-classes       specify path to VM override source files
#   --with-ecj-jar=ABS.PATH specify jar file containing the Eclipse Java
#                           Compiler
#   --with-jar=PATH         define to use a jar style tool
#   --with-jay=DIR|PATH     Regenerate the parsers with jay
#   --with-glibj-zip=ABS.PATH
#                           use prebuilt glibj.zip class library
#   --with-escher=ABS.PATH  specify path to escher dir or JAR for X peers
#

$(STATEDIR)/classpath.prepare:
	@$(call targetinfo)
	@$(call clean, $(CLASSPATH_DIR)/config.cache)
	cd $(CLASSPATH_DIR) && \
		$(CLASSPATH_PATH) $(CLASSPATH_ENV) \
		./configure $(CLASSPATH_AUTOCONF)
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/classpath.compile:
	@$(call targetinfo)
	cd $(CLASSPATH_DIR) && $(CLASSPATH_PATH) $(MAKE) $(PARALLELMFLAGS)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/classpath.install:
	@$(call targetinfo)
	@$(call install, CLASSPATH)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/classpath.targetinstall:
	@$(call targetinfo)

	@$(call install_init, classpath)
	@$(call install_fixup, classpath,PACKAGE,classpath)
	@$(call install_fixup, classpath,PRIORITY,optional)
	@$(call install_fixup, classpath,VERSION,$(CLASSPATH_VERSION))
	@$(call install_fixup, classpath,SECTION,base)
	@$(call install_fixup, classpath,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, classpath,DEPENDS,)
	@$(call install_fixup, classpath,DESCRIPTION,missing)


	for i in \
		/usr/bin/grmid \
		/usr/bin/gjavah \
		/usr/bin/gtnameserv \
		/usr/bin/grmiregistry \
		/usr/bin/gjar \
		/usr/bin/gjarsigner \
		/usr/bin/grmic \
		/usr/bin/gnative2ascii \
		/usr/bin/gappletviewer \
		/usr/bin/gkeytool \
		/usr/bin/gserialver \
		/usr/bin/gorbd; \
	do \
		@$(call install_copy, classpath, 0, 0, 0755, -, $$i); \
	done

	@$(call install_copy, classpath, 0, 0, 0644, -, /usr/share/classpath/glibj.zip)
	@$(call install_copy, classpath, 0, 0, 0644, -, /usr/share/classpath/tools.zip)

	@$(call install_copy, classpath, 0, 0, 0644, -, /usr/lib/classpath/libjavautil.so.0.0.0)
	@$(call install_link, classpath, libjavautil.so.0.0.0, /usr/lib/classpath/libjavautil.so.0)
	@$(call install_link, classpath, libjavautil.so.0.0.0, /usr/lib/classpath/libjavautil.so)

	@$(call install_copy, classpath, 0, 0, 0644, -, /usr/lib/classpath/libjavalangmanagement.so.0.0.0)
	@$(call install_link, classpath, libjavalangmanagement.so.0.0.0, /usr/lib/classpath/libjavalangmanagement.so.0)
	@$(call install_link, classpath, libjavalangmanagement.so.0.0.0, /usr/lib/classpath/libjavalangmanagement.so)

	@$(call install_copy, classpath, 0, 0, 0644, -, /usr/lib/classpath/libjavaio.so.0.0.0)
	@$(call install_link, classpath, libjavaio.so.0.0.0, /usr/lib/classpath/libjavaio.so.0)
	@$(call install_link, classpath, libjavaio.so.0.0.0, /usr/lib/classpath/libjavaio.so)

	@$(call install_copy, classpath, 0, 0, 0644, -, /usr/lib/classpath/libjavalang.so.0.0.0)
	@$(call install_link, classpath, libjavalang.so.0.0.0, /usr/lib/classpath/libjavalang.so.0)
	@$(call install_link, classpath, libjavalang.so.0.0.0, /usr/lib/classpath/libjavalang.so)

	@$(call install_copy, classpath, 0, 0, 0644, -, /usr/lib/classpath/libjavanet.so.0.0.0)
	@$(call install_link, classpath, libjavanet.so.0.0.0, /usr/lib/classpath/libjavanet.so.0)
	@$(call install_link, classpath, libjavanet.so.0.0.0, /usr/lib/classpath/libjavanet.so)

	@$(call install_copy, classpath, 0, 0, 0644, -, /usr/lib/classpath/libjavalangreflect.so.0.0.0)
	@$(call install_link, classpath, libjavalangreflect.so.0.0.0, /usr/lib/classpath/libjavalangreflect.so.0)
	@$(call install_link, classpath, libjavalangreflect.so.0.0.0, /usr/lib/classpath/libjavalangreflect.so)

	@$(call install_copy, classpath, 0, 0, 0644, -, /usr/lib/classpath/libjavanio.so.0.0.0)
	@$(call install_link, classpath, libjavanio.so.0.0.0, /usr/lib/classpath/libjavanio.so.0)
	@$(call install_link, classpath, libjavanio.so.0.0.0, /usr/lib/classpath/libjavanio.so)

	@$(call install_copy, classpath, 0, 0, 0644, -, /usr/lib/security/classpath.security)
	@$(call install_copy, classpath, 0, 0, 0644, -, /usr/lib/logging.properties)

	@$(call install_finish, classpath)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

classpath_clean:
	rm -rf $(STATEDIR)/classpath.*
	rm -rf $(PKGDIR)/classpath_*
	rm -rf $(CLASSPATH_DIR)

# vim: syntax=make