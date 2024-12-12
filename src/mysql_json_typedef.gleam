import gleam/io
import gleam/option.{Some}
import gmysql
import mysql_json_typedef/lib

pub fn main() {
  let config =
    gmysql.Config(
      ..gmysql.default_config(),
      user: Some("root"),
      password: Some("daniel"),
      database: "jsontypedef",
      port: 3309,
    )
  lib.query_schema(config)
  |> io.debug
}
