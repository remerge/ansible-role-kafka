# ansible-bigtop-kafka

an ansible role to install and configure kafka-server on rhel/centos 7

## sample playbook
```yml
- hosts: all
  remote_user: vagrant

  pre_tasks:
    - name: install java-11-openjdk
      ansible.builtin.yum:
        name: java-11-openjdk
        state: present
  roles:
    - name: ansible-bigtop-kafka
      zookeeper_hosts: "
        {%- set ips = [] %}
        {%- for host in groups['zookeeper'] %}
        {{- ips.append(dict(id=loop.index, host=host, ip=hostvars[host]['ansible_default_ipv4'].address)) }}
        {%- endfor %}
        {{- ips -}}"
```
