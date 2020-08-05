import 'package:flutter/material.dart';
import 'package:floater/floater.dart';
import 'splash_page_state.dart';

class SplashPage extends StatefulWidgetBase<SplashPageState> {
  SplashPage() : super(() => SplashPageState());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: FlutterLogo(
                  size: 200,
                ),
              ),
            ),
            Text(
              "Floater Example",
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16)
          ],
        ),
      ),
    );
  }
}
