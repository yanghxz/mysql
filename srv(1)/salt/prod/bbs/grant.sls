grant-slave:
  cmd.run:
    - name: {{ pillar['mysql_installdir'] }}/bin/mysql -e "grant replication slave,super on *.* to repl@'192.168.101.210' identified by 'repl123!';flush privileges"
