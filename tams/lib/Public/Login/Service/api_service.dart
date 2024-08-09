import '../Pages/Login.dart';

class APIService {
  // Dummy function to simulate an API call
  Future<bool> hitLoginApi(String username, String password) async {
    // Simulate a delay to mimic network call
    await Future.delayed(Duration(seconds: 1));

    // Check if the username and password match "123"
    if (username == '123' && password == '123') {
      return true; // Login successful
    } else {
      return false; // Login failed
    }
  }
}
