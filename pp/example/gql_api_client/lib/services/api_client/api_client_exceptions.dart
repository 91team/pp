abstract class ApiClientException implements Exception {}

class RedirectRequestException extends ApiClientException {
  final int status;
  final String response;

  RedirectRequestException(this.status, {this.response});

  @override
  String toString() => 'RedirectRequestException: $response';
}

class ClientSideRequestException extends ApiClientException {
  final int status;
  final String response;

  ClientSideRequestException(this.status, {this.response});

  @override
  String toString() => 'ClientSideRequestException: $response';
}

class UnauthorizedRequestException extends ApiClientException {
  final String response;

  UnauthorizedRequestException({this.response});

  @override
  String toString() => 'UnauthorizedRequestException: $response';
}

class ServerSideRequestException extends ApiClientException {
  final int status;
  final String response;

  ServerSideRequestException(this.status, {this.response});

  @override
  String toString() => 'ServerSideRequestException: $response';
}

class ApiClientInnerException extends ApiClientException {
  final String message;

  ApiClientInnerException(this.message);

  @override
  String toString() => 'ApiClientInnerException: $message';
}
