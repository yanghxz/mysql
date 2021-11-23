/usr/src/oniguruma-devel-6.8.2-2.el8.x86_64.rpm:
  file.managed:
    - source: salt://modules/application/php/files/oniguruma-devel-6.8.2-2.el8.x86_64.rpm
    - user: root
    - group: root
    - mode: '0644'
  cmd.run:
    - name: yum -y install /usr/src/oniguruma-devel-6.8.2-2.el8.x86_64.rpm
    - unless: rpm -q oniguruma-devel

epel-install:
  cmd.run:
    - name: dnf -y install epel-release
    - unless: rpm -q epel-release

dep-pkckages-install:
  pkg.installed:
    - pkgs:
      - sqlite-devel
      - libzip-devel
      - libxml2
      - libxml2-devel
      - openssl
      - openssl-devel
      - bzip2
      - bzip2-devel
      - libcurl
      - libcurl-devel
      - libicu-devel
      - libjpeg-turbo
      - libjpeg-turbo-devel
      - libpng
      - libpng-devel
      - openldap-devel
      - pcre-devel
      - freetype
      - freetype-devel
      - gmp
      - gmp-devel
      - libmcrypt
      - libmcrypt-devel
      - readline
      - readline-devel
      - libxslt
      - libxslt-devel
      - mhash
      - mhash-devel
      - gcc
      - gcc-c++
      - make

php-unzip:
  archive.extracted:
    - name: /usr/src
    - source: salt://modules/application/php/files/php-{{ pillar['php_version'] }}.tar.gz
    - if_missing: /usr/src/php-{{ pillar['php_version'] }}

php-install:
  cmd.script:
    - name: salt://modules/application/php/files/install.sh.j2 
    - template: jinja
    - unless: test -d {{ pillar['php_installdir' ] }}      

/var/www/html/:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: true

copy-php:
  file.managed:
    - names:
      - /etc/init.d/php-fpm:
        - source: salt://modules/application/php/files/{{ pillar['php_conf_version'] }}
        - user: root
        - group: root
        - mode: '0755' 
      - {{ pillar['php_installdir' ] }}/etc/php-fpm.conf:
        - source: salt://modules/application/php/files/{{ pillar['php_conf_version'] }}.conf
      - {{ pillar['php_installdir'] }}/etc/php-fpm.d/www.conf:
        - source: salt://modules/application/php/files/www.conf
      - /usr/lib/systemd/system/php-fpm.service:
        - source: salt://modules/application/php/files/php-fpm.service
      - /etc/php.ini:
        - source: salt://modules/application/php/files/php.ini  
      - /var/www/html/index.php:
        - source: salt://lnmp/files/index.php
      - /var/www/html/mysql.php:
        - source: salt://modules/application/php/files/mysql.php.j2
        - template: jinja
    - require:
      - cmd: php-install

php-fpm.service:
  service.running:
    - enable: true
    - reload: true
    - require:
      - cmd: php-install
      - file: copy-php
    - watch:
      - file: copy-php
