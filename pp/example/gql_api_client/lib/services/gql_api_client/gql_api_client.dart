import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gql_api_client/services/api_client/api_client.dart';
import 'package:http/http.dart';
import 'package:pp/pp.dart';

class PreProcessorParticle {
  Map<String, String> headers;
  Map<String, dynamic> body;
  dynamic originalInput;

  PreProcessorParticle({
    @required this.headers,
    @required this.body,
    this.originalInput,
  });
}

class BaseParams {
  bool protected = false;
  BaseParams({this.protected});
}

class UploadFileParams extends BaseParams {
  File file;

  UploadFileParams({
    @required this.file,
    bool protected,
  }) : super(protected: protected);
}

class SendRequestParams extends BaseParams {
  String query;
  Map<String, dynamic> variables;

  SendRequestParams({
    @required this.query,
    this.variables,
    bool protected,
  }) : super(protected: protected);
}

class GqlApiClient {
  ApiClient apiClient = ApiClient(Client(), baseUrl: 'https://ntt.91.team');
  Pipeline globalPrePipeline = Pipeline<PreProcessorParticle, PreProcessorParticle>();
  Pipeline globalPostPipeline = Pipeline<dynamic, dynamic>();
  Pipeline globalExceptionPipeline = Pipeline();

  Future<TResult> sendRequest<TResult>(
    SendRequestParams uInput, {
    Pipeline<dynamic, TResult> postPipeline,
  }) async {
    final flow = Flowline<SendRequestParams, SendRequestPureParams, String>(
      prePipeline: _createSendRequestPrePipeline(uInput),
      postPipeline: _createPostPipeline<dynamic, String>(postPipeline),
      exceptionPipeline: globalExceptionPipeline.isEmpty == true ? null : globalExceptionPipeline,
    );

    final executor = flow.wrapExecutor(pureSendRequest);

    return await executor(uInput) as TResult;
  }

  Future<String> pureSendRequest(SendRequestPureParams param) async {
    final response = await apiClient.post(
      'graphql/api',
      body: param.body,
      headers: param.headers,
    );

    return response;
  }

  Future<TResult> uploadFile<TResult>(
    UploadFileParams uInput, {
    Pipeline<dynamic, TResult> postPipeline,
  }) async {
    final flow = Flowline<UploadFileParams, UploadFilePureParams, String>(
      prePipeline: _createUploadFilePrePipeline(uInput),
      postPipeline: _createPostPipeline<dynamic, String>(postPipeline),
      exceptionPipeline: globalExceptionPipeline.isEmpty == true ? null : globalExceptionPipeline,
    );

    final executor = flow.wrapExecutor(pureUploadFile);

    return await executor(uInput) as TResult;
  }

  Future<String> pureUploadFile(UploadFilePureParams param) async {
    final response = await apiClient.postForm(
      'graphql/api',
      body: param.body,
      headers: param.headers,
    );

    return response;
  }

  Pipeline<LI, LO> _createPostPipeline<LI, LO>(Pipeline postPipeline) {
    return Pipeline<LI, LO>.fromPipelinesList(
      [
        globalPostPipeline.isEmpty == true ? null : globalPostPipeline,
        postPipeline,
      ],
    );
  }

  Pipeline<SendRequestParams, SendRequestPureParams> _createSendRequestPrePipeline(SendRequestParams uInput) {
    final transformPublicSendRequestPureParamsToParticle =
        Pipeline<SendRequestParams, PreProcessorParticle>.fromFunction(
      (originalInput) async {
        originalInput.protected = originalInput.protected ?? false;

        return PreProcessorParticle(
          body: {},
          headers: {},
          originalInput: originalInput,
        );
      },
    );

    final transformParticleToPrivateSendRequestPureParams =
        Pipeline<PreProcessorParticle, SendRequestPureParams>.fromFunction(
      (input) async {
        if (input.originalInput is SendRequestParams) {
          final original = input.originalInput as SendRequestParams;
          return SendRequestPureParams(
            body: {'query': original.query, 'variables': original.variables},
            headers: input.headers,
          );
        }

        throw Exception('input.original is not SendRequestPureParams');
      },
    );

    return Pipeline<SendRequestParams, SendRequestPureParams>.fromPipelinesList([
      transformPublicSendRequestPureParamsToParticle,
      globalPrePipeline.isEmpty == true ? null : globalPrePipeline,
      transformParticleToPrivateSendRequestPureParams,
    ]);
  }

  Pipeline<UploadFileParams, UploadFilePureParams> _createUploadFilePrePipeline(UploadFileParams uInput) {
    final transformPublicUploadFileParamsToParticle = Pipeline<UploadFileParams, PreProcessorParticle>.fromFunction(
      (originalInput) async {
        originalInput.protected = originalInput.protected ?? false;

        return PreProcessorParticle(
          body: {},
          headers: {},
          originalInput: originalInput,
        );
      },
    );

    final transformParticleToPrivateUploadFileParams =
        Pipeline<PreProcessorParticle, UploadFilePureParams>.fromFunction(
      (input) async {
        if (input.originalInput is UploadFileParams) {
          final original = input.originalInput as UploadFileParams;

          return UploadFilePureParams(
            body: {
              'operations': '''
                    {
                        "query": "

                          mutation UploadSingle(\$file: Upload!){
                              singleUpload(file: \$file)
                          }
                        ",
                        "variables": { "file": null }
                    }
                ''',
              'map': '{ "0": ["variables.file"] }',
              '0': original.file
            },
            headers: input.headers,
          );
        }

        throw Exception('input.original is not UploadFileParams');
      },
    );

    return Pipeline<UploadFileParams, UploadFilePureParams>.fromPipelinesList([
      transformPublicUploadFileParamsToParticle,
      globalPrePipeline.isEmpty == true ? null : globalPrePipeline,
      transformParticleToPrivateUploadFileParams,
    ]);
  }
}

class SendRequestPureParams {
  Map<String, dynamic> body;
  Map<String, dynamic> headers;

  SendRequestPureParams({
    @required this.body,
    @required this.headers,
  });
}

class UploadFilePureParams {
  Map<String, dynamic> body;
  Map<String, dynamic> headers;

  UploadFilePureParams({
    @required this.body,
    @required this.headers,
  });
}
