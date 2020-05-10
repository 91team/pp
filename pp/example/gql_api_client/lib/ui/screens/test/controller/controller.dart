import 'package:gql_api_client/services/api_client/api_client.dart';
import 'package:gql_api_client/services/gql_api_client/gql_api_client.dart';
import 'package:http/http.dart';
import 'package:pp/pp.dart';

class TestScreenController {
  final _api = GqlApiClient(apiClient: ApiClient(Client(), baseUrl: 'https://ntt.91.team'));

  TestScreenController() {
    _api.globalPrePipeline.add<PreProcessorParticle, PreProcessorParticle>((input) async {
      if (input.originalInput.protected) {
        input.headers['Access'] = 'TOKEN';
      }

      _api.globalPostPipeline.add<String, dynamic>((data) async {
        return data;
      });
      ;

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
        postPipeline: Pipeline<String, String>.fromFunction(
          (param) async {
            return param;
          },
        ),
      );
      return response;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
