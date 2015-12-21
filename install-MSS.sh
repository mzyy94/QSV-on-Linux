#!/bin/bash

MSS_FILENAME="mediaserverstudioessentials2015r6.tar.gz"
SDK_FILEPATH="MediaServerStudioEssentials2015R6/SDK2015Production16.4.2.1.tar.gz"
SDK_DIRNAME="SDK2015Production16.4.2.1/CentOS"
SCRIPT_ARCHIVE="install_scripts_centos_16.4.2.1-39163.tar.gz"
BUILD_SCRIPT="build_kernel_rpm_CentOS.sh"
INSTALL_SCRIPT="install_sdk_UMD_CentOS.sh"

function info() {
    echo -e "\033[1m$@\033[0;39m"
}

function error() {
    echo -e "\033[1;31m$@\033[0;39m"
}

function success() {
    echo -e "\033[1;32m$@\033[0;39m"
}

function run_command
{
	echo "> $@"
	eval "$@"
	if [ $? -ne 0 ]; then
		error "Error: failed to run sript. Quitting."
		exit 1
	fi
}


info "Check MSS archive."
run_command "md5sum --quiet -c ${MSS_FILENAME}.md5"
success "done."

info "Extract archive."
run_command "tar -zxf ${MSS_FILENAME}"
run_command "tar -zxf ${SDK_FILEPATH}"
run_command "cd ${SDK_DIRNAME}"
run_command "tar -zxf ${SCRIPT_ARCHIVE}"
success "done."

info "Patch script."
run_command "which patch || sudo yum -y -t install patch"
run_command "patch -N < ${INSTALL_SCRIPT}.patch"
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
