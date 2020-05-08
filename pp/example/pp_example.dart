void main() async {
  // Middleware a = ([dynamic p]) async {
  //   print('a::$p');
  //   return (p as num) + 1;
  // };

  Future<int> a([num p]) async {
    print('a::$p');
    return p + 1;
  }

  dynamic b = ([dynamic p]) async {
    print('b::$p');
    return (p as num) + 1;
  };

  dynamic c = ([dynamic p]) async {
    print('c::$p');
    return (p as num) + 1;
  };

  Future<String> d([int p]) async {
    print('d::$p');
    return (p + 1).toString();
  }

  // final inputAdapter = createInputAdapter([a as dynamic, b, c, d]);
  // print('final:${await inputAdapter(1)}');

  final inputCombine = Combine<int, String>()..addFn(a)..addFn(b)..addFn(c)..addFn<int, String>(d);

  final tranformedInput = await inputCombine.execute(1);
  print('final:${tranformedInput.toString()}');
}

typedef Middleware = Future<Object> Function([Object param]);
Future<TO> Function(TI input) createInputAdapter<TI, TO>(List<dynamic> middlewares) {
  final transform = (middlewares.reduce((acc, next) {
    return ([dynamic b]) async => await next(await acc(b));
  }));

  return (TI input) async {
    try {
      final transformed = await transform(input);
      return transformed as TO;
    } catch (e) {
      rethrow;
    }
  };
}

class Combine<I, O> {
  final List<dynamic> _middlewares = [];

  void addFn<LI, LO>(Future<LO> Function(LI param) fn) {
    _middlewares.add(fn);
  }

  void delAllFn(Future<dynamic> Function(dynamic param) fn, {int index}) {
    _middlewares.removeWhere((middleware) => middleware == fn);
  }

  Future<O> execute(I i) async {
    final transform = (_middlewares.reduce((acc, next) {
      return ([dynamic b]) async => await next(await acc(b));
    }));

    final result = (await (I input) async {
      try {
        final transformed = await transform(input);
        return transformed as O;
      } catch (e) {
        rethrow;
      }
    })(i);

    return result as dynamic;
  }
}
