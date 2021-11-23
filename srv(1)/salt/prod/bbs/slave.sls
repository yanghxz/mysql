include:
  - modules.database.mysql.install
  - modules.database.mysql.slave

config-mysql-slave:
  cmd.script:
    - name: salt://bbs/files/start_slave.sh.j2
    - template: jinja

