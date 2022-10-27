# Ansible Role for Kafka

Install and configure Kafka with Ansible

The [Contributing Guide](CONTRIBUTING.md) explains how to work with and
contribute to this repository.

## Example Playbook

### Zookeeper Mode

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

### Kraft Mode

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
      node_id: "{{ ansible_default_ipv4 | split('.') | last }}"
      kafka_broker_id: "{{ node_id }}"
      kafka_advertised_listeners: "PLAINTEXT://{{ ansible_default_ipv4 }}:9092"
      kafka_listeners: "PLAINTEXT://{{ ansible_default_ipv4 }}:9092,CONTROLLER://{{ ansible_default_ipv4 }}:9093"
      kafka_controller_quorum_voters: "
        {%- set voters = [] %}
        {%- for host in groups['role_kf'] %}
        {{- voters.append( (hostvars[host]['ansible_default_ipv4'].address | split('.') | last) + '@' + hostvars[host]['ansible_default_ipv4'].address + ':9093' )}}
        {%- endfor %}
        {{- voters|join(',') -}}"
      kafka_listener_security_protocol_map: "CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,SSL:SSL,SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_SSL:SASL_SSL"
      kafka_cluster_id: " pregenerate using /bin/kafka/kafka-storage.sh random-uuid "
```
