redis-dep-install: 
  pkg.installed: 
    - pkgs: 
      - gcc
      - gcc-c++
      - make
      - tcl-devel
      - systemd-devel

redis:
  user.present:
    - shell: /sbin/nologin
    - createhome: false
    - system: true

unzip-redis:
  archive.extracted:
    - name: /usr/src
    - source: salt://redis/master/files/redis-6.2.6.tar.gz
    - if_missing: /usr/src/redis-6.2.6

redis-install.sh: 
  cmd.script: 
    - name: salt://redis/master/files/install.sh.j2
    - template: jinja
    - require: 
      - archive: unzip-redis
    - unless: /usr/src/redis-6.2.6

/usr/local/redis:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: ture

/usr/local/redis/conf: 
  file.directory: 
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: ture
    - require: 
      - cmd: redis-install.sh

{{ pillar['redis-installdir'] }}/conf/redis.conf: 
  file.managed: 
    - source: salt://redis/master/files/redis.conf.j2
    - template: jinja

/usr/lib/systemd/system/redis_server.service:
  file.managed: 
    - source: salt://redis/master/files/redis_server.service.j2 
    - template: jinja

redis_server.service: 
  service.running:
    - enable: true
    - reload: true
    - watch: 
      - file: /usr/lib/systemd/system/redis_server.service
