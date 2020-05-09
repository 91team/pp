import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'api_client_impl.dart';

export 'api_client_exceptions.dart';

abstract class ApiClient {
  String get baseUrl;

  factory ApiClient(
    Client client, {
    @required String baseUrl,
  }) =>
      ApiClientImpl(
        client,
        baseUrl: baseUrl,
      );

  Future<String> get(
    String endpoint, {
    Map<String, dynamic> params,
    Map<String, dynamic> headers,
  });

  Future<String> post(
    String endpoint, {
    Map<String, dynamic> body,
    Map<String, dynamic> headers,
  });

  Future<String> postForm(
    String endpoint, {
    Map<String, dynamic> body,
    Map<String, dynamic> headers,
  });

  Future<String> put(
    String endpoint, {
    Map<String, dynamic> body,
    Map<String, dynamic> headers,
  });

  Future<String> putForm(
    String endpoint, {
    Map<String, dynamic> body,
    Map<String, dynamic> headers,
  });

  Future<String> delete(
    String endpoint, {
    Map<String, dynamic> headers,
  });
}
