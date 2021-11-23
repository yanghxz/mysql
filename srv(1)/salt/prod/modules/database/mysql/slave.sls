include:
  - modules.database.mysql.install

/etc/my.cnf.d/slave.cnf:
  file.managed:
    - source: salt://modules/database/mysql/files/slave.cnf
    - user: root
    - group: root
    - mode: '0644'
mysql-stop-slave:
  service.dead:
    - name: mysqld.service

mysql-start-slave:
  service.running:
    - name: mysqld.service


