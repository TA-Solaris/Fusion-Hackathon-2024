import 'package:http/http.dart' as http;
import 'dart:convert';

mixin BackEnd {
  String serverAddress = 'https://xfrktmh0-7240.uks1.devtunnels.ms';

  Future<String?> login(String email, String password) async {
    http.Response response = await http.post(
        Uri.parse("$serverAddress/login?useCookies=true"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': serverAddress
        },
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}));

    switch (response.statusCode) {
      case 200:
        String? cookieKey = response.headers["set-cookie"];
        if (cookieKey == null) return null;
        final details = cookieKey.split(';');
        const String cookieAttribute = ".AspNetCore.Identity.Application=";
        for (int i = 0; i < details.length; i++) {
          if (details[i].startsWith(cookieAttribute)) {
            return details[i].substring(cookieAttribute.length);
          }
        }
        return null;
      case 400:
        return null;
      default:
        return null;
    }
  }

  Future<String?> register(String email, String password) async {
    http.Response response = await http.post(
        Uri.parse("$serverAddress/register"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}));

    switch (response.statusCode) {
      case 200:
        return login(email, password);
      case 400:
        return null;
      default:
        return null;
    }
  }
}
