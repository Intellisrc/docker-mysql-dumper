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

`BACK_HOUR` is optional. If set, it will check the hour against it and will only run if they match (hence the `delay: 1h` option under `restart_policy`).

You can use `crazymax/swarm-cronjob` to schedule it as well (recommended):

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
      DB_PASS: ******************
    networks:
      - net      
    deploy:
      mode: replicated
      replicas: 0
      restart_policy:
		condition: none
      labels:
        - "swarm.cronjob.enable=true"
        - "swarm.cronjob.schedule=55 23 * * *"
        - "swarm.cronjob.skip-running=false"
      placement:
        constraints:
          - node.labels.db == true
```
