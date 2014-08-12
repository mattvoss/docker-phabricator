#!/bin/bash
set -e

if [ ! -f /installed ]; then
  MYSQL_HOST=${MYSQL_HOST:-172.17.42.1}
  MYSQL_PORT=${MYSQL_PORT:-3306}
  MYSQL_USERNAME=${MYSQL_USERNAME:-phabricator}
  MYSQL_PASSWORD=${MYSQL_PASSWORD:-password}
  MYSQL_DATABASE=${MYSQL_DATABASE:-phabricator}
  MYSQL_ADMIN_USERNAME=${MYSQL_ADMIN_USERNAME:-admin}
  MYSQL_ADMIN_PASSWORD=${MYSQL_ADMIN_PASSWORD:-password}
  BASE_URI=${BASE_URI:-http://phabricator.int/}
  TIMEZONE=${TIMEZONE:-America/Chicago}


  cd /opt/phabricator
  ./bin/config set mysql.host ${MYSQL_HOST}
  ./bin/config set mysql.port ${MYSQL_PORT}
  ./bin/config set mysql.user ${MYSQL_USERNAME}
  ./bin/config set mysql.pass ${MYSQL_PASSWORD}
  ./bin/storage upgrade --force --user ${MYSQL_ADMIN_USERNAME} --password ${MYSQL_ADMIN_PASSWORD}
  ./bin/config set storage.upload-size-limit 100M
  ./bin/config set phabricator.base-uri ${BASE_URI}
  ./bin/config set phabricator.timezone ${TIMEZONE}
  touch /installed
fi

/sbin/my_init
