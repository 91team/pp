import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'api_client_impl.dart';

export 'api_client_exceptions.dart';

abstract class ApiClient {
  void injectToken(String token);
  void destroyToken();
  bool get isTokenInjected;

  String get baseUrl;

  factory ApiClient(
    Client client, {
    @required String baseUrl,
    String tokenHeaderName = 'X-User-Token',
    String tokenPrefix = '',
  }) =>
      ApiClientImpl(
        client,
        baseUrl: baseUrl,
        tokenHeaderName: tokenHeaderName,
        tokenPrefix: tokenPrefix,
      );

  Future<String> get(
    String endpoint, {
    Map<String, dynamic> params,
    Map<String, dynamic> headers,
    bool protected,
  });

  Future<String> post(
    String endpoint, {
    Map<String, dynamic> body,
    Map<String, dynamic> headers,
    bool protected,
  });

  Future<String> postForm(
    String endpoint, {
    Map<String, dynamic> body,
    Map<String, dynamic> headers,
    bool protected,
  });

  Future<String> put(
    String endpoint, {
    Map<String, dynamic> body,
    Map<String, dynamic> headers,
    bool protected,
  });

  Future<String> putForm(
    String endpoint, {
    Map<String, dynamic> body,
    Map<String, dynamic> headers,
    bool protected,
  });

  Future<String> delete(
    String endpoint, {
    Map<String, dynamic> headers,
    bool protected,
  });
}
