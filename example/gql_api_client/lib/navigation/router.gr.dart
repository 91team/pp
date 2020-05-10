// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:gql_api_client/ui/screens/test/test.dart';

class Router {
  static const test = '/';
  static final navigator = ExtendedNavigator();
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Router.test:
        if (hasInvalidArgs<TestScreenArguments>(args)) {
          return misTypedArgsRoute<TestScreenArguments>(args);
        }
        final typedArgs = args as TestScreenArguments ?? TestScreenArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => TestScreen(
              key: typedArgs.key,
              animationAppearance: typedArgs.animationAppearance),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

//**************************************************************************
// Arguments holder classes
//***************************************************************************

//TestScreen arguments holder class
class TestScreenArguments {
  final Key key;
  final Animation<double> animationAppearance;
  TestScreenArguments({this.key, this.animationAppearance});
}
