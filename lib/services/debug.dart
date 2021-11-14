import 'dart:convert';
import '../constants.dart';
import 'package:http/http.dart' as http;

class Debug {
  Future debugPost(String debug) async {
    // maybe needed in the future?
    String urlDebug = debugUrl;
    Uri uriDebug = Uri.parse(urlDebug);

    http.Response responsePost = await http.post(
      uriDebug,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{
            'debug': debug
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