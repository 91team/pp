import 'package:gql_api_client/services/gql_api_client/gql_api_client.dart';

class TestScreenController {
  final _api = GqlApiClient();

  void init() {}
  Future<String> tap() async {
    try {
      final response = await _api.request(
        RequestParams(
          query: '''
            query GetConfig {
              getFAQ {
                question,
              }
            }
          ''',
        ),
      );
      return response;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
