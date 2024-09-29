import 'package:flutter/material.dart';

import '../utils/json_utils.dart';
import 'data_load_error.dart';

class JsonAsTable extends StatefulWidget {
  JsonAsTable({super.key, required this.json, required this.refresh}) {
    columns = jsonToDataColumns(json);
    src = jsonToDataSrc(json);
  }

  final Object json;
  final Function refresh;
  late final List<DataColumn> columns;
  late final DataTableSource src;

  @override
  State<JsonAsTable> createState() => _JsonAsTableState();
}

class _JsonAsTableState extends State<JsonAsTable> {
  @override
  Widget build(BuildContext context) {
    if (widget.columns.isEmpty && widget.src.rowCount < 1) {
      return DataLoadError(message: 'We didn\'t find any data. Please try again.', refreshData: widget.refresh);
    }
    return PaginatedDataTable(
      columns: widget.columns,
      source: widget.src,
      showEmptyRows: false,
    );
  }
}
