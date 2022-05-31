import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:my_shop/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  final IAuthService authService;
  String? _token;
  DateTime? _expireDate;
  String? _userId;
  Timer? _authTime;

  Auth({required this.authService});

  bool _hasToken() {
    return _token != null && _token!.isNotEmpty;
  }

  bool _tokenHasExpired() {
    return _expireDate == null || _expireDate!.isBefore(DateTime.now());
  }

  String? get token {
    if (!_tokenHasExpired() && _hasToken()) {
      return _token!;
    }
    return null;
  }

  bool get isAuth {
    return token != null;
  }

  Future<void> logoutUser() async {
    _token = null;
    _expireDate = null;
    _userId = null;
    if (_authTime != null) {
      _authTime!.cancel();
      _authTime = null;
    }
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  void _autoLogout() {
    if (_expireDate == null) return;
    if (_authTime != null) {
      _authTime!.cancel();
    }
    final timeToExpire = _expireDate!.difference(DateTime.now()).inSeconds;
    _authTime = Timer(Duration(seconds: timeToExpire), logoutUser);
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    print(prefs.getString('userData'));
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final DateTime expiryDate =
        DateTime.parse(extractedUserData['expiryDate'] as String);
    if (expiryDate.isBefore(DateTime.now())) return false;
    _hydrateAuthState(extractedUserData);
    return expiryDate.isAfter(DateTime.now());
  }

  void _hydrateAuthState(Map<String, dynamic> persistedUserData) {
    _token = persistedUserData['token'] as String;
    _userId = persistedUserData['userId'] as String;
    _expireDate = DateTime.parse(persistedUserData['expiryDate'] as String);
    notifyListeners();
  }

  Future<void> _onAuthenticateSuccessfuly(Map<String, dynamic> data) async {
    _token = data['idToken'];
    _userId = data['localId'];
    _expireDate =
        DateTime.now().add(Duration(seconds: int.parse(data['expiresIn'])));
    _autoLogout();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
      'expiryDate': _expireDate?.toIso8601String()
    });
    prefs.setString('userData', userData);
  }

  Future<void> signup(String email, String password) async {
    try {
      _onAuthenticateSuccessfuly(await authService.signUp(email, password));
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signin(String email, String password) async {
    try {
      _onAuthenticateSuccessfuly(await authService.signIn(email, password));
    } catch (error) {
      rethrow;
    }
  }
}
