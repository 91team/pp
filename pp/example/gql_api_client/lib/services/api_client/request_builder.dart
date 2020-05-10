import 'package:http/http.dart';

import 'request.dart';

class RequestBuilder {
  final Client client;

  final Uri baseUrl;

  RequestBuilder(
    this.client,
    baseUrl,
  ) : baseUrl = Uri.parse(baseUrl);

  ApiClientRequest buildGet(
    String endpoint,
    Map<String, dynamic> params,
    Map<String, dynamic> headers,
  ) {
    final backedHeaders = _buildHeaders(headers);
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
  ) {
    final backedHeaders = _buildHeaders(headers);
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
  ) {
    final backedHeaders = _buildHeaders(headers);
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
  ) {
    final backedHeaders = _buildHeaders(headers);
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
  ) {
    final backedHeaders = _buildHeaders(headers);
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
  ) {
    final backedHeaders = _buildHeaders(headers);
    return DeleteRequest(
      client: client,
      baseUrl: baseUrl,
      endpoint: endpoint,
      headers: backedHeaders,
    );
  }

  Map<String, String> _buildHeaders(Map<String, dynamic> headers) {
    final headersWithStringValues = _stringifyMapValues(headers);
    final result = <String, String>{}..addAll(headersWithStringValues);
    return result;
  }

  Map<String, String> _stringifyMapValues(Map<String, dynamic> origin) {
    if (origin == null) {
      return null;
    }
    return origin.map<String, String>((key, value) => MapEntry(key, value.toString()));
  }
}
