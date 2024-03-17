import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fusionclock/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:intl/intl.dart';

import '../ErrorBar/error_bar.dart';
import '../models/alarm.dart';
import '../models/sharedAlarm.dart';
import '../models/userFriend.dart';

mixin BackEnd {
  String serverAddress = 'https://xfrktmh0-7240.uks1.devtunnels.ms';

  Future<bool> login(String email, String password) async {
    http.Response response = await http.get(Uri.parse(
        "$serverAddress/api/attemptLogin?username=$email&password=$password"));

    if (response.statusCode != 200) return false;

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
    if (auth == null) {
      return null;
    }
    var encodedAuth = Uri.encodeComponent(auth);
    http.Response response = await http.get(Uri.parse(
        "$serverAddress/api/Alarm/GetAll?authentication=$encodedAuth"));
    final alarms = jsonDecode(response.body) as List<dynamic>;
    List<Alarm> alarmObjects = [];
    for (var alarm in alarms) {
      final user = alarm['user'];
      alarmObjects.add(new Alarm(
          alarm['id'],
          alarm['timesAccepted'],
          DateTime.parse(alarm['time']),
          alarm['daysSet'],
          User(user['gems'], user['userName'])));
    }
    return alarmObjects;
  }

  Future<SharedAlarm?> getSharedAlarmCount(int alarmId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = await prefs.getString("auth");
    if (auth == null) return null;
    var encodedAuth = Uri.encodeComponent(auth);
    http.Response response = await http.get(Uri.parse(
        "$serverAddress/api/Alarm/GetSharedAlarms/$alarmId?authentication=$encodedAuth"));
    var json = jsonDecode(response.body);
    var names = json["names"] as List<dynamic>;
    List<dynamic> emojis = json["emojis"] as List<dynamic>;
    return SharedAlarm(names.length, emojis);
  }

  Future<List<UserFriend>?> searchUsers(String searchTerm) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = await prefs.getString("auth");
    if (auth == null) return null;
    var encodedAuth = Uri.encodeComponent(auth);
    var encodedSearchTerm = Uri.encodeComponent(searchTerm);
    http.Response response = await http.get(Uri.parse(
        "$serverAddress/api/Friends/Search/$encodedSearchTerm?authentication=$encodedAuth"));
    final possibleFriends = jsonDecode(response.body) as List<dynamic>;
    List<UserFriend> users = [];
    for (var pfriend in possibleFriends) {
      users.add(UserFriend(pfriend["userId"], pfriend["userName"],
          pfriend["isFriend"] == "true"));
    }
    return users;
  }

  Future<List<UserFriend>?> getFriends() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = await prefs.getString("auth");
    if (auth == null) return null;
    var encodedAuth = Uri.encodeComponent(auth);
    http.Response response = await http.get(Uri.parse(
        "$serverAddress/api/Friends/GetAll?authentication=$encodedAuth"));
    final possibleFriends = jsonDecode(response.body) as List<dynamic>;
    List<UserFriend> users = [];
    for (var pfriend in possibleFriends) {
      users.add(UserFriend(pfriend["id"], pfriend["userName"], true));
    }
    return users;
  }

  Future<bool> sendFriendRequest(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = await prefs.getString("auth");
    if (auth == null) return false;
    var encodedAuth = Uri.encodeComponent(auth);
    var userId = Uri.encodeComponent(id);
    http.Response response = await http.post(Uri.parse(
        "$serverAddress/api/Friends/SendRequest/$userId?authentication=$encodedAuth"));
    return response.statusCode == 200;
  }

  Future<bool>? acceptFriendRequest(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = await prefs.getString("auth");
    if (auth == null) return false;
    var encodedAuth = Uri.encodeComponent(auth);
    http.Response response = await http.post(Uri.parse(
        "$serverAddress/api/Friends/AcceptRequest/$id?authentication=$encodedAuth"));
    return response.statusCode == 200;
  }

  Future<bool> ringAlarm(int alarmId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = await prefs.getString("auth");
    if (auth == null) return false;
    var encodedAuth = Uri.encodeComponent(auth);
    http.Response response = await http.put(Uri.parse(
        "$serverAddress/api/Alarm/TriggerAlarm/$alarmId?authentication=$encodedAuth"));
    return true;
  }

  Future<bool> stopAlarm(int alarmId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = await prefs.getString("auth");
    if (auth == null) return false;
    var encodedAuth = Uri.encodeComponent(auth);
    http.Response response = await http.put(Uri.parse(
        "$serverAddress/api/Alarm/StopAlarm/$alarmId?authentication=$encodedAuth"));
    return true;
  }

  Future<bool> createAlarm(DateTime alarmTime) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = await prefs.getString("auth");
    if (auth == null) return false;
    var encodedAuth = Uri.encodeComponent(auth);
    http.Response response = await http.post(
        Uri.parse("$serverAddress/api/Alarm?authentication=$encodedAuth"));
    return response.statusCode == 200;
  }

  Future<bool> deleteAlarm(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = await prefs.getString("auth");
    if (auth == null) return false;
    var encodedAuth = Uri.encodeComponent(auth);
    http.Response response = await http.delete(
        Uri.parse("$serverAddress/api/Alarm/$id?authentication=$encodedAuth"));
    return response.statusCode == 200;
  }

  Future<Alarm?> updateAlarmTime(int alarmId, TimeOfDay newTime) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = await prefs.getString("auth");
    if (auth == null) return null;
    var encodedAuth = Uri.encodeComponent(auth);
    var encodedTime = Uri.encodeComponent(formatToASPNET(newTime));
    http.Response response = await http.put(Uri.parse(
        "$serverAddress/api/Alarm/SetAlarmTime/$alarmId?newTime=$encodedTime&authentication=$encodedAuth"));
    if (response.statusCode != 200) return null;
    final alarm = jsonDecode(response.body);
    final user = alarm['user'];
    return new Alarm(
        alarm['id'],
        alarm['timesAccepted'],
        DateTime.parse(alarm['time']),
        alarm['daysSet'],
        User(user['gems'], user['userName']));
  }

  String formatToASPNET(TimeOfDay timeOfDay) {
    return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}:00';
  }

  Future<bool> sendEmoji(int emoji) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = await prefs.getString("auth");
    if (auth == null) return false;
    var encodedAuth = Uri.encodeComponent(auth);
    http.Response response = await http.post(Uri.parse(
        "$serverAddress/api/Alarm/SendEmoji/$emoji?authentication=$encodedAuth"));
    return response.statusCode == 200;
  }
}
