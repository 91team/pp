import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import 'api_client_exceptions.dart';

abstract class ApiClientRequest {
  Client client;
  Uri url;
  Map<String, String> headers;

  ApiClientRequest({
    @required this.client,
    @required this.headers,
    @required Uri baseUrl,
    @required String endpoint,
    @required Map<String, String> params,
  }) : url = _buildUrl(baseUrl, endpoint, params);

  static Uri _buildUrl(Uri baseUrl, String endpoint, Map<String, String> params) {
    return baseUrl.replace(path: '${baseUrl.path}/$endpoint');
  }

  Future<String> execute() async {
    try {
      final response = await _execute();

      _checkResponseStatusCode(response);

      return response.body;
    } on ClientException catch (exception) {
      throw ApiClientInnerException(exception.message);
    }
  }

  Future<Response> _execute();

  void _checkResponseStatusCode(Response response) {
    final status = response.statusCode;
    if (status == 401) {
      throw UnauthorizedRequestException(response: response.body);
    }

    // on 4xx
    if (status ~/ 100 == 4) {
      throw ClientSideRequestException(status, response: response.body);
    }

    // on 5xx
    if (status ~/ 100 == 5) {
      throw ServerSideRequestException(status, response: response.body);
    }
  }
}

class GetRequest extends ApiClientRequest {
  GetRequest({
    Client client,
    Uri baseUrl,
    String endpoint,
    Map<String, String> headers,
    Map<String, String> params,
  }) : super(
          client: client,
          headers: headers,
          baseUrl: baseUrl,
          endpoint: endpoint,
          params: params,
        );

  @override
  Future<Response> _execute() async {
    return client.get(
      url.toString(),
      headers: headers,
    );
  }
}

class PostRequest extends ApiClientRequest {
  Map<String, dynamic> body;

  PostRequest({
    Client client,
    Uri baseUrl,
    String endpoint,
    Map<String, String> headers,
    Map<String, String> params,
    this.body,
  }) : super(
          client: client,
          headers: headers,
          baseUrl: baseUrl,
          endpoint: endpoint,
          params: params,
        );

  @override
  Future<Response> _execute() async {
    return client.post(
      url.toString(),
      headers: headers,
      body: json.encode(body),
    );
  }
}

class PutRequest extends ApiClientRequest {
  Map<String, String> body;

  PutRequest({
    Client client,
    Uri baseUrl,
    String endpoint,
    Map<String, String> headers,
    Map<String, String> params,
    this.body,
  }) : super(
          client: client,
          headers: headers,
          baseUrl: baseUrl,
          endpoint: endpoint,
          params: params,
        );

  @override
  Future<Response> _execute() async {
    return client.put(
      url.toString(),
      headers: headers,
      body: body,
    );
  }
}

class DeleteRequest extends ApiClientRequest {
  Map<String, String> body;

  DeleteRequest({
    Client client,
    Uri baseUrl,
    String endpoint,
    Map<String, String> headers,
    Map<String, String> params,
    this.body,
  }) : super(
          client: client,
          headers: headers,
          baseUrl: baseUrl,
          endpoint: endpoint,
          params: params,
        );

  @override
  Future<Response> _execute() async {
    return client.delete(
      url.toString(),
      headers: headers,
    );
  }
}

class SendFormRequest extends ApiClientRequest {
  final Map<String, dynamic> body;
  final String method;

  SendFormRequest({
    Client client,
    Uri baseUrl,
    String endpoint,
    Map<String, String> headers,
    Map<String, String> params,
    this.method,
    this.body,
  }) : super(
          client: client,
          headers: headers,
          baseUrl: baseUrl,
          endpoint: endpoint,
          params: params,
        );

  @override
  Future<Response> _execute() async {
    final request = MultipartRequest(method, url);
    request.headers.addAll(headers);

    await _fillRequestWithBodyContent(request, body);

    final response = await Response.fromStream(await request.send());
    return response;
  }

  Future<void> _fillRequestWithBodyContent(MultipartRequest request, Map<String, dynamic> body) async {
    for (final key in body.keys) {
      if (body[key] is File) {
        final File file = body[key];

        final fileName = file.path.split('/').last;
        final multipartFile = MultipartFile.fromBytes(
          key,
          await File.fromUri(file.uri).readAsBytes(),
          filename: fileName,
          contentType: MediaType('file', fileName.split('.').last),
        );
        request.files.add(multipartFile);
        assert(request.files.isNotEmpty);
      } else {
        request.fields[key] = body[key].toString();
      }
    }
  }
}
