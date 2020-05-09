import 'package:flutter/material.dart' hide Switch;
import 'package:flutter/widgets.dart';
import 'package:gql_api_client/ui/widgets/screen_wrapper/screen_wrapper.dart';

import 'controller/controller.dart';

class TestScreen extends StatelessWidget {
  final Animation<double> animationAppearance;

  const TestScreen({Key key, this.animationAppearance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      creator: () => TestScreenController()..init(),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  print('tap on start button');
                },
                child: Text('start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
