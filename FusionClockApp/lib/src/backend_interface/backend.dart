import 'package:http/http.dart' as http;
import 'dart:convert';

mixin BackEnd {
  String serverAddress = '';

  Future<http.Response> login(String email, String password) {
    return http.post(Uri.parse("$serverAddress/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}));
  }
}
