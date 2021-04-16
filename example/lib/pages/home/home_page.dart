import 'package:example/pages/routes.dart';
import 'package:example/services/tab_manager.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';

class HomePage extends StatefulWidgetBase<HomePageState> {
  HomePage() : super(() => HomePageState());
  @override
  Widget build(BuildContext context) {
    // return ScopedNavigator("/home", initialRoute: "/homeTab");

    return Scaffold(
      body: this._buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this.state.activeTab,
        type: BottomNavigationBarType.shifting,
        onTap: (index) => this.state.activeTab = index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Red',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Blue',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Pink',
            backgroundColor: Colors.pink,
            // backgroundColor:
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: this.state.activeTab,
      children: [
        ScopedNavigator(
          // NavigationService.instance.generateRoute(Routes.home, {"tab": 0}),
          "/home",
          initialRoute: Routes.todos,
          key: this.state.tab0Key,
          initialRouteArgs: {
            "color": Colors.blue,
          },
        ),
        ScopedNavigator(
          // NavigationService.instance.generateRoute(Routes.home, {"tab": 1}),
          "/home",
          key: this.state.tab1Key,
          initialRoute: Routes.todos,
          initialRouteArgs: {
            "color": Colors.teal,
          },
        ),
        ScopedNavigator(
          // NavigationService.instance.generateRoute(Routes.home, {"tab": 2}),
          "/home",
          key: this.state.tab2Key,
          initialRoute: Routes.todos,
          initialRouteArgs: {
            "color": Colors.green,
          },
        ),
      ],
    );
  }
}

class HomePageState extends WidgetStateBase<HomePage> {
  final _tabService = ServiceLocator.instance.resolve<TabManager>();

  late final GlobalKey<ScopedNavigatorState> tab0Key = this._tabService.tab0Key;
  late final GlobalKey<ScopedNavigatorState> tab1Key = this._tabService.tab1Key;
  late final GlobalKey<ScopedNavigatorState> tab2Key = this._tabService.tab2Key;

  late int _activeTab = this._tabService.currentTab;
  int get activeTab => this._activeTab;
  set activeTab(int value) {
    this._activeTab = value;
    ServiceLocator.instance.resolve<TabManager>().currentTab = value;
    this..triggerStateChange();
  }

  HomePageState() : super();
}
