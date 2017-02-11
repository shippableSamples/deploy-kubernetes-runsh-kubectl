#! /bin/bash

# install linux tools
install_ShellTools() {
  echo -n "installing Linux tools..."

  # toggle DISTRO based on environment used
  # DISTRO=alpine
  DISTRO=ubuntu

  # adjust for distro and export variables via .bash_profile for new shells
  if [ $DISTRO == ubuntu ]; then
    export TOOL="sudo apt-get"
    export INSTALL_CMD="apt-get install"
  elif [ $DISTRO == alpine ]; then
    export TOOL="apk"
    export INSTALL_CMD="apk add"
  else
    echo "Linux distro not supported"
  fi

  # update the package index and install tools
  $TOOL update
  $INSTALL_CMD gettext curl sudo bash jq
  echo "Linux tools installed successfully"
}
