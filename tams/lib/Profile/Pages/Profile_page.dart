import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Login/Pages/Forget_password.dart';
import '../../Login/Pages/Login.dart';
import '../../MYcustomWidgets/Constant_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  bool _isEditing = false;
  bool _hasChanges = false;

  late final AnimationController _buttonAnimationController;
  late final Animation<double> _buttonAnimation;
  late final AnimationController _imageAnimationController;
  late final Animation<double> _imageAnimation;

  final List<Map<String, String>> _fieldData = [
    {'label': 'First Name', 'value': 'John'},
    {'label': 'Father Name', 'value': 'Doe'},
    {'label': 'District', 'value': 'DistrictName'},
    {'label': 'Postal Code', 'value': '123456'},
    {'label': 'Address', 'value': '123 Main St'},
    {'label': 'Email', 'value': 'john.doe@example.com'},
    {'label': 'Mobile Number', 'value': '+1234567890'},
    {'label': 'Active Status', 'value': 'Active'},
  ];

  late final List<TextEditingController> _controllers;
  late final List<String> _initialValues;

  String? _selectedGender; // Added for gender selection
  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Other'
  ]; // Gender options

  File? _profileImage;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _buttonAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
          parent: _buttonAnimationController, curve: Curves.easeInOut),
    );

    _imageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _imageAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(
          parent: _imageAnimationController, curve: Curves.easeInOut),
    );

    _controllers = _fieldData
        .map((data) => TextEditingController(text: data['value']!))
        .toList();
    _initialValues = _fieldData.map((data) => data['value']!).toList();
    for (var controller in _controllers) {
      controller.addListener(() {
        _checkForChanges();
      });
    }
    _requestPermissions();

    // Initialize gender selection based on the initial values
    _selectedGender = _fieldData[2]['value']; // Assuming Gender is at index 2
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _imageAnimationController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    final status = await [
      Permission.camera,
      Permission.storage,
    ].request();

    print('Camera permission status: ${status[Permission.camera]}');
    print('Storage permission status: ${status[Permission.storage]}');
  }

  void _checkForChanges() {
    bool hasChanges = false;
    for (int i = 0; i < _controllers.length; i++) {
      if (_controllers[i].text != _initialValues[i]) {
        hasChanges = true;
        break;
      }
    }
    setState(() {
      _hasChanges = hasChanges;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _imageAnimationController.forward().then((_) {
          setState(() {
            _profileImage = File(pickedFile.path);
          });
          _imageAnimationController.reverse();
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _onSave() async {
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: 'Save Changes',
      desc: 'Are you sure you want to save changes?',
      btnCancelOnPress: () {
        // User pressed cancel, do nothing
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No changes were made.')),
          );
          _isEditing = false;
        });
      },
      btnOkOnPress: () {
        if (_hasChanges) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Changes saved successfully.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No changes were made.')),
          );
        }
        setState(() {
          _isEditing = false;
          _hasChanges = false;
        });
      },
    ).show();
  }

  Future<void> _refreshProfile() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: appBarColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          flexibleSpace: Center(
            child: Text(
              'Profile',
              style: TextStyle(
                color: appBarTextColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _handleLogout(context),
            )
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    AnimatedBuilder(
                      animation: _imageAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _imageAnimation.value,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.blueAccent.withOpacity(0.3),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : const AssetImage(
                                          'Assets/Images/ali-morshedlou-WMD64tMfc4k-unsplash.jpg')
                                      as ImageProvider,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        );
                      },
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                ScaleTransition(
                  scale: _buttonAnimation,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0x25807878), Color(0x25807878)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        _buttonAnimationController.forward().then((_) {
                          if (_isEditing) {
                            if (_formKey.currentState?.validate() ?? false) {
                              _onSave();
                            }
                          } else {
                            setState(() {
                              _isEditing = !_isEditing;
                            });
                          }
                          _buttonAnimationController.reverse();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _isEditing ? 'Save Changes' : 'Edit Profile',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _fieldData.length,
                    itemBuilder: (context, index) {
                      final field = _fieldData[index];

                      if (field['label'] == 'Gender') {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  'Gender',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _selectedGender ?? _genderOptions[0],
                                  items: _genderOptions.map((String gender) {
                                    return DropdownMenuItem<String>(
                                      value: gender,
                                      child: Text(gender),
                                    );
                                  }).toList(),
                                  onChanged: _isEditing
                                      ? (String? newValue) {
                                          setState(() {
                                            _selectedGender = newValue;
                                            _controllers[2].text = newValue!;
                                          });
                                        }
                                      : null,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (field['label'] == 'Email') {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  field['label']!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _controllers[index],
                                  enabled: _isEditing,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  validator: (value) {
                                    final emailPattern =
                                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                                    final regExp = RegExp(emailPattern);
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an email';
                                    } else if (!regExp.hasMatch(value)) {
                                      return 'Enter a valid email';
                                    }
                                    return null; // Valid email
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (field['label'] == 'Postal Code') {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  field['label']!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _controllers[index],
                                  enabled: _isEditing,
                                  keyboardType: TextInputType.number,
                                  maxLength: 6,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a postal code';
                                    } else if (value.length != 6) {
                                      return 'Postal code must be 6 digits';
                                    }
                                    return null; // Valid postal code
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (field['label'] == 'Address') {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  field['label']!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _controllers[index],
                                  enabled: _isEditing,
                                  minLines:
                                      1, // Minimum number of lines to start with
                                  maxLines:
                                      null, // Allows the text field to expand as needed
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text(
                                field['label']!,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _controllers[index],
                                enabled: _isEditing &&
                                    !(field['label'] == 'Active Status' ||
                                        field['label'] == 'Mobile Number'),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to clear login state
  Future<void> clearLoginState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
  }

  // Logout button handler
  void _handleLogout(BuildContext context) async {
    // Show AwesomeDialog for confirmation
    final bool? confirm = await AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: 'Logout',
      desc: 'Are you sure you want to log out?',
      btnCancelOnPress: () {
        // User pressed cancel, do nothing
      },
      btnOkOnPress: () async {
        // User confirmed logout
        await clearLoginState();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
    ).show();
  }
}
