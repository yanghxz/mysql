dep-keepalived-packages:
  pkg.installed:
    - pkgs:
      - keepalived
      - nginx


/scripts:
  file.directory:
    - user: root
    - group: root
    - mode: '0644'

service-scripts:
  file.managed:
    - names:
      - /scripts/check_n.sh: 
        - source: salt://modules/keepalived/files/check_n.sh
      - /scripts/notify.sh:
        - source: salt://modules/keepalived/files/notify.sh


/etc/keepalived/keepalived.conf:
  file.managed:
    - source: salt://modules/keepalived/files/keepalived_master.conf.j2
    - template: jinja


master-start-nginx:
  service.running:
    - name: nginx
    - enable: true

master-start-keepalived:
  service.running:
    - name: keepalived
    - enable: true
    - reload: true
    - watch:
      - file: /etc/keepalived/keepalived.conf

