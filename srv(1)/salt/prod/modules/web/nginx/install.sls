nginc-dev-package:
  pkg.installed:
    - pkgs:
      - pcre-devel 
      - openssl 
      - openssl-devel 
      - gd-devel 
      - gcc 
      - gcc-c++ 
      - make 
      - wget    

nginx:
  user.present:
    - shell: /sbin/nologin
    - createhome: false
    - system: true

/var/log/nginx:
  file.directory:
    - user: nginx
    - group: nginx
    - mode: '0755'
    - makedirs: true

nginx-unzip:
  archive.extracted:
    - name: /usr/src
    - source: salt://modules/web/nginx/files/nginx-1.20.1.tar.gz
    - if_missing: /usr/src/nginx-1.20.1

nginx-installsh:
  cmd.script:
    - name: salt://modules/web/nginx/files/install.sh.j2
    - template: jinja
    - unless: test -d {{ pillar['nginx_installdir'] }}

/usr/lib/systemd/system/nginx.service:
  file.managed:
    - source: salt://modules/web/nginx/files/nginx.service.j2
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja

#systemctl daemon-reload:
#  cmd.run
