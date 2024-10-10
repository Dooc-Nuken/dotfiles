#!/bin/bash

install_on_arch() {
  sudo pacman -Syu
  sudo pacman -S ansible
}

OS="$(uname -s)"

case "${OS}" in
    Linux*)
        if [ -f /etc/arch-release ]; then
            echo "Install on arch"
            install_on_arch
        else
            echo "Unsupported Linux distribution"
            exit 1
        fi
        ;;
esac

ansible-playbook -i ~/.bootstrap/inventory ~/.bootstrap/main.yml --ask-become-pass
echo "Ansible installation complete."
