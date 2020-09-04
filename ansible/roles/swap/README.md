# Bootstrap Role

## About this role

Configure SWAP.

NOTE: A good SWAP size is half of the RAM size, but it can also be the same size (as physical RAM).

## Playbook example
```
- hosts: all
  become: yes
  roles:
  - swap
```

## Required vars example

```
swap_size: 4GiB
swapfile_full_path: "/swapfile"
```

## Dependencies
This roles depends on the time role.
