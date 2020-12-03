## keepalived role

This role sets up keepalived for an standard setup of:

  - One virtual IP
  - Two hosts

## Example playbook

``` yaml
- hosts: sqls
  become: true
  roles:
  - keepalived-mysql

  vars:
 ```

### Dependencies

This role depends on bootstrap role.
