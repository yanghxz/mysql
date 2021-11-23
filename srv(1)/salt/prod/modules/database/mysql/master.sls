/etc/my.cnf.d/master.cnf:
  file.managed:
    - source: salt://modules/database/mysql/files/master.cnf
    - user: root
    - group: root
    - mode: '0644'

mysql-stop-master:
  service.dead:
    - name: mysqld.service

mysql-start-master:
  service.running:
    - name: mysqld.service 
 
