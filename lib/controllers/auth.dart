import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udemy_provider/models/http_exception.dart';

class Auth extends GetxController {
  RxString RxToken = ''.obs;
  DateTime _expiryDate; // 파베에서 토큰이 만료되는 시간.
  RxString RxUserId = ''.obs;
  Timer _authTimer;


  @override
  void onInit() {
    RxToken.nil();
    RxUserId.nil();
  }

  static Auth get to {
    return Get.find();
  }

  bool get isAuth {
    print('isAuth :: $RxToken');
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        RxToken.value != null) {
      return RxToken.value;
    }

    return null;
  }

  String get userId {
    return RxUserId.value;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBneGTfxqZYmkmgcXexbkCpD0LCHUGUksk';

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      print('_authenticate json encode ::::: ${json.decode(response.body)}');

      final responseBody = json.decode(response.body);
      if (responseBody['error'] != null) {
        throw HttpException(responseBody['error']['message']);
      }
      RxToken.value = responseBody['idToken'];
      RxUserId.value = responseBody['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseBody['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      update();
      final prefs = await SharedPreferences.getInstance();
      print('_expiryDate :: $_expiryDate');
      print('_expiryDate toIso8601String :: ${_expiryDate.toIso8601String()}');
      final userData = json.encode({
        'token': RxToken.value,
        'userId': RxUserId.value,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
      print('auto login setting complite.');
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(
        email, password, 'signInWithPassword'); //강의랑 다름. 강의는 verifyPassword
  }

  Future<bool> tryAutoLogin() async {
    print('try autoLogin.');
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('userData')) {
        return false;
      }
      print('try autoLogin.2');
      final extractedUserData =
          jsonDecode(prefs.getString('userData')) as Map<String, Object>;
      final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
      //exp'r'iryDate 요 한글자 틀렸는데 아무에러안나고,, 지우니까 로그인 계속되네
      print('try autoLogin..');
      if (expiryDate.isBefore(DateTime.now())) {
        return false;
      }
      RxToken.value = extractedUserData['token'];
      RxUserId.value = extractedUserData['userId'];
      _expiryDate = expiryDate;
      update();
      _autoLogout();
    } catch (e) {
      print('auto login error ::::: $e');
      return false;
    }
    print('try autoLogin...  [DONE]');
    return true;
  }

  Future<void> logout() async {
    RxUserId.value = null;
    RxToken.value = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    update();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    //prefs.clear();   // 전부~ 지우는거.
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
