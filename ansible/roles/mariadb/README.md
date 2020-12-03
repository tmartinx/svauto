# mariadb role

## About this role

This role configures a MariaDB deployment in a Master/Master HA scenario.

## Example playbok

This playbook will install and configure MariaDB in all hosts of the group `metals`.

``` yaml

- hosts: sqls
  become: true
  roles:
  - mariadb

```
## Vars

The following variables are required:

- server_id: int number to identify each server (1 or 2).
- master_ip: the IP of the other server (since Master/Master, one points to the other).


## Dependencies
This role has no dependencies.
