import 'package:pp/src/flowline.dart';
import 'package:pp/src/pipeline.dart';

void main() async {
  final pre = Pipeline<String, int>();
  final post_a = Pipeline<dynamic, int>();
  final post_b = Pipeline<dynamic, int>();
  final error = Pipeline();

  pre.add<String, int>((param) async => int.tryParse(param, radix: 10) + 1);
  pre.add((param) async => param + 1);
  pre.add((param) async => param + 1);
  pre.add((param) async => param + 1);
  pre.add((param) async => param + 1);

  Future<dynamic> executor(int input) async {
    if (input < 6) {
      throw Exception('FUCK!!! input lt 6 ');
    }
    return input + 1;
  }

  // A
  post_a.add<dynamic, int>((param) async => (param as int) + 1);
  post_a.add<int, int>((param) async => param + 1);
  post_a.add<int, String>((param) async => (param + 1).toString());
  // B
  post_b.add<String, int>((param) async => int.tryParse(param, radix: 10) + 1);
  post_b.add<int, int>((param) async => param + 1);
  post_b.add<int, int>((param) async => param + 1);

  final post = Pipeline<dynamic, int>.fromPipelinesList([post_a, post_b]);

  error.add((param) async {
    print('');
    print('');
    return Exception('AFTER ERROR PIPELINE');
  });

  Future<dynamic> errorHandler(Exception error) async {
    print(error);
    return Exception('AFTER ERROR PIPELINE 2');
  }

  error.add<Exception, dynamic>(errorHandler);

  final flow = Flowline<String, int, int>(
    prePipeline: pre,
    postPipeline: post,
    exceptionPipeline: error,
  );
  print(await (flow.wrapExecutor(executor))('1'));
}
