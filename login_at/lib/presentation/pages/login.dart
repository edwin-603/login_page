import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback toggleView;
  final Key? key;

  const LoginPage({required this.toggleView, this.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  FlutterTts flutterTts = FlutterTts();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  // Method to speak the given text
  Future<void> _speak(String text) async {
    await flutterTts.setLanguage('ta_IN');
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.blue,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _speak('Welcome back');
                          },
                          child: Text('welcome_back'.tr, style: TextStyle(color: Colors.white, fontSize: 24)),
                        ),
                        GestureDetector(
                          onTap: () {
                            _speak('Don\'t have an account?');
                          },
                          child: Text('not_have_account'.tr, style: TextStyle(color: Colors.white, fontSize: 14)),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: widget.toggleView,
                          child: Text('sign_up'.tr),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _speak('Login to your account');
                            },
                            child: Text('login_to_account'.tr, style: TextStyle(fontSize: 24)),
                          ),
                          IconButton(
                            onPressed: () {
                              _speak('Sign in with Google');
                              // Sign-In Logic
                            },
                            icon: Icon(Icons.g_mobiledata, color: Colors.red),
                            iconSize: 30,
                          ),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              _speak('Or login with your email and password');
                            },
                            child: Text(
                              'or login with your email and password'.tr,
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
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
                          SizedBox(height: 20),
                          TextFormField(
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
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // login logic
                                _speak('Logging in...');
                              }
                            },
                            child: Text('login'.tr),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _speak('Forgot password?');
                            },
                            child: Text('forgot_password'.tr),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 20,
            right: 20,
            child: PopupMenuButton<Locale>(
              icon: Icon(Icons.language),
              onSelected: (locale) {
                _speak('Language changed to ${locale.languageCode}');
                Get.updateLocale(locale);
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
