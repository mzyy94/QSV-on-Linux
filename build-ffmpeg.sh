#!/bin/bash

LIBMFX_PCFILE="libmfx.pc"

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


info "Clone FFmpeg and yasm."
run_command "git submodule init"
run_command "git submodule update --depth 1"
success "done."

info "Copy pkg-config file."
run_command "cp ${LIBMFX_PCFILE} /usr/lib64/pkgconfig/"
success "done."

info "Symlink include headers"
run_command "sudo ln -s /opt/intel/mediasdk/include /usr/local/include/mfx"
success "done."

info "Configure and build yasm."
run_command "cd yasm"
run_command "autoreconf -fiv"
run_command "./configure"
run_command "make"
run_command "sudo make install"
run_command "cd -"
success "done."

info "Configure and build FFmpeg."
run_command "cd FFmpeg"
run_command "./configure --enable-nonfree --enable-libmfx"
run_command "make"
run_command "sudo make install"
run_command "cd -"
success "done."

