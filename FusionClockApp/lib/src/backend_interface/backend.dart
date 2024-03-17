import 'package:http/http.dart' as http;
import 'dart:convert';

mixin BackEnd {
  String serverAddress = 'https://xfrktmh0-7240.uks1.devtunnels.ms';

  Future<String?> login(String email, String password) async {
    http.Response response = await http.post(
        Uri.parse("$serverAddress/login?useCookies=true"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': 'http://localhost',
          'Access-Control-Allow-Credentials': 'true',
          'Access-Control-Expose-Headers': 'true',
        },
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}));

    switch (response.statusCode) {
      case 200:
        var split = response.body.split("BODY:");
        var newSplit = split[0].split(";");
        for (var thing in newSplit)
        {
          if (thing.startsWith("Set-Cookie:.AspNetCore.Identity.Application="))
          {
            var cookie = thing.substring(44);
            return cookie;
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
