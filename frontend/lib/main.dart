import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/table_visualizer.dart';
import 'handlers/handle_fetch_data.dart';
import 'widgets/floating_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataFetchHandler(),
      child: MaterialApp(
        title: 'Data Viz',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0x006f38e3)),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Data Viz'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String selectedDataSrc = 'test_1';

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DataFetchHandler>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          DropdownButton<String>(
            value: viewModel.selectedDataSrc,
            hint: Text('Select data source'),
            items: [
              DropdownMenuItem<String>(
                value: 'test_1',
                child: Text('Test 1'),
              ),
              DropdownMenuItem<String>(
                value: 'test_2',
                child: Text('Test 2'),
              ),
              DropdownMenuItem<String>(
                value: 'test_3',
                child: Text('Test 3'),
              ),
            ],
            onChanged: (String? newValue) {
              viewModel.updateSelectedDataSrc(newValue);
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              viewModel.refresh();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TableVisualizer(),
          ],
        ),
      ),
      floatingActionButton: FloatingMenu(maxRows: viewModel.maxRows),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
