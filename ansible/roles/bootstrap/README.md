# Bootstrap Role

## About this role

Bootstraps your Ubuntu or CentOS installations.

One of the most important roles that we need in our automation.

What does this role do?

- Bootstrap both Ubuntu or CentOS machines
- Fix Ubuntu Apt sources.list
- Install latest kernel and drivers do Ubuntu LTS (HWE)
- Enable the Ubuntu Cloud Archive Repo
- Configure sudo, so the admin can use it without the need to type password
- When required, install useful tools, aggrouped like “minimum tools”, “network tools”, “extra packages”, and a few more
- Supports ZRAM
- If desktop required, it’ll deploy one or more
- Configure htop
- Configure admin user’s groups
- Set the proper timezone (for now)
- Install QEmu Guest Agent when virt is detected
- Keeps the Machine up-to-date

It has similar sets of features between Ubuntu and CentOS.


## Playbook example
```
- hosts: all
  become: yes
  roles:
  - bootstrap

```

## Required vars example

```
# Upgrade Base OS: (apt full-upgrade)
base_os_upgrade: fasle

# Mode of host: e.g. server or desktop
# mode: desktop
# desktop_environments: [ 'ubuntu-desktop' ]

mode: "server"

network_tools: false
extra_packages: false
```

## Dependencies
This roles depends on the time role.
