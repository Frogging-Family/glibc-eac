  # Enable/disable each fix we offer
  _rogue_company_fix="true"
  _disable_tests="true" # They are very playful and seem to fail randomly in different ways depending on the machine, so let's disable them by default - https://github.com/Frogging-Family/glibc-eac/issues/2
  _disable_debug="true" # Not needed for most users, speeds up compilation times

  rm -rf ./svntogit-packages && git clone --depth=1 --single-branch -b packages/glibc https://github.com/archlinux/svntogit-packages.git
  cd ./svntogit-packages

  if [ "$_rogue_company_fix" = "true" ]; then
    patch -Np1 -i ../inject_rogue_company_reverts.patch && cp ../rogue_company_reverts.patch ./trunk/
  fi

  if [ "$_disable_tests" = "true" ]; then
    patch -Np1 -i ../disable_tests.patch
  fi

  if [ "$_disable_debug" = "true" ]; then
    patch -Np1 -i ../disable_debug.patch
  fi

  cd ./trunk

  if [ "$1" = "build" ]; then
    makepkg --noconfirm -sc
  else
    echo "############################################################################################"
    echo "! Defaulting to building then installing ! If you only want to build, run './glibc_eac.sh build'"
    echo "############################################################################################"
    read -rp "Press enter to continue or hit ctrl+c to leave"
    makepkg --noconfirm -sic
  fi
