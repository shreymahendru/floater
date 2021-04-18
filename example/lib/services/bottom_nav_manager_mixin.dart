import 'package:example/services/bottom_nav_manager.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

mixin BottomNavManagerMixin {
  final bottomNavService = ServiceLocator.instance.resolve<BottomNavManager>();

  NavigatorState get currentNavigator => this.bottomNavService.navigatorState;

  int get currentSelectedNavItem =>
      this.bottomNavService.currentSelectedNavItem;

  Color get appBarColor {
    if (this.currentSelectedNavItem == 0)
      return Colors.red;
    else if (this.currentSelectedNavItem == 1)
      return Colors.blue;
    else
      return Colors.pink;
  }
}
