import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../Aahaar/aadhaar_scan.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback toggleView;
  final Key? key;

  const SignUpPage({required this.toggleView, this.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _setTtsLanguage(Get.locale);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _setTtsLanguage(Locale? locale) async {
    if (locale == null) return;

    String languageCode = locale.languageCode;
    String? ttsLanguage;

    switch (languageCode) {
      case 'en':
        ttsLanguage = 'en-US';
        break;
      case 'ta':
        ttsLanguage = 'ta-IN';
        break;
      default:
        ttsLanguage = 'en-US';
    }

    var availableLanguages = await flutterTts.getLanguages;
    if (availableLanguages != null && availableLanguages.contains(ttsLanguage)) {
      await flutterTts.setLanguage(ttsLanguage);
      print("TTS Language set to $ttsLanguage");
    } else {
      await flutterTts.setLanguage('en-US');
      _speak('Selected language is not supported. Falling back to English.');
    }
  }

  // Method to speak the given text
  Future<void> _speak(String text) async {
    await flutterTts.stop();
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  // Override to listen for locale changes
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setTtsLanguage(Get.locale);
  }

  // Method to handle language change and announce it
  Future<void> _handleLanguageChange(Locale locale) async {
    Get.updateLocale(locale);
    await _setTtsLanguage(locale);
    String languageSpoken = locale.languageCode == 'English' ? 'English' : 'தமிழ்';
    _speak('Language changed to $languageSpoken');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              // Left Side - Sign Up Form
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _speak('create_account'.tr);
                            },
                            child: Text('create_account'.tr, style: TextStyle(fontSize: 24)),
                          ),
                          IconButton(
                            onPressed: () {
                              _speak('Sign up with Google');
                              // Google Sign-Up Logic
                            },
                            icon: Icon(Icons.g_mobiledata_outlined, color: Colors.red),
                            iconSize: 30,
                          ),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              _speak('or sign up with your email and password'.tr);
                            },
                            child: Text(
                              'or sign up with your email and password'.tr,
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                          SizedBox(height: 20),
                          // Username Field
                          GestureDetector(
                            onLongPress: () {
                              _speak('username'.tr);
                            },
                            child: TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                hintText: 'username'.tr,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your username'.tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          // Email Field
                          GestureDetector(
                            onLongPress: () {
                              _speak('email'.tr);
                            },
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'email'.tr,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email'.tr;
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return 'Enter a valid email'.tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          // Password Field
                          GestureDetector(
                            onLongPress: () {
                              _speak('password'.tr);
                            },
                            child: TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                hintText: 'password'.tr,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _obscurePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password'.tr;
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters'.tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          // Confirm Password Field
                          GestureDetector(
                            onLongPress: () {
                              _speak('confirm_password'.tr);
                            },
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                hintText: 'confirm_password'.tr,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword = !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _obscureConfirmPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password'.tr;
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match'.tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          // Sign Up Button
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _speak('Signing up...');
                                Get.to(() => AadhaarScanDetailsPage());
                              }
                            },
                            child: Text('sign_up'.tr),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Right Side - Welcome and Login Prompt
              Expanded(
                child: Container(
                  color: Colors.blue,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _speak('welcome'.tr);
                          },
                          child: Text('welcome'.tr, style: TextStyle(color: Colors.white, fontSize: 24)),
                        ),
                        GestureDetector(
                          onTap: () {
                            _speak('Already have an account?'.tr);
                          },
                          child: Text(
                            'Already have an account?'.tr,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _speak('login'.tr);
                            widget.toggleView();
                          },
                          child: Text('login'.tr),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Language Selection Popup Menu
          Positioned(
            top: 20,
            right: 20,
            child: PopupMenuButton<Locale>(
              icon: Icon(Icons.language),
              onSelected: (Locale locale) {
                _handleLanguageChange(locale);
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<Locale>(
                    value: Locale('en', 'US'),
                    child: Row(
                      children: [
                        Icon(Icons.language, color: Colors.black),
                        SizedBox(width: 8),
                        Text('English'),
                      ],
                    ),
                  ),
                  PopupMenuItem<Locale>(
                    value: Locale('ta', 'IN'),
                    child: Row(
                      children: [
                        Icon(Icons.language, color: Colors.black),
                        SizedBox(width: 8),
                        Text('தமிழ்'),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ),
        ],
      ),
    );
  }
}
