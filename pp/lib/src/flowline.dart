import 'package:pp/src/pipeline.dart';

class Flowline<I, IExecutor, O> {
  Pipeline<I, IExecutor> prePipeline;
  Pipeline<dynamic, O> postPipeline;
  Pipeline<dynamic, dynamic> exceptionPipeline;

  Flowline({this.prePipeline, this.postPipeline, this.exceptionPipeline});

  Future<O> Function(I input) wrapExecutor(
    Future<dynamic> Function(IExecutor executorInput) executor, {
    Pipeline<IExecutor, IExecutor> localPrePipeline,
    Pipeline<dynamic, O> localPostPipeline,
    Pipeline<dynamic, dynamic> localErrorPipeline,
  }) {
    Future<O> wrapedExecutor(I input) async {
      try {
        final _executorInput = prePipeline != null ? await prePipeline.run(input) : input;
        final _executorOutput = await executor(_executorInput);
        final _output = postPipeline != null ? await postPipeline.run(_executorOutput) : _executorOutput;
        return _output;
      } catch (e) {
        if (exceptionPipeline != null) {
          throw await exceptionPipeline.run(e);
        }

        rethrow;
      }
    }

    return wrapedExecutor;
  }
}
