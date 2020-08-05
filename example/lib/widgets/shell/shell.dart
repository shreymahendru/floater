import 'package:flutter/material.dart';
import 'package:floater/floater.dart';
import 'package:example/pages/routes.dart';

// Shell is always preset in the widget tree.
// This is where you create you root navigator, since it has to be always present in the widget tree.
// This could also other widgets that you always want on the widget tree, 
// Example Dialog Manager, AppLifecycleManager etc.. 
class Shell extends StatelessWidgetBase {
  @override
  Widget build(BuildContext context) {
    return ScopedNavigator(
      "/",
      initialRoute: Routes.splash,
    );
  }
}
