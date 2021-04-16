import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class TabManager {
  final GlobalKey<ScopedNavigatorState> tab0Key = GlobalKey();
  final GlobalKey<ScopedNavigatorState> tab1Key = GlobalKey();
  final GlobalKey<ScopedNavigatorState> tab2Key = GlobalKey();

  int currentTab = 0;

  GlobalKey<ScopedNavigatorState>? currentNav;

  NavigatorState get navigatorState {
    if (currentTab == 0)
      return this.tab0Key.currentState!.navigator!;
    else if (currentTab == 1)
      return this.tab1Key.currentState!.navigator!;
    else
      return this.tab2Key.currentState!.navigator!;
  }
}
