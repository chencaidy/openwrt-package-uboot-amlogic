#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_VERSION:=2021.07
PKG_RELEASE:=1

PKG_HASH:=312b7eeae44581d1362c3a3f02c28d806647756c82ba8c72241c7cdbe68ba77e

PKG_MAINTAINER:=Chen Caidy <chen@caidy.cc>

include $(INCLUDE_DIR)/u-boot.mk
include $(INCLUDE_DIR)/package.mk

define U-Boot/Default
  BUILD_TARGET:=amlogic
  UENV:=default
  HIDDEN:=1
endef

# GXL boards

define U-Boot/phicomm-n1
  BUILD_SUBTARGET:=gx
  NAME:=Phicomm N1
  BUILD_DEVICES:=phicomm_n1
endef

# SM1 boards

define U-Boot/amedia-x96
  BUILD_SUBTARGET:=sm1
  NAME:=AMedia X96
  BUILD_DEVICES:=amedia_x96air
  FIP_TYPE:=g12a
endef

UBOOT_TARGETS := \
	phicomm-n1 \
	amedia-x96

UBOOT_CONFIGURE_VARS += USE_PRIVATE_LIBGCC=yes

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)

ifneq ($(FIP_TYPE),)
	fip/mk_aml_uboot_$(FIP_TYPE).sh $(PKG_BUILD_DIR)/u-boot.bin
	$(CP) fip/build/u-boot.bin.sd.bin $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-u-boot.sd.bin
endif

	$(CP) $(PKG_BUILD_DIR)/u-boot.bin $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-u-boot.bin
endef

define Package/u-boot/install/default
endef

$(eval $(call BuildPackage/U-Boot))
