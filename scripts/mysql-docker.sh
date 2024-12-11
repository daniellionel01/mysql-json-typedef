#!/bin/bash
([[ $OSTYPE = "msys" ]] || [[ $OSTYPE = "cygwin" ]]) && DIR=$(pwd) || DIR=/var/lib/mysql

# mysql://root:gleam@127.0.0.1:3310/jsontypedef
docker run \
  --rm --name mysql-jsontypedef -d \
  -e="MYSQL_ROOT_PASSWORD=gleam" \
  -e="MYSQL_DATABASE=jsontypedef" \
  -p 3310:3306 \
  -v=$DIR:/var/lib/mysql \
  mysql:8.0.30 \
  --default-authentication-plugin=caching_sha2_password \
  --max_connections=10000
