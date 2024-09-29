
import 'package:flutter/material.dart';

class DataLoadError extends StatefulWidget {
  const DataLoadError({super.key, required this.message, required this.refreshData});

  final String message;
  final Function refreshData;

  @override
  State<DataLoadError> createState() => _DataLoadErrorState();
}

class _DataLoadErrorState extends State<DataLoadError> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
      children: <Widget>[
        Text(widget.message),
        SizedBox(height: 20),
        FloatingActionButton.extended(
          onPressed: widget.refreshData(),
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Try again',
              style: TextStyle(
                fontSize: 16, // Adjust font size as needed
              )
            )
          )
        )
      ]),
    );
    }
}
