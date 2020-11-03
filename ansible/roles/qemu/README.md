# qemu role

## About this role

This role enables a host to run QEMU/KVM Virtual Machines (a.k.a., *Instances*). 


## Example playbok


``` yaml

- hosts: metals
  become: true
  roles:
  - qemu
  vars:
    mode: "desktop"
    default_user: "ubuntu"

```
## Vars

The following variables are required:
- mode: Can be either `server`for instalation of kvm basic packages or `desktop` for instalation of kvm plus GUI tools (e.g virt-manager). 
- default_user: the user which will have permission over qemu processes.


## Dependencies
This role has no dependencies.
