import 'package:floater/floater.dart';
import 'package:flutter/material.dart';
import 'package:example/widgets/shell/shell.dart';

class TodoApp extends StatelessWidgetBase {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Shell(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
