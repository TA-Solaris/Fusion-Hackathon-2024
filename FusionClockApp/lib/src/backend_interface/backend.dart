import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

import '../models/alarm.dart';

mixin BackEnd {
  String serverAddress = 'https://xfrktmh0-7240.uks1.devtunnels.ms';

  Future<bool> login(String email, String password) async {
    http.Response response = await http.get(
        Uri.parse("$serverAddress/api/attemptLogin?username=$email&password=$password"));

    if (response.statusCode != 200)
      return false;
    
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth", response.body);
    return true;
  }

  Future<bool> register(String email, String password) async {
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
        return false;
      default:
        return false;
    }
  }

  Future<List<Alarm>?> getAlarms() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = await prefs.getString("auth");
    if (auth == null)
      return null;
    var encodedAuth = Uri.encodeComponent(auth);
    http.Response response = await http.get(
        Uri.parse("$serverAddress/api/Alarm/GetAll?authentication=$encodedAuth"));
    print(auth);
    print(response.body);
  }

}
