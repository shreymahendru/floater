import 'package:floater/floater.dart';
import 'splash_page.dart';
import 'package:example/pages/routes.dart';

class SplashPageState extends WidgetStateBase<SplashPage> {
  final _navigator =
      NavigationService.instance.retrieveNavigator("/"); // getting the root navigator.

  SplashPageState() : super() {
    this.onInitState(() {
      this._pauseAndGo();
    });
  }

  Future<void> _pauseAndGo() async {
    // can check authentication status here to redirect to login screen or home page, etc
    // or to fetch data from server, or execute any startup logic.

    await Future.delayed(Duration(seconds: 2));

    this._navigator.pushReplacementNamed(Routes.todos);
  }
}
