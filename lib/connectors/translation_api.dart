import 'package:translation_app/model/translation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TranslationApi {
  static const String endpointServer = 'api.tartunlp.ai';
  static const String endpointParam = '/translation/v2';
  static Future<String> fetchTranslation(Translation translation) async {
    Map<String, String> requestBody = Map();
    requestBody["text"] = translation.originalText;
    requestBody["src"] = translation.originalLanguage;
    requestBody["tgt"] = translation.targetLanguage;
    requestBody["domain"] = "fml";
    String json = jsonEncode(requestBody);
    http.Response response = await http.post(
        Uri.https(endpointServer, endpointParam),
        headers: {"Content-Type": "application/json"},
        body: json);
    Map<String, dynamic> responseMap = jsonDecode(response.body);
    return responseMap["result"];
  }
}
