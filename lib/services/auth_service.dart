abstract class IAuthService {
  Future<Map<String, dynamic>> signUp(String email, String password);
  Future<Map<String, dynamic>> signIn(String email, String password);
}
