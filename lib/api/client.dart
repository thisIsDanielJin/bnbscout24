import 'package:appwrite/appwrite.dart';
import 'package:appwrite/realtime_browser.dart';

class ApiClient {
  Client get _client {
    Client client = Client();

    client
        .setEndpoint('https://god-did.de/v1')
        .setProject('6780ee1a896fed0b8da7')
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
