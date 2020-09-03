# xrdp role

## About this role

This role enables a host to be accessible via Remote Desktop Protocol (Microsoft RDP).

It requires Ubuntu Desktop installed as well.

## Example playbok

``` yaml

- hosts: metals
  become: true
  roles:
  - xrdp
  vars:
    xrdp_audio: true

```

## Dependencies
This role has no dependencies.
