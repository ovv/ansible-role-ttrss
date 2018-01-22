ovv.ttrss
=========

[![Build Status](https://travis-ci.org/ovv/ansible-role-ttrss.svg?branch=master)](https://travis-ci.org/ovv/ansible-role-ttrss)

Ansible role to install and configure [TinyTinyRSS](https://tt-rss.org/).

Requirements
------------

A PHP, Nginx and PostgreSQL installation are required. We recommend using [ovv.php7](https://github.com/ovv/ansible-role-php7),
[pyslackers.nginx](https://github.com/pyslackers/ansible-role-nginx) and [pyslackers.postgres](https://github.com/pyslackers/ansible-role-postgres).

Installation
------------

To install this roles clone it into your roles directory.

```bash
$ git clone https://github.com/ovv/ansible-role-ttrss.git ovv.ttrss
```

If your playbook already reside inside a git repository you can clone it by using git submodules.

```bash
$ git submodule add -b master https://github.com/ovv/ansible-role-ttrss.git ovv.ttrss
```

Role Variables
--------------

* `ttrss_user`: TinyTinyRSS admin username.
* `ttrss_password`: TinyTinyRSS admin password.
* `ttrss_salt`: TinyTinyRSS admin password salt.
* `ttrss_db_user`: Poostgres connection user.
* `ttrss_db_password`: Postgres password.
* `ttrss_url`: TinyTinyRSS url.
* `ttrss_crypt_key`: 24 character crypt key.
* `ttrss_email`: Outgoing email address.

* `ttrss_feed_update`: Interval between feeds update in minutes (default to `5`).
* `ttrss_git_url`: TinyTinyRSS git repo (default to `https://tt-rss.org/gitlab/fox/tt-rss.git`).
* `ttrss_version`: TinyTinyRSS git version (default to `master`).

* `ttrss_feedly`: Install TinyTinyRSS feedly theme (default to `True`).
* `ttrss_shaarli`: Install TinyTinyRSS shaarli plugin (default to `False`).

Other variables and their defaults are located in [defaults](defaults/main.yml).

Example Playbook
----------------

```yml
- hosts: localhost
  roles:
    - ovv.php7
    - pyslackers.postgres
    - ovv.ttrss
    - pyslackers.nginx
  vars:
    ttrss_user: admin
    ttrss_password: password
    ttrss_salt: randomsalt
    ttrss_db_user: ttrss
    ttrss_db_password: databasepassword
    ttrss_url: http://localhost
    ttrss_crypt_key: rand24characterscryptkey
    ttrss_email: ttrss@example.com

    # ovv.php
    custom_php_packages:
      - php7.0-json
      - php7.0-xml
      - php7.0-gd
      - php7.0-pgsql

    php_pools:
      ttrss:
        socket: /var/run/php7.0-fpm-ttrss.sock
        user: ttrss
        createhome: yes
        home: /home/ttrss
        working_dir: /opt/ttrss

    # pyslackers.nginx
    nginx_sites:
      ttrss:
        directory: /opt/ttrss
        locations:
          - location: ~ \.php$
            custom: |
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_pass unix:{{ php_pools['ttrss']['socket'] }};
              fastcgi_index index.php;
              include fastcgi.conf;
          - location: /
            custom: |
              try_files $uri $uri/ =404;

    # pyslackers.postgres
    postgres_users:
      ttrss:
        password: databasepassword
```

License
-------

MIT
