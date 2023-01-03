################################################################################
#
# libdeflate
#
################################################################################

LIBDEFLATE_VERSION = 1.15
LIBDEFLATE_SITE = $(call github,ebiggers,libdeflate,v$(LIBDEFLATE_VERSION))
LIBDEFLATE_LICENSE = MIT
LIBDEFLATE_LICENSE_FILES = COPYING
LIBDEFLATE_INSTALL_STAGING = YES
LIBDEFLATE_CONF_OPTS = \
	-DCMAKE_C_FLAGS="$(TARGET_CFLAGS) -D_DEFAULT_SOURCE"

$(eval $(cmake-package))
