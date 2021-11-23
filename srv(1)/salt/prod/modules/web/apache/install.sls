apache-dep-package:
  pkg.installed:
    - pkgs:
      - openssl
      - pcre-devel
      - expat-devel
      - gcc
      - gcc-c++
      - libtool
      - make

apache:
  user.present:
    - shell: /sbin/nologin
    - createhome: false
    - system: true

apache-download:
  file.managed:
    - names:
      - /usr/src/apr-1.7.0.tar.gz:
        - source: salt://modules/web/apache/files/apr-1.7.0.tar.gz
      - /usr/src/apr-util-1.6.1.tar.gz:
        - source: salt://modules/web/apache/files/apr-util-1.6.1.tar.gz
      - /usr/src/httpd-2.4.48.tar.gz:
        - source: salt://modules/web/apache/files/httpd-2.4.48.tar.gz

apache-install:
  cmd.script:
    - name: salt://modules/web/apache/files/install.sh.j2
    - template: jinja
    - unless: test -d {{ pillar['httpd_installdir']}}
  
  
/usr/lib/systemd/system/httpd.service:
  file.managed:
    - source: salt://modules/web/apache/files/httpd.service.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja

systemctl daemon-reload:
  cmd.run

{{ pillar['httpd_installdir']}}/conf/httpd.conf:
  file.managed:
    - source: salt://modules/web/apache/files/httpd.conf
    - user: root
    - group: root
    - mode: '0644'
