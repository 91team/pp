import 'package:flutter/foundation.dart';
import 'package:gql_api_client/services/api_client/api_client.dart';
import 'package:http/http.dart';
import 'package:pp/pp.dart';

class PreProcessorParticle<LT> {
  Map<String, String> headers;
  Map<String, dynamic> body;
  dynamic originalInput;

  PreProcessorParticle({
    @required this.headers,
    @required this.body,
    this.originalInput,
  });
}

class BaseParams {
  bool protected = false;
  BaseParams({this.protected});
}

class SendRequestParams extends BaseParams {
  String query;
  Map<String, dynamic> variables;

  SendRequestParams({@required this.query, this.variables, bool protected}) : super(protected: protected);
}

class GqlApiClient {
  ApiClient apiClient = ApiClient(Client(), baseUrl: 'https://ntt.91.team');
  Pipeline globalPrePipeline = Pipeline<PreProcessorParticle, PreProcessorParticle>();
  Pipeline postPipeline = Pipeline();
  Pipeline exceptionPipeline = Pipeline();

  Future<TResult> sendRequest<TResult>(SendRequestParams uInput) async {
    final flow = Flowline<SendRequestParams, _SendRequestParams, String>(
      prePipeline: _createSendRequsetPrePipeline(uInput),
      exceptionPipeline: exceptionPipeline,
    );

    final executor = flow.wrapExecutor(_sendRequest);

    return await executor(uInput) as TResult;
  }

  Pipeline<SendRequestParams, _SendRequestParams> _createSendRequsetPrePipeline(SendRequestParams uInput) {
    final transformPublicSendRequestParamsToParticle = Pipeline<SendRequestParams, PreProcessorParticle>.fromFunction(
      (originalInput) async {
        originalInput.protected = originalInput.protected ?? false;

        return PreProcessorParticle(
          body: {},
          headers: {},
          originalInput: originalInput,
        );
      },
    );

    final transformParticleToPrivateSendRequestParams = Pipeline<PreProcessorParticle, _SendRequestParams>.fromFunction(
      (input) async {
        if (input.originalInput is SendRequestParams) {
          final original = input.originalInput as SendRequestParams;
          return _SendRequestParams(
            body: {'query': original.query, 'variables': original.variables},
            headers: input.headers,
          );
        }

        throw Exception('input.original is not SendRequsetParams');
      },
    );

    return Pipeline<SendRequestParams, _SendRequestParams>.fromPipelinesList([
      transformPublicSendRequestParamsToParticle,
      globalPrePipeline,
      transformParticleToPrivateSendRequestParams,
    ]);
  }

  Future<String> _sendRequest(_SendRequestParams param) async {
    final response = await apiClient.post(
      'graphql/api',
      body: param.body,
      headers: param.headers,
    );

    return response;
  }
}

class _SendRequestParams {
  Map<String, dynamic> body;
  Map<String, dynamic> headers;

  _SendRequestParams({
    @required this.body,
    @required this.headers,
  });
}
