# -*-makefile-*-

# these are the defaults path definitions for xorg stuff
XORG_PREFIX  := /usr
XORG_LIBDIR  := $(XORG_PREFIX)/lib
XORG_FONTDIR := $(XORG_PREFIX)/share/fonts/X11
XORG_BINDIR  := /usr/bin

XORG_OPTIONS_TRANS	=
ifdef PTXCONF_XORG_OPTIONS_TRANS_UNIX
XORG_OPTIONS_TRANS	+= --enable-unix-transport
else
XORG_OPTIONS_TRANS	+= --disable-unix-transport
endif

ifdef PTXCONF_XORG_OPTIONS_TRANS_TCP
XORG_OPTIONS_TRANS	+= --enable-tcp-transport
else
XORG_OPTIONS_TRANS	+= --disable-tcp-transport
endif

XORG_OPTIONS_TRANS	+= $(GLOBAL_IPV6_OPTION)

# vim: syntax=make
