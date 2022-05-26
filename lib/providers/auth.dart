import 'package:flutter/widgets.dart';
import 'package:my_shop/services/auth_service.dart';

class Auth with ChangeNotifier {
  final IAuthService authService;
  String? _token;
  DateTime? _expireDate;
  String? _userId;

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

  void _onAuthenticateSuccessfuly(Map<String, dynamic> data) {
    _token = data['idToken'];
    _userId = data['localId'];
    _expireDate =
        DateTime.now().add(Duration(seconds: int.parse(data['expiresIn'])));
    notifyListeners();
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
