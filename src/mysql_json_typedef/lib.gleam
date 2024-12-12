import gleam/dict
import gleam/dynamic
import gleam/int
import gleam/io
import gleam/list
import gleam/result.{map_error, try}
import gleam/string
import gmysql
import mysql_json_typedef/schema.{type TableSchema}

pub fn parse_column_type(
  sql_column_type: String,
) -> Result(schema.ColumnType, String) {
  case sql_column_type {
    "int" -> Ok(schema.INT)
    "varchar" <> length -> {
      let length =
        length
        |> string.replace("(", "")
        |> string.replace(")", "")
        |> int.parse

      case length {
        Ok(length) -> Ok(schema.VARCHAR(length))
        Error(Nil) ->
          Error("could not parse length from varchar: " <> sql_column_type)
      }
    }
    _ -> Error("unknown column type: " <> sql_column_type)
  }
}

pub type QuerySchemaError {
  ConnectError(dynamic.Dynamic)
  QueryError(gmysql.Error)
}

pub fn query_schema(
  config: gmysql.Config,
) -> Result(List(TableSchema), QuerySchemaError) {
  use conn <- try(
    map_error(gmysql.connect(config), fn(err) { ConnectError(err) }),
  )

  let expecting =
    dynamic.tuple5(
      dynamic.string,
      dynamic.string,
      dynamic.string,
      dynamic.string,
      dynamic.optional(dynamic.string),
    )

  use rows <- try(map_error(gmysql.query("
    select
      TABLE_NAME,
      COLUMN_NAME,
      COLUMN_TYPE,
      IS_NULLABLE,
      COLUMN_DEFAULT
    from INFORMATION_SCHEMA.COLUMNS
    where TABLE_SCHEMA = '" <> config.database <> "';", on: conn, with: [], expecting:), fn(
    err,
  ) {
    QueryError(err)
  }))

  let result =
    list.group(rows, fn(row) { row.0 })
    |> dict.to_list()
    |> list.map(fn(el) {
      let #(table_name, rows) = el

      let cols =
        list.map(rows, fn(row) {
          let #(_, col_name, col_type, col_nullable, col_default) = row
          let assert Ok(col_type) = parse_column_type(col_type)

          schema.TableColumn(
            name: col_name,
            col_type:,
            nullable: col_nullable == "YES",
            default: col_default,
          )
        })

      #(table_name, cols)
    })

  Ok(result)
}
