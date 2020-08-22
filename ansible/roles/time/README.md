# Time Role

## About this role

Configures your Ubuntu or CentOS time settings (both timezone and NTP daemon).

It has similar sets of features between Ubuntu and CentOS.

## Playbook example
```
- hosts: all
  become: yes
  roles:
    - time

```

## Required vars example

```
# Local Timezone of the related Machine
local_timezone: "America/Toronto"
```

## Dependencies
No dependencies
