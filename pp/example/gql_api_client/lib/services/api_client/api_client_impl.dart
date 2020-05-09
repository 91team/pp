import 'package:http/http.dart';

import 'api_client.dart';
import 'request_builder.dart';

class ApiClientImpl implements ApiClient {
  final RequestBuilder _reqBuilder;

  ApiClientImpl(
    Client client, {
    String baseUrl,
    String tokenHeaderName = 'X-User-Token',
    String tokenPrefix = '',
  }) : _reqBuilder = RequestBuilder(client, baseUrl, tokenHeaderName, tokenPrefix);

  @override
  void injectToken(String token) {
    _reqBuilder.injectToken(token);
  }

  @override
  void destroyToken() {
    _reqBuilder.destroyToken();
  }

  @override
  String get baseUrl => _reqBuilder.baseUrl.toString();

  @override
  bool get isTokenInjected => _reqBuilder.isTokenInjected;

  @override
  Future<String> get(
    String endpoint, {
    Map<String, dynamic> params,
    Map<String, dynamic> headers = const {},
    bool protected = false,
  }) async {
    final request = _reqBuilder.buildGet(endpoint, params, headers, protected);
    return request.execute();
  }

  @override
  Future<String> post(
    String endpoint, {
    Map<String, dynamic> body,
    Map<String, dynamic> headers = const {},
    bool protected = false,
  }) async {
    final request = _reqBuilder.buildPost(endpoint, body, headers, protected);
    return request.execute();
  }

  @override
  Future<String> postForm(
    String endpoint, {
    Map<String, dynamic> body,
    Map<String, dynamic> headers = const {},
    bool protected = false,
  }) async {
    final request = _reqBuilder.buildPostForm(endpoint, body, headers, protected);
    return request.execute();
  }

  @override
  Future<String> put(
    String endpoint, {
    Map<String, dynamic> body,
    Map<String, dynamic> headers = const {},
    bool protected = false,
  }) async {
    final request = _reqBuilder.buildPut(endpoint, body, headers, protected);
    return request.execute();
  }

  @override
  Future<String> putForm(
    String endpoint, {
    Map<String, dynamic> body = const {},
    Map<String, dynamic> headers = const {},
    bool protected = false,
  }) async {
    final request = _reqBuilder.buildPutForm(endpoint, body, headers, protected);
    return request.execute();
  }

  @override
  Future<String> delete(
    String endpoint, {
    Map<String, dynamic> headers = const {},
    bool protected = false,
  }) async {
    final request = _reqBuilder.buildDelete(endpoint, headers, protected);
    return request.execute();
  }
}
