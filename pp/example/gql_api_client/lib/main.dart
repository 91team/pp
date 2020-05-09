import 'package:flutter/material.dart';

import 'navigation/router.gr.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goodies F Sample',
      navigatorKey: Router.navigator.key,
      onGenerateRoute: Router.onGenerateRoute,
      initialRoute: Router.test,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
