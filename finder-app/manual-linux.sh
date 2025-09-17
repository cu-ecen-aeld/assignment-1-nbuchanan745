#!/bin/bash
# Script outline to install and build kernel.
# Author: Siddhant Jajoo.
export PATH=/home/crosscompilertoolchain/arm-gnu-toolchain-13.3.rel1-x86_64-aarch64-none-linux-gnu/bin:$PATH


pwd

set -e
set -u

OUTDIR=/tmp/aeld
KERNEL_REPO=git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
KERNEL_VERSION=v5.15.163
BUSYBOX_VERSION=1_33_1
FINDER_APP_DIR=$(realpath $(dirname $0))
ARCH=arm64
CROSS_COMPILE=aarch64-none-linux-gnu-
SYSROOT=/home/crosscompilertoolchain/arm-gnu-toolchain-13.3.rel1-x86_64-aarch64-none-linux-gnu/bin/../aarch64-none-linux-gnu/libc

if [ $# -lt 1 ]
then
	echo "Using default directory ${OUTDIR} for output"
else
	OUTDIR=$1
	echo "Using passed directory ${OUTDIR} for output"
fi

mkdir -p ${OUTDIR}

cd "$OUTDIR"
#if [ ! -d "${OUTDIR}/linux-stable" ]; then
    #Clone only if the repository does not exist.
#	echo "CLONING GIT LINUX STABLE VERSION ${KERNEL_VERSION} IN ${OUTDIR}"
#	git clone ${KERNEL_REPO} --depth 1 --single-branch --branch ${KERNEL_VERSION}
#fi
#if [ ! -e ${OUTDIR}/linux-stable/arch/${ARCH}/boot/Image ]; then
#    cd linux-stable
#    echo "Checking out version ${KERNEL_VERSION}"
#    git checkout ${KERNEL_VERSION}

    # TODO: Add your kernel build steps here
#echo "ONE                                                                  11111111111111111111"
#	make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- mrproper

#echo "TWO                                                                  11111111111111111111"

#	make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- defconfig 

#echo "THREE                                                                  11111111111111111111"

#	make -j4 ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- all
#echo "FOUR                                                                  11111111111111111111"

#	make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- modules


#	make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- dtbs 
	
#	echo "FIVE                                                                  11111111111111111111"




fi

#echo "Adding the Image in outdir"

#cp -r ${OUTDIR}/linux-stable/arch/${ARCH}/boot/Image ${OUTDIR}

#echo "Creating the staging directory for the root filesystem"
#cd "$OUTDIR"
if [ -d "${OUTDIR}/rootfs" ]
then
	echo "Deleting rootfs directory at ${OUTDIR}/rootfs and starting over"
    sudo rm -rf ${OUTDIR}/rootfs
fi

# TODO: Create necessary base directories
#mkdir ${OUTDIR}/rootfs
#mkdir ${OUTDIR}/rootfs/bin
#mkdir ${OUTDIR}/rootfs/dev
#mkdir ${OUTDIR}/rootfs/etc
#mkdir ${OUTDIR}/rootfs/lib
#mkdir ${OUTDIR}/rootfs/lib64 
#mkdir ${OUTDIR}/rootfs/proc
#mkdir ${OUTDIR}/rootfs/sys
#mkdir ${OUTDIR}/rootfs/home
#mkdir ${OUTDIR}/rootfs/sbin
#mkdir ${OUTDIR}/rootfs/tmp
#mkdir ${OUTDIR}/rootfs/usr
#mkdir ${OUTDIR}/rootfs/usr/bin
#mkdir ${OUTDIR}/rootfs/usr/sbin
#mkdir ${OUTDIR}/rootfs/var
#mkdir ${OUTDIR}/rootfs/var/log




#cd "$OUTDIR"
#if [ ! -d "${OUTDIR}/busybox" ]
#then
#git clone git://busybox.net/busybox.git
#    cd busybox
#    git checkout ${BUSYBOX_VERSION}
    # TODO:  Configure busybox
	


#else
#    cd busybox
#fi

# TODO: Make and install busybox
#make distclean
#make defconfig
#make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}
#make CONFIG_PREFIX=${OUTDIR}/rootfs/ ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} install



#echo "Library dependencies"
#${CROSS_COMPILE}readelf -a bin/busybox | grep "program interpreter"
#${CROSS_COMPILE}readelf -a bin/busybox | grep "Shared library"

# TODO: Add library dependencies to rootfs
#pwd 
#echo "${SYSROOT}"
#echo "${OUTDIR}"
#cat ${SYSROOT}/lib/ld-linux-aarch64.so.1
#cp -a ${SYSROOT}/lib/ld-linux-aarch64.so.1 ${OUTDIR}/rootfs/lib
#cp -a ${SYSROOT}/lib64/libm.so.6 ${OUTDIR}/rootfs/lib64
#cp -a ${SYSROOT}/lib64/libresolv.so.2 ${OUTDIR}/rootfs/lib64
#cp -a ${SYSROOT}/lib64/libc.so.6 ${OUTDIR}/rootfs/lib64



# TODO: Make device nodes
#sudo mknod -m 666 ${OUTDIR}/rootfs/dev/null c 1 3
#sudo mknod -m 666 ${OUTDIR}/rootfs/dev/console c 5 1
# TODO: Clean and build the writer utility

#make clean

#make CROSS_COMPILE=${CROSS_COMPILE} 

# TODO: Copy the finder related scripts and executables to the /home directory
# on the target rootfs

#cp -r /home/nbuchanan/assignment-1-nbuchanan745/finder-app/ ${OUTDIR}/rootfs/home/

# TODO: Chown the root directory
#sudo chown -R root:root ${OUTDIR}/rootfs/*
# TODO: Create initramfs.cpio.gz
#cd ${OUTDIR}/rootfs/
#find . | cpio -H newc -ov --owner root:root > ${OUTDIR}/initramfs.cpio
#cd ..
#gzip -f initramfs.cpio
sudo chmod 777 ${OUTDIR} 
cp -r /tmp/aeld/. ${OUTDIR} 
