# Ansible Role for Kafka

Install and configure Kafka with Ansible

The [Contributing Guide](CONTRIBUTING.md) explains how to work with and
contribute to this repository.

## Example Playbook

```yml
- name: Install and configure Kafka
  hosts: kafka
  become: true
  pre_tasks:
    - name: Set kafka_controller_group
      ansible.builtin.set_fact:
        kafka_controller_group: "{{ groups[cluster] | intersect(groups.kafka_controller) }}"

    - name: Set kafka_controller_quorum_voters
      ansible.builtin.set_fact:
        kafka_controller_quorum_voters: "{{ kafka_controller_group | map('extract', hostvars, 'primary_ip4') }}"

  roles:
    - name: geerlingguy.java
    - name: remerge.kafka
      kafka_cluster_id: "{{ config_context.kafka_cluster_id }}"
      kafka_log_dirs:
        - /data/kafka/logs
```
