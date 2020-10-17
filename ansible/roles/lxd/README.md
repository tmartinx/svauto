# lxd role

## About this role

This role configures a LXD host.

## Example playbok

This playbook will install and configure LXD in all hosts of the group `metals`.

``` yaml

- hosts: lxd
  become: true
  roles:
  - lxd
  vars:
    regular_system_user: "ubuntu"

```
## Vars

The following variables are required:
- regular_system_user: the user which will have permission over LXD processes.


## Dependencies
This role has no dependencies.
