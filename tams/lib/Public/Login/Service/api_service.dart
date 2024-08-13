import '../Pages/Login.dart';

class APIService {
  // Dummy function to simulate an API call
  Future<String> hitLoginApi(String username, String password) async {
    // Simulate a delay to mimic a network call
    await Future.delayed(Duration(seconds: 1));

    // Check if the username and password match user or admin credentials
    if (username == 'user123' && password == 'user123') {
      return 'user'; // User login successful
    } else if (username == 'admin123' && password == 'admin123') {
      return 'admin'; // Admin login successful
    } else {
      return 'failed'; // Login failed
    }
  }
}
