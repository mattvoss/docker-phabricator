#!/bin/sh

docker run -i -d -p 8081:80 -p 2244:22 \
 -v /data/phabricator/repo:/var/repo \
 -e "MYSQL_HOST=172.17.42.1" -e "MYSQL_PORT=3306" -e "MYSQL_USERNAME=phabricator" -e "MYSQL_PASSWORD=password" \
 -e "MYSQL_ADMIN_USERNAME=admin" -e "MYSQL_ADMIN_PASSWORD=password" -e "BASE_URI=http://phabricator.int/" \
 -e "TIMEZONE=America/Chicago" \
 --name phabricator \
  mattvoss/phabricator
