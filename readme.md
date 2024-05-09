# dotfiles

This is using [Chezmoi](https://chezmoi.io), the dotfile manager to setup the install and Ansible. 

## How to run

```shell
export GITHUB_USERNAME=Dooc-Nuken
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```
