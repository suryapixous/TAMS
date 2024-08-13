import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tams/Public/Appbar/BottomNavigationBar.dart';
import 'package:tams/Public/Login/Pages/Forget_password.dart';
import 'package:tams/Public/MYcustomWidgets/Customwidgets.dart';
import 'package:tams/Public/Login/Service/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false; // Track loading state
  final APIService _apiService = APIService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? isLoggedIn = prefs.getBool('isLoggedIn');
    final String userRole =
        prefs.getString('userRole') ?? 'user'; // Retrieve stored user role

    if (isLoggedIn == true) {
      final bool isAdmin = userRole == 'admin'; // Check if the role is 'admin'

      // Navigate to the Bottombar page, passing the isAdmin parameter
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Bottombar(isAdmin: isAdmin), // Pass isAdmin here
        ),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    setState(() {
      _isLoading = true; // Start loading animation
    });

    // Hit API with username and password
    final loginResult = await _apiService.hitLoginApi(username, password);

    setState(() {
      _isLoading = false; // Stop loading animation
    });

    if (loginResult == 'user' || loginResult == 'admin') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true); // Save login status
      await prefs.setString('userRole', loginResult); // Save user role

      final bool isAdmin = loginResult == 'admin';

      // Navigate to the next page if login is successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Bottombar(isAdmin: isAdmin), // Pass the isAdmin parameter
        ),
      );
    } else {
      // Show an error message if login is unsuccessful with a delay
      Future.delayed(const Duration(milliseconds: 5), () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Please try again.'),
            backgroundColor: Colors.red,
            duration:
                Duration(milliseconds: 400), // Shorter duration for SnackBar
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom top curved container with logo and text
          ClipPath(
            clipper: TopCurveClipper(),
            child: Container(
              height: 300,
              color: Theme.of(context).colorScheme.primary,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Circular logo container
                    ClipOval(
                      child: Image.asset(
                        'Assets/Images/logo-search-grid-2x.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'TAMS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Container(
                    width: 500,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Username text field
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey, // Default border color
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .primaryColor, // Default focused border color
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Password text field with visibility toggle
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey, // Default border color
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .primaryColor, // Default focused border color
                              ),
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                        ),
                        const SizedBox(height: 20),
                        // Submit button with loading animation
                        ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                            backgroundColor: Colors.amberAccent, // Button color
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3.0,
                                  ),
                                )
                              : const Icon(Icons.arrow_forward),
                        ),
                        const SizedBox(height: 20),
                        // Forgot password button
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage()),
                            );
                          },
                          child: const Text('Forgot Password?'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
