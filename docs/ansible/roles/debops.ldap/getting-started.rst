Getting started
===============

.. contents::
   :local:


Ansible Controller requirements
-------------------------------

If you plan to use this role to perform LDAP tasks in the default
configuration, you need to install the ``python-ldap`` Python package in the
Ansible environment on the Controller host.

By default the role uses :command:`pass` (`Password Store`__) as a password
manager to store LDAP user credentials securely using GnuPG. As a fallback, you
can also provide the required password using an environment variable on the
Ansible Controller, or configure your own password lookup method.

.. __: https://www.passwordstore.org/


.. _ldap__ref_ldap_init:

LDAP directory initialization
-----------------------------

You can use the :file:`ansible/playbooks/ldap/init-directory.yml` Ansible
playbook to initialize new LDAP directory. This playbook is designed to be used
with the :ref:`slapd__ref_acl` configuration and will be updated on any
changes, if needed. To use it with the new OpenLDAP servers, run the command:

.. code-block:: console

   debops ldap/init-directory -l <slapd-server>

The playbook will use the current UNIX account information on the Ansible
Controller (``passwd`` database, SSH public keys from :command:`ssh-agent`) to
create a new user account in the LDAP directory with administrator privileges.

The user will be asked for a new password used to bind to the directory; this
password will be stored on the Ansible Controller using Password Store, and
used for :ref:`ldap__ref_admin`.

The playbook will not make any changes to existing LDAP objects. The default
``cn=admin`` LDAP object created during OpenLDAP installation will be removed.

.. note:: For the LDAP access to work, Ansible Controller needs to trust the
   Certificate Authority which is used by the OpenLDAP service. If you rely on
   the :ref:`debops.pki` internal CA, you will have to add the Root CA
   certificate managed by the role to the operating system certificate store.


Example inventory
-----------------

The :ref:`debops.ldap` role is included in the DebOps common playbook,
therefore you don't need to do anything special to enable it on a host. However
it is deactivated by default.

To enable the role, define in the Ansible inventory, for example in
:file:`ansible/inventory/group_vars/all/ldap.yml` file:

.. code-block:: yaml

   ldap__enabled: True

The :ref:`debops.ldap` role is used by many other DebOps roles [#f1]_, and enabling it
will affect the environment and configuration of multiple services, including
basic things like UNIX system groups used to manage the host. It's best to
either not enable LDAP support in a given environment, or enable it at the
beginning of a new deployment.

You can of course enable LDAP support in an existing environment, but you
should first learn about changes required by other Ansible roles for successful
migration. Check the documentation of other DebOps roles for more details.


Example playbook
----------------

If you are using this role without DebOps, here's an example Ansible playbook
that uses the ``debops.ldap`` role:

.. literalinclude:: ../../../../ansible/playbooks/service/ldap.yml
   :language: yaml


Ansible tags
------------

You can use Ansible ``--tags`` or ``--skip-tags`` parameters to limit what
tasks are performed during Ansible run. This can be used after host is first
configured to speed up playbook execution, when you are sure that most of the
configuration has not been changed.

Available role tags:

``role::ldap``
  Main role tag, should be used in the playbook to execute all of the role
  tasks as well as role dependencies.


Other resources
---------------

List of other useful resources related to the ``debops.ldap`` Ansible role:

- Manual pages: :man:`ldap.conf(5)`, :man:`ldif(5)`

- `LDAP for Rocket Scientists`__, an excellent book about LDAP and OpenLDAP

  .. __: http://www.zytrax.com/books/ldap/

- `Debian LDAP Portal`__ page in the Debian Wiki

  .. __: https://wiki.debian.org/LDAP

- `Ansible ldap_entry module`__, used to manage LDAP entries.

  .. __: https://docs.ansible.com/ansible/latest/modules/ldap_entry_module.html

- The role does not rely on the Ansible ``ldap_attr`` module, instead it uses
  the ``ldap_attrs`` module included in the ``debops.ansible_plugins`` role to
  manage LDAP attributes of an entry.

.. rubric:: Footnotes

.. [#f1] Well, not yet, but that's the planned direction that DebOps
         maintainers are looking into right now.
