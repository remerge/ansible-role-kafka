# Ansible Role for Kafka

Install and configure Kafka with Ansible.

The [Contributing Guide](CONTRIBUTING.md) explains how to work with and
contribute to this repository.

## Example Playbook

```yml
---
- name: Install and configure Kafka
  hosts: kafka
  become: true
  pre_tasks:
    - name: Install Java 17
      ansible.builtin.dnf:
        name: java-17-openjdk
        state: present

    - name: Set kafka_controller_quorum_voters
      ansible.builtin.set_fact:
        kafka_controller_quorum_voters: "{{ groups.kafka_controller }}"

    - name: Set controller process role
      ansible.builtin.set_fact:
        kafka_process_roles: [controller]
      when:
        - inventory_hostname in groups.kafka_controller

    - name: Set broker process role
      ansible.builtin.set_fact:
        kafka_process_roles: [broker]
      when:
        - inventory_hostname in groups.kafka_broker

  roles:
    - role: remerge.kafka
      # /opt/kafka/bin/kafka-storage.sh random-uuid
      kafka_cluster_id: "eGFY_ioORw2-OvrLlqMC3Q"
      kafka_listen_address: "{{ ansible_default_ipv4.address }}"
      kafka_log_dirs: [/data/kafka/logs]
      kafka_env:
        # disable Kafka loggc handling to log file
        EXTRA_ARGS: ""
        KAFKA_HEAP_OPTS: >-
          -Xmx4G -Xms4G
        KAFKA_JVM_PERFORMANCE_OPTS: >-
          -server
          -Xlog:gc
          -XX:+UseShenandoahGC
          -XX:+AlwaysPreTouch
          -XX:+UseNUMA
          -XX:+UseTransparentHugePages
```
