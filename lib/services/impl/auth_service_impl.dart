import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_shop/exceptions/http_exception.dart';
import 'package:my_shop/services/auth_service.dart';

class AuthServiceImpl implements IAuthService {
  static const String _apiKey = String.fromEnvironment("API_KEY");
  final String _baseUrl = 'https://identitytoolkit.googleapis.com/v1';

  Future<Map<String, dynamic>> _authenticate(
      String email, String password, String method) async {
    Uri url = Uri.parse('$_baseUrl/accounts:$method?key=$_apiKey');
    try {
      final http.Response response =
          await http.post(url, body: _encodeBody(email, password));
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['error'] != null) {
        throw HttpException(json.decode(response.body)['error']['message']);
      }
      return data;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> signUp(String email, String password) {
    return _authenticate(email, password, 'signUp');
  }

  @override
  Future<Map<String, dynamic>> signIn(String email, String password) {
    return _authenticate(email, password, 'signInWithPassword');
  }

  String _encodeBody(String email, String password) {
    return json.encode(
        {'email': email, 'password': password, 'returnSecureToken': true});
  }
}
