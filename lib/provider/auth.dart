import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exception/http_exception.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _auhtimer;

  bool get isAuth {
    if (token == 'null') {
      return false;
    } else {
      return true;
    }
  }

  String get userId {
    return _userId as String;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return 'null';
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:${urlSegment}?key=AIzaSyCV0kz9kHoy2sqJ9pLxXrI6ywPFyUVHq28');

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpExeption(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
            seconds: int.parse(
          responseData['expiresIn'],
        )),
      );

      _autoLogout();
      print('___________________');
      print(_token);
      print(_expiryDate);
      print(_userId);

      // print(responseData);
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      prefs.setString('userdata', userData);
    } catch (error) {
      throw error;
    }

    // print(json.decode(response.body));
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return false;
    }

    final extractedUserData = json.decode(prefs.getString('userdata') as String)
        as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = extractedUserData['expiryDate'];

    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout() async {
    _token = 'null';
    _expiryDate = null;
    _userId = '';
    if (_auhtimer != null) {
      _auhtimer!.cancel();
      _auhtimer = null;
    }

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    // prefs.remove('userdata');
    prefs.clear();
  }

  void _autoLogout() {
    if (_auhtimer != null) {
      _auhtimer!.cancel();
    }
    final timetoExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _auhtimer = Timer(Duration(seconds: timetoExpiry), logout);
  }
}
