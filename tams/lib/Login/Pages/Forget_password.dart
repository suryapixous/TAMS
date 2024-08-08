import 'package:flutter/material.dart';
import '../../MYcustomWidgets/Customwidgets.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _mobileController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  int _currentStep = 0;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _mobileController.dispose();
    _otpControllers.forEach((controller) => controller.dispose());
    _postalCodeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isMobileValid() {
    return _mobileController.text.length == 10;
  }

  bool _isOtpValid() {
    String otp = _otpControllers.map((controller) => controller.text).join();
    return otp.length == 6;
  }

  void _sendOtp() async {
    final mobile = _mobileController.text;
    if (!_isMobileValid()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Please enter a valid 10-digit mobile number.'),
          backgroundColor: Colors.red));
      return;
    }

    setState(() {
      _isLoading = true;
    });
    final isSuccess = await _sendOtpApi(mobile);
    setState(() {
      _isLoading = false;
    });

    if (isSuccess) {
      setState(() {
        _currentStep = 1;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Failed to send OTP. Please try again.'),
          backgroundColor: Colors.red));
    }
  }

  Future<bool> _sendOtpApi(String mobile) async {
    await Future.delayed(const Duration(seconds: 2));
    return true; // Simulate success
  }

  void _verifyOtp() async {
    final otp = _otpControllers.map((controller) => controller.text).join();
    if (!_isOtpValid()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Please enter a valid 6-digit OTP.'),
          backgroundColor: Colors.red));
      return;
    }

    setState(() {
      _isLoading = true;
    });
    final isSuccess = await _verifyOtpApi(otp);
    setState(() {
      _isLoading = false;
    });

    if (isSuccess) {
      setState(() {
        _currentStep = 2;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Invalid OTP. Please try again.'),
          backgroundColor: Colors.red));
    }
  }

  Future<bool> _verifyOtpApi(String otp) async {
    await Future.delayed(const Duration(seconds: 2));
    return true; // Simulate success
  }

  void _resetPassword() async {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Passwords do not match.'),
          backgroundColor: Colors.red));
      return;
    }

    setState(() {
      _isLoading = true;
    });
    final isSuccess = await _resetPasswordApi(newPassword);
    setState(() {
      _isLoading = false;
    });

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Password reset successfully.'),
          backgroundColor: Colors.green));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Failed to reset password. Please try again.'),
          backgroundColor: Colors.red));
    }
  }

  Future<bool> _resetPasswordApi(String newPassword) async {
    await Future.delayed(const Duration(seconds: 2));
    return true; // Simulate success
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipPath(
            clipper: TopCurveClipper(),
            child: Container(
              height: 300,
              color: Theme.of(context).colorScheme.primary,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'Assets/Images/logo-search-grid-2x.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _currentStep == 0
                          ? 'Forgot Password'
                          : _currentStep == 1
                              ? 'Enter OTP'
                              : 'Reset Password',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
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
                            offset: const Offset(0, 10)),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (_currentStep == 0) ...[
                          TextField(
                            controller: _mobileController,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            decoration: InputDecoration(
                              labelText: 'Mobile Number',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {});
                              if (value.length > 10) {
                                _mobileController.text = value.substring(0, 10);
                                _mobileController.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(
                                      offset: _mobileController.text.length),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _isLoading || !_isMobileValid()
                                ? null
                                : _sendOtp,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                              backgroundColor: Colors.amberAccent,
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 3.0),
                                  )
                                : const Icon(Icons.arrow_forward),
                          ),
                        ] else if (_currentStep == 1) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(6, (index) {
                              return Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: TextField(
                                    controller: _otpControllers[index],
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      counterText: '',
                                      hintText: '',
                                    ),
                                    textAlign: TextAlign.center,
                                    onChanged: (value) {
                                      if (value.length == 1) {
                                        FocusScope.of(context).nextFocus();
                                        setState(() {});
                                      }
                                    },
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _isLoading || !_isOtpValid()
                                ? null
                                : _verifyOtp,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                              backgroundColor: Colors.amberAccent,
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 3.0),
                                  )
                                : const Icon(Icons.arrow_forward),
                          ),
                        ] else if (_currentStep == 2) ...[
                          TextField(
                            controller: _newPasswordController,
                            obscureText: _obscureNewPassword,
                            decoration: InputDecoration(
                              labelText: 'New Password',
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureNewPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureNewPassword = !_obscureNewPassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _resetPassword,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                              backgroundColor: Colors.amberAccent,
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 3.0),
                                  )
                                : const Icon(Icons.arrow_forward),
                          ),
                        ],
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
