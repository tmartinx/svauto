# downloads role

## About this role

This role downloads a wide range of O.S. Cloud and ISO Images to the host.

The `defaults/main.yml` contains all the supported images.


## Example playbok


``` yaml

- hosts: metals
  become: true
  roles:
  - downloads

```

## Dependencies
This role has no dependencies.
