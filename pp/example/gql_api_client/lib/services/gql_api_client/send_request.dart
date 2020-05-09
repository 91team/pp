// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:gql_api_client/services/api_client/api_client.dart';
// import 'package:http/http.dart';
// import 'package:pp/pp.dart';

// class SendRequestParams {
//   String query;
//   Map<String, dynamic> variables;
//   bool protected = false;

//   SendRequestParams({@required this.query, this.variables, this.protected});
// }

// class _SendRequestParams {
//   Map<String, dynamic> body;
//   Map<String, dynamic> headers;

//   _SendRequestParams({
//     @required this.body,
//     @required this.headers,
//   });
// }

// class _SendRequestFullParams(){
//   //
// }

// class SendFileParams {
//   File file;
//   bool protected = false;

//   SendFileParams({@required this.file, this.protected});
// }

// class _SendFileParams {
//   Map<String, dynamic> body;
//   Map<String, dynamic> headers;

//   _SendFileParams({
//     @required this.body,
//     @required this.headers,
//   });
// }

// class GqlApiClient {
//   ApiClient apiClient = ApiClient(Client(), baseUrl: 'https://ntt.91.team');
//   Pipeline globalPrePipeline = Pipeline<SendRequestParams, _SendRequestParams>();
//   Pipeline postPipeline = Pipeline();
//   Pipeline exceptionPipeline = Pipeline();

//   GqlApiClient();

//   // SEND REQUEST
//   Future<String> sendRequest(
//     SendRequestParams param, {
//     Pipeline<String, String> post,
//   }) async {
//     final flow = Flowline<SendRequestParams, _SendRequestParams, String>(
//       prePipeline: _getSendRequestPrePipeline(),
//       exceptionPipeline: exceptionPipeline,
//     );

//     final executor = flow.wrapExecutor(_sendRequest);
//     return await executor(param);
//   }

//   Future<String> _sendRequest(_SendRequestParams param) async {
//     final response = await apiClient.post(
//       'graphql/api',
//       body: param.body,
//       headers: param.headers,
//     );

//     return response;
//   }

//   Pipeline _getSendRequestPrePipeline() {
//     final locaPrelPipeline = Pipeline()..add(_transformSendRequestParams);

//     return Pipeline.fromPipelinesList([
//       locaPrelPipeline,
//       globalPrePipeline,
//     ]);
//   }

//   Future<_SendRequestParams> _transformSendRequestParams(SendRequestParams iParams) async {
//     return _SendRequestParams(
//       body: {'query': iParams.query, 'variables': iParams.variables},
//       protected: iParams.protected ?? false,
//       headers: {'Content-Type': 'application/json'},
//     );
//   }

//   // SEND FILE
//   Future<String> sendFileRequest(
//     SendFileParams param, {
//     Pipeline<String, String> post,
//   }) async {
//     final flow = Flowline<SendFileParams, _SendFileParams, String>(
//       prePipeline: _getSendFilePrePipeline(),
//       exceptionPipeline: exceptionPipeline,
//     );

//     final executor = flow.wrapExecutor(_sendFile);
//     return await executor(param);
//   }

//   Future<String> _sendFile(_SendFileParams param) async {
//     final response = await apiClient.post(
//       'graphql/api',
//       body: param.body,
//       headers: param.headers,
//     );

//     return response;
//   }

//   Pipeline<SendFileParams, _SendFileParams> _getSendFilePrePipeline() {
//     return Pipeline.fromPipelinesList([
//       globalPrePipeline,
//       Pipeline()..add(_transformSendFileParams),
//     ]);
//   }

//   Future<_SendFileParams> _transformSendFileParams(SendFileParams iParams) async {
//     return _SendFileParams(
//       body: {
//         'operations': '''
//               {
//                   "query": "

//                     mutation UploadSingle(\$file: Upload!){
//                         singleUpload(file: \$file)
//                     }
//                   ",
//                   "variables": { "file": null }
//               }
//           ''',
//         'map': '{ "0": ["variables.file"] }',
//         '0': iParams.file
//       },
//       headers: {'Content-Type': 'application/json'},
//     );
//   }
// }
