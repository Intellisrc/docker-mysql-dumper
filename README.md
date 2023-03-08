# docker-mysql-dumper
Dump all databases in mysql/mariadb into sql.gz files (for backup purposes)

## Example:

```yaml
services:
  dump:
    image: intellisrc/mysql_dumper:3.17
    volumes:
      - type: bind
        source: "/mnt/docker/sql"
        target: "/home"    
    environment:
      DB_HOST: my_mysql
      DB_PASS: ********************
      BACK_HOUR: 23
    networks:
      - db_net
    deploy:
      mode: replicated
      replicas: 1
      restart_policy:
        # Each hour (the script will use BACK_HOUR to do the backup)
        delay: 1h
      placement:
        constraints:
          - node.labels.db == true
```
