import 'package:example/pages/home/home_page_state.dart';
import 'package:example/pages/routes.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';

class HomePage extends StatefulWidgetBase<HomePageState> {
  HomePage() : super(() => HomePageState());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this._buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this.state.activeNavItem,
        type: BottomNavigationBarType.shifting,
        onTap: this.state.onActiveNavItemChanged,
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
      index: this.state.activeNavItem,
      children: [
        ScopedNavigator(
          // NavigationService.instance.generateRoute(Routes.home, {"tab": 0}),
          "/home",
          initialRoute: Routes.todos,
          key: this.state.nav0Key,
        ),
        ScopedNavigator(
          // NavigationService.instance.generateRoute(Routes.home, {"tab": 1}),
          "/home",
          key: this.state.nav1Key,
          initialRoute: Routes.todos,
        ),
        ScopedNavigator(
          // NavigationService.instance.generateRoute(Routes.home, {"tab": 2}),
          "/home",
          key: this.state.nav2Key,
          initialRoute: Routes.todos,
        ),
      ],
    );
  }
}
