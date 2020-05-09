import 'package:gql_api_client/services/gql_api_client/gql_api_client.dart';

class TestScreenController {
  final _api = GqlApiClient();

  TestScreenController() {
    _api.globalPrePipeline.add<PreProcessorParticle, PreProcessorParticle>((input) async {
      if (input.originalInput.protected) {
        input.headers['Access'] = 'TOKEN';
      }

      return input;
    });
  }

  void init() {}
  Future<String> tap() async {
    try {
      final response = await _api.sendRequest<String>(
        SendRequestParams(
          query: '''
            query GetConfig {
              getFAQ {
                question,
              }
            }
          ''',
          protected: true,
        ),
      );
      return response;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
