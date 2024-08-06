import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    {'label': 'Gender', 'value': 'Male'},
    {'label': 'District', 'value': 'DistrictName'},
    {'label': 'Postal Code', 'value': '123456'},
    {'label': 'Address', 'value': '123 Main St'},
    {'label': 'Email', 'value': 'john.doe@example.com'},
    {'label': 'Mobile Number', 'value': '+1234567890'},
    {'label': 'Active Status', 'value': 'Active'},
  ];

  late final List<TextEditingController> _controllers;
  late final List<String> _initialValues;

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
    final bool? confirm = await AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: 'Save Changes',
      desc: 'Are you sure you want to save changes?',
      btnCancelOnPress: () {
        setState(() {
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
                Expanded(
                  child: ListView.builder(
                    itemCount: _fieldData.length,
                    itemBuilder: (context, index) {
                      final label = _fieldData[index]['label']!;
                      final value = _controllers[index].text;

                      TextInputType keyboardType;
                      bool isObscure = false;
                      String? Function(String?)? validator;

                      switch (label) {
                        case 'Email':
                          keyboardType = TextInputType.emailAddress;
                          validator = (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          };
                          break;
                        case 'Mobile Number':
                          keyboardType = TextInputType.phone;
                          validator = (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                              return 'Please enter a valid 10-digit mobile number';
                            }
                            return null;
                          };
                          break;
                        case 'Active Status':
                          keyboardType = TextInputType.text;
                          break;
                        default:
                          keyboardType = TextInputType.text;
                      }

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _controllers[index],
                            keyboardType: keyboardType,
                            obscureText: isObscure,
                            validator: validator,
                            enabled: _isEditing,
                            decoration: InputDecoration(
                              labelText: label,
                              labelStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: _isEditing
                                        ? Colors.blue
                                        : Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: _isEditing
                                        ? Colors.grey
                                        : Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
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

  void _handleLogout(BuildContext context) async {
    final result = await AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: 'Logout',
      desc: 'Are you sure you want to log out?',
      btnCancelOnPress: () {
        // Do nothing on cancel
      },
      btnOkOnPress: () async {
        // Clear user data from shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        // Navigate to the login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
    ).show();
  }
}
