#!/usr/bin/env bash

# We write this script because every RUN create a new layer
# and we dont really need multi-stage build.
# and docker squash is not stable

install_deps() {
    export LC_ALL=C.UTF-8
    export LANG=C.UTF-8
    # install python deps
    pip3 install --upgrade pip pipenv
    pipenv install --deploy --system

    # build speculos
    cmake -Bbuild -H. -DWITH_VNC=1
    make -C build/
}

install_ledgerblue() {
    pip3 install --upgrade protobuf setuptools ecdsa
    pip3 install wheel
    pip3 install ledgerblue
    pip3 install ledgerwallet
}

set -euxo pipefail

run_deps=$(cat <<EOF
qemu-user-static
libvncserver-dev
python3
python3-dev 
python3-venv 
python3-pip
nano 
wget
net-tools
EOF
)
build_deps=$(cat <<EOF
gcc-arm-linux-gnueabihf
libc6-dev-armhf-cross
gcc-arm-linux-gnueabihf
build-essential
git
cmake
EOF
)

ledger_deps=$(cat <<EOF
gcc-multilib 
libudev-dev 
libusb-1.0-0-dev
EOF
)

apt-get update
apt-get install -y ${run_deps} ${build_deps} 
apt-get autoremove -y
install_deps

# install ledgerblue
apt-get install -y ${ledger_deps}
apt-get autoremove -y
install_ledgerblue

# remove dev deps & builds tools
apt-get remove --purge ${build_deps} -y
apt-get clean
rm -rf -- /var/lib/apt/lists/*

# remove git history
rm -rf .git

exit 0
