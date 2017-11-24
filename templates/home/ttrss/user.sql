UPDATE ttrss_users
   SET login    = '{{ ttrss_user }}',
       pwd_hash = 'MODE2:{{ ( ttrss_salt + ttrss_password )|hash("sha256") }}',
       salt     = '{{ ttrss_salt }}'
 WHERE id = 1;
