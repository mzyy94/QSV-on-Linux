#!/bin/bash

MSS_FILENAME="mediaserverstudioessentials2015r6.tar.gz"
MSS_MD5SUM="fd46847aa98bc1da001faab95a056b2e"
SDK_FILEPATH="MediaServerStudioEssentials2015R6/SDK2015Production16.4.2.1.tar.gz"
SDK_DIRNAME="SDK2015Production16.4.2.1/CentOS"
SCRIPT_ARCHIVE="install_scripts_centos_16.4.2.1-39163.tar.gz"
BUILD_SCRIPT="build_kernel_rpm_CentOS.sh"
INSTALL_SCRIPT="install_sdk_UMD_CentOS.sh"
SCRIPT_PATCH='
--- install_sdk_UMD_CentOS.sh	2015-06-18 20:53:50.000000000 +0900
+++ install_sdk_UMD_CentOS.sh	2015-12-20 13:36:27.000000000 +0900
@@ -13,6 +13,7 @@
 # install prerequisite packages
 yum -y -t groupinstall "Development Tools"
 yum -y -t install kernel-headers kernel-devel
+yum -y -t install mesa-dri-drivers redhat-lsb wget net-tools
 yum -y -t install bison ncurses-devel hmaccalc zlib-devel binutils-devel elfutils-libelf-devel rpm-build redhat-rpm-config asciidoc hmaccalc perl-ExtUtils-Embed pesign xmlto audit-libs-devel binutils-devel elfutils-devel elfutils-libelf-devel newt-devel numactl-devel pciutils-devel python-devel zlib-devel
 
 BUILD_ID=39163
@@ -20,6 +21,7 @@ MILESTONE_VER=16.4.2.1
 
 #install Media Server Studio packages
 rpm -Uvh \
+--oldpackage \
 libdrm-2.4.56-$BUILD_ID.el7.x86_64.rpm \
 libdrm-devel-2.4.56-$BUILD_ID.el7.x86_64.rpm \
 drm-utils-2.4.56-$BUILD_ID.el7.x86_64.rpm \
'

function info() {
    echo -e "\033[1m$@\033[0;39m"
}

function error() {
    echo -e "\033[1;31m$@\033[0;39m"
}

function success() {
    echo -e "\033[1;32m$@\033[0;39m"
}

function try_command
{
	eval "$@"
	if [ $? -ne 0 ]; then
		error "Error: failed to run sript. Quitting."
		exit 1
	fi
}

function run_command
{
	echo "> $@"
	try_command $@
}

info "Check MSS archive."
run_command "echo '${MSS_MD5SUM}  ${MSS_FILENAME}' | md5sum --quiet -c -"
success "done."

info "Extract archive."
run_command "tar -zxf ${MSS_FILENAME}"
run_command "tar -zxf ${SDK_FILEPATH}"
run_command "cd ${SDK_DIRNAME}"
run_command "tar -zxf ${SCRIPT_ARCHIVE}"
success "done."

info "Patch script."
run_command "sudo yum -y -t install patch"
try_command "patch -N <<< '${SCRIPT_PATCH}'"
success "done."

info "Run install script."
run_command "sudo ./${INSTALL_SCRIPT}"
success "done."

info "Update installed libraries' dependency"
run_command "echo '/opt/intel/mediasdk/lib64' | sudo tee -a /etc/ld.so.conf.d/intel-mediasdk.conf"
run_command "sudo ldconfig"
success "done."

info "Setup kernel build."
run_command "sudo mkdir /MSS"
run_command "sudo chown $(whoami): /MSS"
run_command "cp ${BUILD_SCRIPT} /MSS"
run_command "cd /MSS"
success "done."

info "Build kernel."
run_command "./${BUILD_SCRIPT}"
success "done."

info "Install kernel"
run_command "sudo rpm -Uvh --oldpackage ./rpmbuild/RPMS/x86_64/kernel-3.10.*.rpm"
success "done."

success "Now, reboot this machine."
