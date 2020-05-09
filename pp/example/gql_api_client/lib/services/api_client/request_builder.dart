import 'package:http/http.dart';

import 'request.dart';

class RequestBuilder {
  final Client client;

  final String tokenHeaderName;
  final String tokenPrefix;

  String token;
  final Uri baseUrl;

  void injectToken(String token) {
    this.token = token;
  }

  void destroyToken() {
    token = null;
  }

  bool get isTokenInjected {
    return token != null;
  }

  RequestBuilder(
    this.client,
    baseUrl,
    this.tokenHeaderName,
    this.tokenPrefix,
  ) : baseUrl = Uri.parse(baseUrl);

  ApiClientRequest buildGet(
    String endpoint,
    Map<String, dynamic> params,
    Map<String, dynamic> headers,
    bool protected,
  ) {
    final backedHeaders = _buildHeaders(headers, protected);
    final backedParams = _stringifyMapValues(params);
    return GetRequest(
      client: client,
      baseUrl: baseUrl,
      endpoint: endpoint,
      headers: backedHeaders,
      params: backedParams,
    );
  }

  ApiClientRequest buildPost(
    String endpoint,
    Map<String, dynamic> body,
    Map<String, dynamic> headers,
    bool protected,
  ) {
    final backedHeaders = _buildHeaders(headers, protected);
    return PostRequest(
      client: client,
      baseUrl: baseUrl,
      endpoint: endpoint,
      headers: backedHeaders,
      body: body,
    );
  }

  ApiClientRequest buildPostForm(
    String endpoint,
    Map<String, dynamic> body,
    Map<String, dynamic> headers,
    bool protected,
  ) {
    final backedHeaders = _buildHeaders(headers, protected);
    return SendFormRequest(
      client: client,
      baseUrl: baseUrl,
      endpoint: endpoint,
      headers: backedHeaders,
      body: body,
      method: 'post',
    );
  }

  ApiClientRequest buildPut(
    String endpoint,
    Map<String, dynamic> body,
    Map<String, dynamic> headers,
    bool protected,
  ) {
    final backedHeaders = _buildHeaders(headers, protected);
    final backedBody = _stringifyMapValues(body);
    return PutRequest(
      client: client,
      baseUrl: baseUrl,
      endpoint: endpoint,
      headers: backedHeaders,
      body: backedBody,
    );
  }

  ApiClientRequest buildPutForm(
    String endpoint,
    Map<String, dynamic> body,
    Map<String, dynamic> headers,
    bool protected,
  ) {
    final backedHeaders = _buildHeaders(headers, protected);
    return SendFormRequest(
      client: client,
      baseUrl: baseUrl,
      endpoint: endpoint,
      headers: backedHeaders,
      body: body,
      method: 'put',
    );
  }

  ApiClientRequest buildDelete(
    String endpoint,
    Map<String, dynamic> headers,
    bool protected,
  ) {
    final backedHeaders = _buildHeaders(headers, protected);
    return DeleteRequest(
      client: client,
      baseUrl: baseUrl,
      endpoint: endpoint,
      headers: backedHeaders,
    );
  }

  Map<String, String> _buildHeaders(Map<String, dynamic> headers, bool protected) {
    final headersWithStringValues = _stringifyMapValues(headers);
    final result = <String, String>{}..addAll(headersWithStringValues);
    if (protected) {
      result[tokenHeaderName] = _isTokenPrefixDefined ? '$tokenPrefix $token' : token;
    }

    return result;
  }

  Map<String, String> _stringifyMapValues(Map<String, dynamic> origin) {
    if (origin == null) {
      return null;
    }
    return origin.map<String, String>((key, value) => MapEntry(key, value.toString()));
  }

  bool get _isTokenPrefixDefined => tokenPrefix != null && tokenPrefix.isNotEmpty;
}
