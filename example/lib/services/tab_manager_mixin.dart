import 'package:example/services/tab_manager.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

mixin TabManagerMixin {
  final tabService = ServiceLocator.instance.resolve<TabManager>();

  NavigatorState get currentTabNavigator => this.tabService.navigatorState;

  int get currentTab => this.tabService.currentTab;

  Color get appBarColor {
    if (this.currentTab == 0)
      return Colors.red;
    else if (this.currentTab == 1)
      return Colors.blue;
    else
      return Colors.pink;
  }
}
