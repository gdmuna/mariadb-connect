# mariadb-connect

MariaDB DataBase with Connect Engine.

## Quick reference

### Supported tags

- `10.11.13`, `10`, `latest`

### How to use this image

```shell
docker run -d \
--restart unless-stopped \
-p 3306:3306 \
-e MARIADB_ROOT_PASSWORD=my-secret-pw \
-v /my/own/datadir:/var/lib/mysql:Z \
--name mariadb \
mariadb-connect:latest
```
