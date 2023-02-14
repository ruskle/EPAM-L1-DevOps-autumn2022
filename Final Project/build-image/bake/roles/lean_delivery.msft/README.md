msft role
=========

[![License](https://img.shields.io/badge/license-Apache-green.svg?style=flat)](https://raw.githubusercontent.com/lean-delivery/ansible-role-msft/master/LICENSE)
[![build status](https://travis-ci.org/lean-delivery/ansible-role-msft.svg?branch=master)](https://travis-ci.org/lean-delivery/ansible-role-msft)
[![Build Status](https://gitlab.com/lean-delivery/ansible-role-msft/badges/master/pipeline.svg)](https://gitlab.com/lean-delivery/ansible-role-msft/pipelines)
[![Galaxy](https://img.shields.io/badge/galaxy-lean__delivery.msft-blue.svg)](https://galaxy.ansible.com/lean_delivery/msft)
![Ansible](https://img.shields.io/ansible/role/d/28987.svg)
![Ansible](https://img.shields.io/badge/dynamic/json.svg?label=min_ansible_version&url=https%3A%2F%2Fgalaxy.ansible.com%2Fapi%2Fv1%2Froles%2F28987%2F&query=$.min_ansible_version)

## Summary

This Ansible role has the following features:

 - Install Microsoft software collections

Requirements
------------

 - Version of the ansible for installation: >=2.7
 - **Supported OS**:  
   - EL
     - 7
   - Ubuntu
     - 18.04
   - Debian
     - stretch
   - Amazon Linux 2

## Role Variables


## Some examples of the installing current role

ansible-galaxy install lean_delivery.msft

Example Playbook
----------------

### Installing azure cli ans power shell to Ubuntu 18.04:
```yaml
- name: Converge
  hosts: all
  roles:
    - role: lean_delivery.msft
      msft_package:
        - powershell
        - azure-cli
```

### Installing msft to ubuntu 18.04:
```yaml
- name: Converge
  hosts: all
  roles:
    - role: lean_delivery.msft
```

License
-------

Apache

Author Information
------------------

authors:
  - Lean Delivery <team@lean-delivery.com>

Note
----
Microsoft®, Azure®, Windows®, Windows Vista®, and the Windows logo are registered trademarks of Microsoft Corporation in the United States and/or other countries.
