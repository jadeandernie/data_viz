
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../handlers/handle_fetch_data.dart';
import '../widgets/data_load_error.dart';
import '../widgets/json_as_table.dart';
import '../widgets/loading.dart';

class TableVisualizer extends StatefulWidget {
  const TableVisualizer({
    super.key,
  });
  
  @override
  State<TableVisualizer> createState() => _TableVisualizerState();
}

class _TableVisualizerState extends State<TableVisualizer> {

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DataFetchHandler>();
    if (viewModel.isLoading) {
      return Column(
        children: <Widget>[
          Loading(message: 'Loading data ...')
        ]
      );
    }

    if (viewModel.errorMessage.isNotEmpty) {
      return DataLoadError(message: viewModel.errorMessage, refreshData: viewModel.refresh);
    }

    var jsonData = viewModel.data['data'];
    if (jsonData == null) {
      return DataLoadError(message: 'Could not load data from server response. Please contact IT.', refreshData: viewModel.refresh);
    }

    return JsonAsTable(json: jsonData, refresh: viewModel.refresh);
  }
}