import 'database_helper.dart';

class AuthService {
  Future<bool> login(String email, String password) async {
    final user = await DatabaseHelper().getUser(email, password);
    return user != null;
  }

  Future<String?> register(String email, String password) async {
    try {
      await DatabaseHelper().registerUser(email, password);
      return null; // Registration successful, no error message needed
    } catch (e) {
      return 'Registration failed: ${e.toString()}';
    }
  }
}
