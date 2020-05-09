typedef Middleware<I, O> = Future<O> Function(I);

class Pipeline<I, O> {
  final List<Function> _middlewares = [];

  Pipeline();

  Pipeline.fromPipelinesList(List<Pipeline<dynamic, dynamic>> pipelines) {
    for (final pipeline in pipelines) {
      if (pipeline != null) {
        _middlewares.addAll(pipeline._middlewares);
      }
    }
  }

  Pipeline.fromPipeline(Pipeline<dynamic, dynamic> pipeline) {
    _middlewares.addAll(pipeline._middlewares);
  }

  Pipeline.fromFunction(Middleware<I, O> middleware) {
    _middlewares.add(middleware);
  }

  void add<LI, LO>(Future<LO> Function(LI param) fn) {
    _middlewares.add(fn);
  }

  Future<O> run(I i) async {
    final transform = _makeTransform();

    final result = (await (I input) async {
      final transformed = await transform(input);
      return transformed as O;
    })(i);

    return result as dynamic;
  }

  Function _makeTransform() {
    return (_middlewares.reduce((prev, current) {
      return ([dynamic a]) async => await current(await prev(a));
    }));
  }
}
