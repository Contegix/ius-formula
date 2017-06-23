# -*- coding: utf-8 -*-
# vim: ft=sls

{% if grains['os'] == 'CentOS' %}

{% set pkg = salt['grains.filter_by']({
  '6': {
    'key': 'https://dl.iuscommunity.org/pub/ius/IUS-COMMUNITY-GPG-KEY',
    'key_hash': 'md5=c1237411dfd37be229be063e8b5b4d10',
    'rpm': 'https://centos6.iuscommunity.org/ius-release.rpm',
  },
  '7': {
    'key': 'https://dl.iuscommunity.org/pub/ius/IUS-COMMUNITY-GPG-KEY',
    'key_hash': 'md5=c1237411dfd37be229be063e8b5b4d10',
    'rpm': 'https://centos7.iuscommunity.org/ius-release.rpm',
  },
}, 'osmajorrelease') %}

{% elif grains['os'] == 'RedHat' %}

{% set pkg = salt['grains.filter_by']({
  '6': {
    'key': 'https://dl.iuscommunity.org/pub/ius/IUS-COMMUNITY-GPG-KEY',
    'key_hash': 'md5=c1237411dfd37be229be063e8b5b4d10',
    'rpm': 'https://rhel6.iuscommunity.org/ius-release.rpm',
  },
  '7': {
    'key': 'https://dl.iuscommunity.org/pub/ius/IUS-COMMUNITY-GPG-KEY',
    'key_hash': 'md5=c1237411dfd37be229be063e8b5b4d10',
    'rpm': 'https://rhel7.iuscommunity.org/ius-release.rpm',
  },
}, 'osmajorrelease') %}

{% endif %}

{% if grains['os_family'] == 'RedHat' %}

ius.pubkey:
  file.managed:
    - name: /etc/pki/rpm-gpg/IUS-COMMUNITY-GPG-KEY
    - source: {{ salt['pillar.get']('ius:pubkey', pkg.key) }}
    - source_hash:  {{ salt['pillar.get']('ius:pubkey_hash', pkg.key_hash) }}

include:
    - epel

ius.rpm:
  pkg.installed:
    - sources:
      - ius-release: {{ salt['pillar.get']('ius:rpm', pkg.rpm) }}
    - requires:
      - file: ius.pubkey
      - pkg: epel

{% if salt['pillar.get']('ius:disabled', False) %}
ius.disable:
  file.replace:
    - name: /etc/yum.repos.d/ius.repo
    - pattern: '^enabled=\d'
    - repl: enabled=0
{% else %}
ius.enable:
  file.replace:
    - name: /etc/yum.repos.d/ius.repo
    - pattern: '^enabled=\d'
    - repl: enabled=1
{% endif %}

{% if salt['pillar.get']('ius:testing', False) %}
ius.testing_disable:
  file.replace:
    - name: /etc/yum.repos.d/ius-testing.repo
    - pattern: '^enabled=\d'
    - repl: enabled=1
{% else %}
ius.testing_enable:
  file.replace:
    - name: /etc/yum.repos.d/ius-testing.repo
    - pattern: '^enabled=\d'
    - repl: enabled=0
{% endif %}

{% if salt['pillar.get']('ius:dev', False) %}
ius.dev_disable:
  file.replace:
    - name: /etc/yum.repos.d/ius-dev.repo
    - pattern: '^enabled=\d'
    - repl: enabled=1
{% else %}
ius.dev_enable:
  file.replace:
    - name: /etc/yum.repos.d/ius-dev.repo
    - pattern: '^enabled=\d'
    - repl: enabled=0
{% endif %}

{% if salt['pillar.get']('ius:archive', False) %}
ius.archive_disable:
  file.replace:
    - name: /etc/yum.repos.d/ius-archive.repo
    - pattern: '^enabled=\d'
    - repl: enabled=1
{% else %}
ius.archive_enable:
  file.replace:
    - name: /etc/yum.repos.d/ius-archive.repo
    - pattern: '^enabled=\d'
    - repl: enabled=0
{% endif %}

{% endif %}
