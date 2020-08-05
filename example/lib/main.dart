import 'package:example/installer.dart';
import 'package:example/pages/routes.dart';
import 'package:example/todo_app.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding
      .ensureInitialized(); // is required before using any plugins if the code is executed before runApp,

  ServiceManager.instance
    ..useInstaller(Installer())
    ..bootstrap();

  Routes.initializeNavigation();

  runApp(TodoApp());
}
