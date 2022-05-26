import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_shop/services/auth_service.dart';

class AuthServiceImpl implements IAuthService {
  static const String _apiKey = String.fromEnvironment("API_KEY");
  final String _baseUrl = 'https://identitytoolkit.googleapis.com/v1';

  Future<void> _authenticate(
      String email, String password, String method) async {
    Uri url = Uri.parse('$_baseUrl/accounts:$method?key=$_apiKey');
    try {
      final http.Response response =
          await http.post(url, body: _encodeBody(email, password));
      print(json.decode(response.body));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  @override
  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  String _encodeBody(String email, String password) {
    return json.encode(
        {'email': email, 'password': password, 'returnSecureToken': true});
  }
}
