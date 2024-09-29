import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

List<DataColumn> jsonToDataColumns(json) {
  List<DataColumn> columns = [];
  if (json['headerRow'] == null) {
    return columns;
  }
  json['headerRow'].forEach((colName) {
    columns.add(DataColumn( label: Text(colName['data'])));
  });
  return columns;
}

class JsonDataTableSrc extends DataTableSource {
  JsonDataTableSrc({required this.rows});

  final List<DataRow> rows;

  @override
  int get rowCount => rows.length;

  @override
  DataRow? getRow(int index) {
    if (index > rows.length || index < 0) {
      return null;
    }
    return rows[index];
  }
  
  @override
  bool get isRowCountApproximate => false;
  
  @override
  int get selectedRowCount => 0;
}

DataTableSource jsonToDataSrc(json) {
  if (json['rows'] == null) {
    return JsonDataTableSrc(rows: []);
  }
  List<DataRow> rows = [];
  json['rows'].forEach((jsonRow) {
    var tableRowChildren = <DataCell>[];
    json['columns'].forEach((column) {
      var cell = jsonRow[column];
      var data = cell['data'];
      switch(cell['type']) {
        case 0: // PlainText
        case 2: // number
        case 3: // Boolean
          tableRowChildren.add(DataCell(Text(data)));
          break;
        case 1: // Link
          tableRowChildren.add(DataCell(
            InkWell(
              child: Text(data),
              onTap: () => launchUrl(data)
            )
          ));
          break;
        default:
          throw Error();
      }
    });
    rows.add(DataRow(cells: tableRowChildren));
  });

  return JsonDataTableSrc(rows: rows);
}