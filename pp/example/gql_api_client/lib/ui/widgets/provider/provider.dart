import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Provider<T> extends InheritedWidget {
  const Provider({
    @required Widget child,
    @required this.value,
    Key key,
  }) : super(key: key, child: child);

  final T value;

  static U of<U>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider<U>>().value;
  }

  @override
  bool updateShouldNotify(Provider oldWidget) => false;
}

extension Provide on BuildContext {
  T provide<T>() {
    return Provider.of<T>(this);
  }
}
