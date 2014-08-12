docker-phabricator
==================
Dockerfile with ubuntu 14.04 / nginx / phabricator / external mysql server


Run
----
```
docker run mattvoss/docker-phabricator
```

Build and run
---------------

```
git clone https://github.com/yesnault/docker-phabricator.git
docker build --no-cache -t mattvoss/phabricator .
docker run -i -d -p 8081:80 -p 2244:22 \
 -v /data/phabricator/repo:/var/repo \
 -e "MYSQL_HOST=172.17.42.1" -e "MYSQL_PORT=3306" -e "MYSQL_USERNAME=phabricator" -e "MYSQL_PASSWORD=password" \
 -e "MYSQL_ADMIN_USERNAME=admin" -e "MYSQL_ADMIN_PASSWORD=password" -e "BASE_URI=http://phabricator.int/" \
 -e "TIMEZONE=America/Chicago" \
 --name phabricator \
  mattvoss/phabricator
````

Go to http://localhost.local:8081

Docker HTTP listen on 8081 and ssh listen on 2244

Repositories files are written on `/data/phabricator/repo` (described in run-server.sh)

