import 'package:flutter/foundation.dart';
import 'package:gql_api_client/services/api_client/api_client.dart';
import 'package:http/http.dart';
import 'package:pp/pp.dart';

class RequestParams {
  String query;
  Map<String, dynamic> variables;
  bool protected = false;

  RequestParams({@required this.query, this.variables, this.protected});
}

class _RequestParams {
  Map<String, dynamic> body;
  Map<String, dynamic> headers;
  bool protected = false;

  _RequestParams({
    @required this.body,
    @required this.headers,
    @required this.protected,
  });
}

class GqlApiClient {
  ApiClient apiClient = ApiClient(Client(), baseUrl: 'https://ntt.91.team');
  Pipeline prePipeline = Pipeline<RequestParams, _RequestParams>();
  Pipeline postPipeline = Pipeline();
  Pipeline exceptionPipeline = Pipeline();

  GqlApiClient() {
    prePipeline.add<RequestParams, _RequestParams>(
      (param) async {
        return _RequestParams(
          body: {'query': param.query, 'variables': param.variables},
          protected: param.protected ?? false,
          headers: {'Content-Type': 'application/json'},
        );
      },
    );

    exceptionPipeline.add((exception) async {
      return exception;
    });

    exceptionPipeline.add((exception) async {
      print(exception);
      return exception;
    });
  }

  Future<String> request(RequestParams param, {Pipeline<String, String> post}) async {
    final flow = Flowline<RequestParams, _RequestParams, String>(
      prePipeline: prePipeline,
      exceptionPipeline: exceptionPipeline,
    );

    final executor = flow.wrapExecutor(_request);
    return await executor(param);
  }

  Future<String> _request(_RequestParams param) async {
    final response = await apiClient.post(
      'graphql/api',
      body: param.body,
      protected: param.protected,
      headers: param.headers,
    );

    return response;
  }
}
