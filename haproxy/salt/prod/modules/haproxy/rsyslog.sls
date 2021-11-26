/etc/rsyslog.conf:
  file.managed:
    - source: salt://modules/haproxy/files/rsyslog.conf

stop-rsyslog.service:
  service.dead:
    - name: rsyslog.service



statrt-rsyslog.service:
  service.running:
    - name: rsyslog.service
    - enable: true
