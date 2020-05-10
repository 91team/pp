import 'package:http/http.dart';

import 'api_client.dart';
import 'request_builder.dart';

class ApiClientImpl implements ApiClient {
  final RequestBuilder _reqBuilder;

  ApiClientImpl(
    Client client, {
    String baseUrl,
  }) : _reqBuilder = RequestBuilder(client, baseUrl);

  @override
  String get baseUrl => _reqBuilder.baseUrl.toString();

  @override
  Future<String> get(
    String endpoint, {
    Map<String, dynamic> params,
    Map<String, dynamic> headers = const {},
  }) async {
    final request = _reqBuilder.buildGet(endpoint, params, headers);
    return request.execute();
  }

  @override
  Future<String> post(
    String endpoint, {
    Map<String, dynamic> body,
    Map<String, dynamic> headers = const {},
  }) async {
    final request = _reqBuilder.buildPost(endpoint, body, headers);
    return request.execute();
  }

  @override
  Future<String> postForm(
    String endpoint, {
    Map<String, dynamic> body,
    Map<String, dynamic> headers = const {},
  }) async {
    final request = _reqBuilder.buildPostForm(endpoint, body, headers);
    return request.execute();
  }

  @override
  Future<String> put(
    String endpoint, {
    Map<String, dynamic> body,
    Map<String, dynamic> headers = const {},
  }) async {
    final request = _reqBuilder.buildPut(endpoint, body, headers);
    return request.execute();
  }

  @override
  Future<String> putForm(
    String endpoint, {
    Map<String, dynamic> body = const {},
    Map<String, dynamic> headers = const {},
  }) async {
    final request = _reqBuilder.buildPutForm(endpoint, body, headers);
    return request.execute();
  }

  @override
  Future<String> delete(
    String endpoint, {
    Map<String, dynamic> headers = const {},
  }) async {
    final request = _reqBuilder.buildDelete(endpoint, headers);
    return request.execute();
  }
}
