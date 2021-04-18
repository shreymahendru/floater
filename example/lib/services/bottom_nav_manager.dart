import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class BottomNavManager {
  final GlobalKey<ScopedNavigatorState> nav0Key = GlobalKey();
  final GlobalKey<ScopedNavigatorState> nav1Key = GlobalKey();
  final GlobalKey<ScopedNavigatorState> nav2Key = GlobalKey();

  int _currentSelectedNavItem = 0;
  int get currentSelectedNavItem => this._currentSelectedNavItem;

  GlobalKey<ScopedNavigatorState>? currentNav;

  NavigatorState get navigatorState {
    if (currentSelectedNavItem == 0)
      return this.nav0Key.currentState!.navigator!;
    else if (currentSelectedNavItem == 1)
      return this.nav1Key.currentState!.navigator!;
    else
      return this.nav2Key.currentState!.navigator!;
  }

  void onNavSelected(int index) {
    if (this.currentSelectedNavItem == index) {
      this.navigatorState.popUntil((route) => route.isFirst);
    } else {
      this._currentSelectedNavItem = index;
    }
  }
}
