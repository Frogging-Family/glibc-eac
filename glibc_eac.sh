  # Enable/disable each fix we offer
  _reenable_dt_hash="true"
  _rogue_company_fix="true"
  _disable_tests="true" # They are very playful and seem to fail randomly in different ways depending on the machine, so let's disable them by default - https://github.com/Frogging-Family/glibc-eac/issues/2
  _upstream_commit="" # 2.39-4 commit was 31da30f23cddd36db29d5b6a1c7619361b271fb4

  rm -rf ./glibc && git clone --depth=1 --single-branch -b main https://gitlab.archlinux.org/archlinux/packaging/packages/glibc.git
  cd ./glibc

  if [ "$_reenable_dt_hash" = "true" ]; then
    patch -Np1 -i ../inject_reenable_DT_HASH.patch && cp ../reenable_DT_HASH.patch ./
  fi

  if [ "$_rogue_company_fix" = "true" ]; then
    patch -Np1 -i ../inject_rogue_company_reverts.patch && cp ../rogue_company_reverts.patch ./
  fi

  if [ "$_disable_tests" = "true" ]; then
    patch -Np1 -i ../disable_tests.patch
  fi

  if [ -n "$_upstream_commit" ]; then
    sed -i "s/_commit=.*/_commit=$_upstream_commit/g" PKGBUILD
  fi

  if [ "$1" = "build" ]; then
    makepkg --noconfirm --skipinteg -sc
  else
    echo "############################################################################################"
    echo "! Defaulting to building then installing ! If you only want to build, run './glibc_eac.sh build'"
    echo "############################################################################################"
    read -rp "Press enter to continue or hit ctrl+c to leave"
    makepkg --noconfirm --skipinteg -sic
  fi
