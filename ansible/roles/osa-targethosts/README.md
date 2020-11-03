# osa-targethosts role

## About this role

This role prepares a host for OpenStack Ansible to deploy OpenStack itself.

*NOTE: It does not run OpenStack Ansible for you.*

## Example playbok

``` yaml

- hosts: osa-targethosts
  become: true
  roles:
  - osa-targethosts

```

## Dependencies
This role has no dependencies.
