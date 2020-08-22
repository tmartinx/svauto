# Python Role

## About this role

Install Python and required dependencies for both Ubuntu and CentOS distributions.

## Playbook example
```
- hosts: all
  become: yes
  roles:
  - python

```

## Dependencies
This roles depends on the time role.
