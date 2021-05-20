#!/bin/bash

ROOT_FOLDER=$(dirname $(readlink -f "$0"))
UBOOT_PATH=$1

# Change path
cd $ROOT_FOLDER

# Create workspace
rm -rf build
mkdir build

# Fix blank padding
g12a/blx_fix.sh \
	g12a/bl30.bin \
	build/zero_tmp \
	build/bl30_zero.bin \
	g12a/bl301.bin \
	build/bl301_zero.bin \
	build/bl30_new.bin \
	bl30
g12a/blx_fix.sh \
	g12a/bl2.bin \
	build/zero_tmp \
	build/bl2_zero.bin \
	g12a/acs.bin \
	build/bl21_zero.bin \
	build/bl2_new.bin \
	bl2

# Encrypt
g12a/aml_encrypt_g12a --bl2sig --input build/bl2_new.bin --output build/bl2_new.bin.enc
g12a/aml_encrypt_g12a --bl30sig --input build/bl30_new.bin --output build/bl30_new.bin.g12a.enc --level v3
g12a/aml_encrypt_g12a --bl3sig --input build/bl30_new.bin.g12a.enc --output build/bl30_new.bin.enc --level v3 --type bl30
g12a/aml_encrypt_g12a --bl3sig --input g12a/bl31.img --output build/bl31.img.enc --level v3 --type bl31
g12a/aml_encrypt_g12a --bl3sig --input $UBOOT_PATH --compress lz4 --output build/bl33.bin.enc --level v3 --type bl33 --compress lz4

# Build
g12a/aml_encrypt_g12a --bootmk \
	--output build/u-boot.bin \
	--bl2 build/bl2_new.bin.enc \
	--bl30 build/bl30_new.bin.enc \
	--bl31 build/bl31.img.enc \
	--bl33 build/bl33.bin.enc \
	--ddrfw1 g12a/ddr4_1d.fw \
	--ddrfw2 g12a/ddr4_2d.fw \
	--ddrfw3 g12a/ddr3_1d.fw \
	--ddrfw4 g12a/piei.fw \
	--ddrfw5 g12a/lpddr4_1d.fw \
	--ddrfw6 g12a/lpddr4_2d.fw \
	--ddrfw7 g12a/diag_lpddr4.fw \
	--ddrfw8 g12a/aml_ddr.fw \
	--ddrfw9 g12a/lpddr3_1d.fw \
	--level v3

