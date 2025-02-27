import 'package:appwrite/appwrite.dart';
import 'package:bnbscout24/constants/config.dart';

class ApiClient {
  Client get _client {
    Client client = Client();

    client
        .setEndpoint(Config.API_BASE_URL)
        .setProject(Config.PROJECT_ID)
        .setSelfSigned();

    return client;
  }

  static Account get account => Account(_instance._client);
  static Databases get database => Databases(_instance._client);
  static Storage get storage => Storage(_instance._client);
  static Teams get teams => Teams(_instance._client);

  static final ApiClient _instance = ApiClient._internal();
  ApiClient._internal();
  factory ApiClient() => _instance;
}
