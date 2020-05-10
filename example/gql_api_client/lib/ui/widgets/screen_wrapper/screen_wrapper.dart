import 'package:flutter/material.dart';
import 'package:gql_api_client/ui/widgets/provider/provider.dart';

class ScreenWrapper<T> extends StatefulWidget {
  final Widget child;

  final T Function() creator;
  final void Function<T>(T controller) disposer;

  const ScreenWrapper({
    @required this.creator,
    @required this.child,
    this.disposer,
    Key key,
  })  : assert(child != null),
        assert(creator != null),
        super(key: key);

  @override
  _ScreenWrapperState<T> createState() => _ScreenWrapperState<T>();
}

class _ScreenWrapperState<T> extends State<ScreenWrapper> {
  T controller;

  @override
  void initState() {
    super.initState();
    controller = widget.creator();
  }

  @override
  void dispose() {
    if (widget.disposer != null) {
      widget.disposer(controller);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<T>(
      value: controller,
      child: widget.child,
    );
  }
}
