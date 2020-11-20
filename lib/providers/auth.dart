import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udemy_provider/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate; // 파베에서 토큰이 만료되는 시간.
  String _userId;
  Timer _authTimer;
  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  String get userId {
    return _userId;
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
      _token = responseBody['idToken'];
      _userId = responseBody['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseBody['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      print('_expiryDate :: $_expiryDate');
      print('_expiryDate toIso8601String :: ${_expiryDate.toIso8601String()}');
      final userData = json.encode({
        'token' : _token,
        'userId' : _userId,
        'expiryDate' : _expiryDate.toIso8601String(),
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
    return _authenticate(email, password, 'signInWithPassword');  //강의랑 다름. 강의는 verifyPassword
  }

  Future<bool> autoLogin() async {
    print('try autoLogin.');
    try {final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')) {
      return false;
    }
    print('try autoLogin.2');
    final extractedUserData = jsonDecode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    //exp'r'iryDate 요 한글자 틀렸는데 아무에러안나고,, 지우니까 로그인 계속되네
    print('try autoLogin..');
    if(expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogin();}
    catch (e) {
      print('auto login error ::::: $e');
      return false;
    }
    print('try autoLogin...  [DONE]');
    return true;
  }

  Future<void> logout() async {
    _userId = null;
    _token = null;
    _expiryDate = null;
    if(_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    //prefs.clear();   // 전부~ 지우는거.
  }

  void _autoLogout() {
    if(_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout );
  }
}
