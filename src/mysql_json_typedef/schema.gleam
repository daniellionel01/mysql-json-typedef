import gleam/option.{type Option}

/// #(name, columns)
pub type TableSchema =
  #(String, List(TableColumn))

pub type ColumnType {
  // https://dev.mysql.com/doc/refman/8.4/en/json.html
  JSON

  // https://dev.mysql.com/doc/refman/8.4/en/string-types.html
  VARCHAR(length: Int)
  VARBINARY
  BINARY
  CHAR
  BLOB
  TEXT
  ENUM
  SET

  /// https://dev.mysql.com/doc/refman/8.4/en/numeric-types.html
  SMALLINT
  INTEGER
  NUMERIC
  DECIMAL
  DOUBLE
  FIXED
  FLOAT
  REAL
  INT
  DEC

  /// https://dev.mysql.com/doc/refman/8.4/en/date-and-time-types.html
  YEAR
  DATE
  TIME
  DATETIME
  TIMESTAMP
}

pub type TableColumn {
  TableColumn(
    name: String,
    col_type: ColumnType,
    nullable: Bool,
    default: Option(String),
  )
}
