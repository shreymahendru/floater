import 'package:example/pages/home/home_page.dart';
import 'package:example/services/bottom_nav_manager.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class HomePageState extends WidgetStateBase<HomePage> {
  final _bottomNavManager = ServiceLocator.instance.resolve<BottomNavManager>();

  late final GlobalKey<ScopedNavigatorState> nav0Key =
      this._bottomNavManager.nav0Key;
  late final GlobalKey<ScopedNavigatorState> nav1Key =
      this._bottomNavManager.nav1Key;
  late final GlobalKey<ScopedNavigatorState> nav2Key =
      this._bottomNavManager.nav2Key;

  int get activeNavItem => this._bottomNavManager.currentSelectedNavItem;

  HomePageState() : super();

  void onActiveNavItemChanged(int index) {
    this._bottomNavManager.onNavSelected(index);
    this.triggerStateChange();
  }
}
