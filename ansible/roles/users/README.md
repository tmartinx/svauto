# Users role

## About this role

Create and add user keys to a host.

## Playbook Example

``` yaml

- hosts: all
  become: true
  vars:
    users:
      - name: John Doe
        username: jdoe
        key: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCUHFAAAARJsd4FS35GAAAAV
  roles:
    - role: users

```

You can also run the playbook with the `-e` option pointing to an external user file.

## Testing
After running the playbook, ssh to the host:
```ssh host@jdoe```

No password is required.

## Dependencies
No roles dependencies.
