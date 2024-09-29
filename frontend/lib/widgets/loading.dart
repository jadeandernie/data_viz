
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({super.key, required this.message});

  final String message;

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Center(child: CircularProgressIndicator()),
        SizedBox(height: 20),
        Text(widget.message)
      ]);
    }
}
