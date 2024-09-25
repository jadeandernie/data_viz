
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class DataAsTable extends StatefulWidget {
  const DataAsTable({super.key});

  @override
  State<DataAsTable> createState() => _DataAsTableState();
}

Future<http.Response> fetchData(src) {
  return http.get(Uri.parse(src));
}

class _DataAsTableState extends State<DataAsTable> {
  List<TableRow> _tableData = [];
  bool isLoading = true;

  void refreshData() {
    setState(() {
      isLoading = true;
    });
      //192.168.68.52
    fetchData('http://localhost:8080/api/fetch')
    .then((res) {
      setState(() {
        if(res.body.isNotEmpty) {
          _tableData = jsonToTableRows(jsonDecode(res.body));
        } else {
          _tableData.add(const TableRow(children: [Text('is no worrking')]));
        }

        isLoading = false;
      });
    });
  }

  List<TableRow> jsonToTableRows(json) {
    List<TableRow> rows = [];

    var headingRowCells = <Widget>[];
    json['headerRow'].forEach((colName) {
      headingRowCells.add(Text(colName['data']));
    });
    rows.add(TableRow(children: headingRowCells));

    json['rows'].forEach((jsonRow) {
      var tableRowChildren = <Widget>[];
      json['columns'].forEach((column) {
        var cell = jsonRow[column];
        var data = cell['data'];
        switch(cell['type']) {
          case 0: // PlainText
          case 2: // number
          case 3: // Boolean
            tableRowChildren.add(Text(data));
            break;
          case 1: // Link
            tableRowChildren.add(
              InkWell(
                child: Text(data),
                onTap: () => launchUrl(data)
              )
            );
            break;
          default:
            throw Error();
        }
    });
      rows.add(TableRow(children: tableRowChildren));
    });

    refreshData();
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Column(
      children: <Widget>[
        Center(child: CircularProgressIndicator())
      ]) :
      Column(
          children: <Widget>[
            Table(
              border: TableBorder.all(),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: _tableData,
            ),
            FloatingActionButton(
              
              onPressed: refreshData,
              tooltip: 'Refresh',
              child: const Icon(Icons.refresh),
            ),
        ],
    );
  }
}
