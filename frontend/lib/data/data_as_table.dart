import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataAsTable extends StatefulWidget {
  const DataAsTable({super.key});

  @override
  State<DataAsTable> createState() => _DataAsTableState();
}

Future<http.Response> fetchData(src) {
  return http.get(Uri.parse(src));
}

class _DataAsTableState extends State<DataAsTable> {
  // Map<String, dynamic> _jsonData = {};
  String _jsonData = '';
  int count = 0;

  void refreshData() {
    setState(() {
      //192.168.68.52
      fetchData('http://0.0.0.0:8080/api/fetch')
      .then((res) => {
        _jsonData = jsonDecode(res.body)
      })
      .catchError((err) {
        _jsonData = 'Error retrieving data. $count, $err';
        count=count+1;
        return <dynamic>{};
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          children: <Widget>[
            const Text(
              'Here is the data \\o/',
            ),
            Text(
              _jsonData,
              style: Theme.of(context).textTheme.headlineMedium,
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
