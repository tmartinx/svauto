# instances role

## About this role

Spin up Instances on both LXD and QEMU Hypervisors.

## Example Playbook

``` yaml
- hosts: metals
  become: yes
  roles:
  - instances
    setup: 'instances'
    when: instances is defined
  vars:
    ssh_pub_key: "$YOUR_SSH_PUBLIC_KEY_HERE"
    metal_deployment.default_user: ubuntu
```

### Virtual machine definition example
``` yaml

# The 

instances:

- name: lxd-instance-1
  type: lxd
  state: started
  profiles: default
  distro: focal
  devices: {}
  config_drive:
    user_data:
      system_info:
        default_user:
          name: "{{ metal_deployment.default_user }}"
      chpasswd:
        list: |
          root:{{ metal_deployment.default_user }}
          {{ metal_deployment.default_user }}:{{ metal_deployment.default_user }}
        expire: False
      ssh_pwauth: True
      ssh_authorized_keys:
      - "{{ ssh_pub_key }}"
      packages:
      - python
      runcmd:
      - "echo test > /tmp/test"
    network_config:
      version: 2
      ethernets:
        eth0:
          mtu: 1500
          dhcpv4: true


- name: libvirt-instance-1
  title: libvirt-instance-1.region-1
  description: "Instance Description"
  type: libvirt
  state: started
  autostart: true
  memory: 2048
  hugepages: true
  cpu:
    sockets: 1
    cores: 2
    threads: 1
  numa:
    node: 0
    cpus: "0-1"
  libvirt_pool: local
  devices:
    disks:
    - name: 5bf822cb-2f24-44d5-865f-136d7ff3f3bc
      size: 8
      source: /srv/cloud/ubuntu-20.04-server-cloudimg-amd64.img
      driver:
        type: qcow2
        compressed: true
        clone_cp: true
      target: sda
      unit: 0
      boot:
        order: 1
    # Raw device
    - name: 4ef822cb-2f24-44d5-865f-136d7ff3f3bc
      source: /dev/sdc
      target: sdc
      driver:
        type: raw
      unit: 1
    - name: f040077b-b93c-40f9-8cd2-778329c4b0f4
      size: 8
      driver:
        type: qcow2
      target: sdb
      unit: 1
    cdroms:
    - name: 7579bcde-52f8-43cb-b9a7-12e31ef5ed81
      unit: 0
    interfaces:
    - source:
        type: "bridge"
        bridge: "br-oobm"
        slot: 3
    - source:
        type: "bridge"
        bridge: "br-bond0"
        slot: 4
      backend: "openvswitch"
      csum_off: true
    - source:
        type: "vhostuser"
        slot: 5
      queues: 2
  config_drive:
    meta_data:
      instance-id: libvirt-instance-1
      local-hostname: libvirt-instance-1
    user_data:
      #cloud-config
      system_info:
        default_user:
          name: "{{ metal_deployment.default_user }}"
      chpasswd:
        list: |
          root:{{ metal_deployment.default_user }}
          {{ metal_deployment.default_user }}:{{ metal_deployment.default_user }}
        expire: False
      ssh_pwauth: True
      ssh_authorized_keys:
      - "{{ ssh_pub_key }}"
      packages:
      - python-is-python3
      runcmd:
      - "echo test > /tmp/test"
    network_config:
      version: 2
      ethernets:
        ens3:
          mtu: 1500
          dhcpv4: true
        ens4:
          mtu: 1500
        ens5:
          mtu: 1500
```

## Dependencies
This rule depends on qemu and lxd.
