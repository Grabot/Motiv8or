import 'dart:convert';
import '../constants.dart';
import 'package:http/http.dart' as http;

class Search {
  Future searchBro(String token, String broName, String bromotion) async {
    // maybe needed in the future?
    String urlSearch = baseUrl + 'all';
    Uri uriRegister = Uri.parse(urlSearch);

    if (bromotion == null || bromotion == " ") {
      bromotion = "";
    }

    http.Response responsePost = await http.post(
      uriRegister,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{
            'token': token,
          }),
    );
    Map<String, dynamic> registerResponse = jsonDecode(responsePost.body);
    if (registerResponse.containsKey("result")) {
      bool result = registerResponse["result"];
      if (result) {
        return result;
      }
    }
    return "an unknown error has occurred";
  }
}
