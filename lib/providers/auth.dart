import 'package:flutter/widgets.dart';
import 'package:my_shop/services/auth_service.dart';

class Auth with ChangeNotifier {
  final IAuthService authService;
  late String _token;
  late DateTime _expireDate;
  late String _userId;

  Auth({required this.authService});

  Future<void> signup(String email, String password) async {
    try {
      await authService.signUp(email, password);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signin(String email, String password) async {
    try {
      await authService.signIn(email, password);
    } catch (error) {
      rethrow;
    }
  }
}
