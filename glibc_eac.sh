#!/usr/bin/env bash

# Enable/disable each fix we offer
: ${_reenable_dt_hash=true}
: ${_rogue_company_fix=false}
: ${_disable_tests=true} # random fails on different machines
: ${_upstream_commit=}   # 2.40+r16+gaa533d58ff = aa533d58ff12e27771d9c960a727d74992a3f2a3

rm -rf ./glibc && git clone --depth=1 --single-branch -b main https://gitlab.archlinux.org/archlinux/packaging/packages/glibc.git
cd ./glibc

if [[ "${_reenable_dt_hash::1}" =~ t|y|1 ]]; then
  echo "::: Fixing DT_HASH..."
  cat >> PKGBUILD << 'END'
export LDFLAGS+=" -Wl,--hash-style=both"
END
fi

if [[ "${_rogue_company_fix::1}" =~ t|y|1 ]]; then
  echo "::: Fixing Rogue Company..."
  cp ../rogue_company_reverts.patch ./
  cat >> PKGBUILD << 'END'
source+=('rogue_company_reverts.patch')
b2sums+=('SKIP')

eval _orig_"$(declare -f prepare)"
prepare() {
  (_orig_prepare)

  cd glibc
  # Reverts for Rogue Company to work again
  # 7a5db2e82fbb6c3a6e3fdae02b7166c5d0e8c7a8
  # 8208be389bce84be0e1c35a3daa0c3467418f921
  # 6bf789d69e6be48419094ca98f064e00297a27d5
  # b89d5de2508215ef3131db7bed76ac50b3f4c205
  # 86f0179bc003ffc34ffaa8d528a7a90153ac06c6
  patch -Np1 -F100 -i "../rogue_company_reverts.patch"
}
END
fi

# https://github.com/Frogging-Family/glibc-eac/issues/2
if [[ "${_disable_tests::1}" =~ t|y|1 ]]; then
  echo "::: Disabling unit tests..."
  cat >> PKGBUILD << 'END'
unset checkdepends
unset -f check
END
fi

if [ -n "$_upstream_commit" ]; then
  echo -n "::: Using commit: $_upstream_commit"
  sed -i "s/_commit=.*/_commit=$_upstream_commit/g" PKGBUILD
fi

case "$1" in
  unattended)
    echo "::: Building in unattended mode..."
    makepkg --noconfirm --skipinteg -sc
    ;;
  build)
    echo "::: Build only.  If you want to build and install, re-run without options."
    read -rp "Press enter to continue or hit ctrl+c to leave"
    makepkg --noconfirm --skipinteg -sc
    ;;
  *)
    echo "::: Build and install.  If you want to build only, run: './glibc_eac.sh build'"
    read -rp "Press enter to continue or hit ctrl+c to leave"
    makepkg --noconfirm --skipinteg -sic
    ;;
esac
