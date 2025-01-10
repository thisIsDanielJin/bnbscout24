import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenTriviaCommunication {
  static Future<Map<String, dynamic>> getQuizQuestions({int numQuestions = 10}) async {
    Map<String, dynamic> parameters = {
      "amount": numQuestions.toString(),
      "type": "multiple"
    };

    Uri url = Uri.https("opentdb.com", "/api.php", parameters);
    http.Response response = await http.get(url);



    return jsonDecode(response.body);
  }
}