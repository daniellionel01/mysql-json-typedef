#!/bin/bash

SEED=$(cat ./scripts/sql/seed.sql)

mysql -u root -P 3309 -pdaniel -h 127.0.0.1 -e "$SEED"
