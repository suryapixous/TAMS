import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  bool _hasChanges = false;

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

  Future<void> _requestPermissions() async {
    final status = await [
      Permission.camera,
      Permission.storage,
    ].request();

    print('Camera permission status: ${status[Permission.camera]}');
    print('Storage permission status: ${status[Permission.storage]}');
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
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
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _onSave() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Changes'),
        content: const Text('Are you sure you want to save changes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (confirm == true) {
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
    } else if (confirm == false) {
      setState(() {
        _isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.blueAccent.withOpacity(0.3),
                    child: CircleAvatar(
                      radius: 65,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage(
                                  'assets/images/ali-morshedlou-WMD64tMfc4k-unsplash.jpg')
                              as ImageProvider,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 20,
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
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blueAccent, Colors.lightBlueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (_isEditing) {
                      if (_formKey.currentState?.validate() ?? false) {
                        _onSave();
                      }
                    } else {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    }
                  },
                  child: Text(_isEditing ? 'Save Changes' : 'Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
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
                          final emailRegex = RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                          if (value == null || !emailRegex.hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        };
                        break;
                      case 'Mobile Number':
                        keyboardType = TextInputType.phone;
                        break;
                      case 'Address':
                        keyboardType = TextInputType.multiline;
                        break;
                      case 'Postal Code':
                        keyboardType = TextInputType.number;
                        break;
                      default:
                        keyboardType = TextInputType.text;
                        break;
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: _isEditing
                          ? TextFormField(
                              controller: _controllers[index],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                labelText: label,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 12,
                                ),
                              ),
                              keyboardType: keyboardType,
                              obscureText: isObscure,
                              maxLines: label == 'Address' ? null : 1,
                              validator: validator,
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    label,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Expanded(
                                    child: Text(
                                      value,
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
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
    );
  }
}
