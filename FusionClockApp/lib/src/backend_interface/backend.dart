import 'package:http/http.dart' as http;
import 'dart:convert';

mixin BackEnd {
  String serverAddress = '';

  Future<String?> login(String email, String password) async {
    http.Response response = await http.post(Uri.parse("$serverAddress/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}));

    switch (response.statusCode) {
      case 200:
        return "";
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
        return "";
      case 400:
        return null;
      default:
        return null;
    }
  }
}
