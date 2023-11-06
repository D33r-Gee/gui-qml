#!/usr/bin/env bash
#
# Copyright (c) 2023-present The Bitcoin Core developers
# Distributed under the MIT software license, see the accompanying
# file COPYING or http://www.opensource.org/licenses/mit-license.php.

export LC_ALL=C.UTF-8

export CI_IMAGE_NAME_TAG="docker.io/ubuntu:23.10"  # This version will reach EOL in Jul 2024, and can be replaced by "ubuntu:24.04" (or anything else that ships the wanted clang version).
export CONTAINER_NAME=ci_native_tidy
<<<<<<< HEAD
export PACKAGES="clang-16 libclang-16-dev llvm-16-dev libomp-16-dev clang-tidy-16 jq bear cmake libevent-dev libboost-dev libminiupnpc-dev libnatpmp-dev libzmq3-dev systemtap-sdt-dev libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools qtdeclarative5-dev qtquickcontrols2-5-dev libqrencode-dev libsqlite3-dev libdb++-dev"
=======
export TIDY_LLVM_V="17"
export PACKAGES="clang-${TIDY_LLVM_V} libclang-${TIDY_LLVM_V}-dev llvm-${TIDY_LLVM_V}-dev libomp-${TIDY_LLVM_V}-dev clang-tidy-${TIDY_LLVM_V} jq bear cmake libevent-dev libboost-dev libminiupnpc-dev libnatpmp-dev libzmq3-dev systemtap-sdt-dev libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libqrencode-dev libsqlite3-dev libdb++-dev"
>>>>>>> sjors-bitcoin/2023/09/assume_mainnet
export NO_DEPENDS=1
export RUN_UNIT_TESTS=false
export RUN_FUNCTIONAL_TESTS=false
export RUN_FUZZ_TESTS=false
export RUN_TIDY=true
export GOAL="install"
export BITCOIN_CONFIG="CC=clang-${TIDY_LLVM_V} CXX=clang++-${TIDY_LLVM_V} --with-incompatible-bdb --disable-hardening CFLAGS='-O0 -g0' CXXFLAGS='-O0 -g0 -I/usr/lib/llvm-${TIDY_LLVM_V}/lib/clang/${TIDY_LLVM_V}/include'"
export CCACHE_MAXSIZE=200M