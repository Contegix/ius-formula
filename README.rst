==============
ius-formula
==============

Install the IUS RPM Repo and GPG Key on CentOS 6/7 (not tested in RHEL).

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``ius``
----------

Installs the GPG key and the IUS RPM package for the current OS.

The IUS testing repository can be enabled by setting the Pillar ``ius:testing: True``.

The IUS archive repository can be enabled by setting the Pillar ``ius:archive: True``.
