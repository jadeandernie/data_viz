import 'package:flutter/material.dart';

class FloatingMenu extends StatefulWidget {
  const FloatingMenu({super.key, required this.maxRows});

  final int maxRows;

  @override
  _FloatingMenuState createState() => _FloatingMenuState();
}

class _FloatingMenuState extends State<FloatingMenu> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();

  String? _errorMessage;

  void _validateInput() {
    setState(() {
      int start = int.tryParse(_startController.text) ?? -1;
      int end = int.tryParse(_endController.text) ?? -1;

      if (start < 0 || start >= widget.maxRows) {
        _errorMessage = 'Start row must be between 0 and ${widget.maxRows}.';
      } else if (end < start || end >= widget.maxRows) {
        _errorMessage = 'End row must be greater than start and less than ${widget.maxRows}.';
      } else {
        _errorMessage = null; // Clear error if valid
      }
    });
  }

  void _validateLimitInput() {
    setState(() {
      int limit = int.tryParse(_limitController.text) ?? -1;

      // This is lazy - Arbitrary limit set here, but it is restricted anyway by the BE.
      if (limit < 0 || limit >= 1000) {
        _errorMessage = 'Limit must be between 0 and 1000.';
      } else {
        _errorMessage = null; // Clear error if valid
      }
    });
  }

  void _showRowSelectionMenu(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100.0, 100.0, 0.0, 0.0), // Adjust position as needed
      items: [
        PopupMenuItem(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Start Row:'),
              TextField(
                controller: _startController,
                keyboardType: TextInputType.number,
                onChanged: (value) => _validateInput(),
                decoration: InputDecoration(
                  errorText: _errorMessage,
                ),
              ),
              SizedBox(height: 10),
              Text('End Row:'),
              TextField(
                controller: _endController,
                keyboardType: TextInputType.number,
                onChanged: (value) => _validateInput(),
                decoration: InputDecoration(
                  errorText: _errorMessage,
                ),
              ),
              SizedBox(height: 10),
              Text('Limit:'),
              TextField(
                controller: _limitController,
                keyboardType: TextInputType.number,
                onChanged: (value) => _validateLimitInput(),
                decoration: InputDecoration(
                  errorText: _errorMessage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showRowSelectionMenu(context),
      child: Icon(Icons.more_horiz),
    );
  }
}