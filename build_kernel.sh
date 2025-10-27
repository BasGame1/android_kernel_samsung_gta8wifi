#!/bin/bash

KERNEL_DIR=$(pwd)
CLANG_DIR="${KERNEL_DIR}/toolchain/clang-r416183b"
GCC_64_DIR="${KERNEL_DIR}/toolchain/gcc-aarch64"
GCC_32_DIR="${KERNEL_DIR}/toolchain/gcc-arm"

export PATH="${CLANG_DIR}/bin:${PATH}"

export BSP_BUILD_FAMILY=qogirl6
export DTC_OVERLAY_TEST_EXT=$(pwd)/tools/mkdtimg/ufdt_apply_overlay
export DTC_OVERLAY_VTS_EXT=$(pwd)/tools/mkdtimg/ufdt_verify_overlay_host
export BSP_BUILD_ANDROID_OS=y

MAKE_FLAGS="O=out \
            ARCH=arm64 \
            CC=clang \
            LD=ld.lld \
            CLANG_TRIPLE=aarch64-linux-gnu- \
            CROSS_COMPILE=aarch64-linux-gnu- \
            CROSS_COMPILE_ARM32=arm-linux-androideabi- \
            GCC_TOOLCHAIN=${GCC_64_DIR} \
            GCC_TOOLCHAIN_ARM32=${GCC_32_DIR} \
            BSP_BUILD_DT_OVERLAY=y"

make -C ${KERNEL_DIR} ${MAKE_FLAGS} clean
make -C ${KERNEL_DIR} ${MAKE_FLAGS} mrproper

make -C ${KERNEL_DIR} ${MAKE_FLAGS} gta8wifi_eur_open_defconfig

make -C ${KERNEL_DIR} ${MAKE_FLAGS} -j$(nproc)

echo "Build finished. Copying Image..."
cp out/arch/arm64/boot/Image arch/arm64/boot/Image
echo "Done."
