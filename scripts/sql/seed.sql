drop database if exists jsontypedef;

create database if not exists jsontypedef;

use jsontypedef;

create table users (
  id int auto_increment primary key,
  name_nullable varchar(255),
  name varchar(255) not null
);

insert into
  users
values
  (1, "danny", "danny not null");
