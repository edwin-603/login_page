import 'package:flutter/material.dart';

import '../pages/login.dart';
import '../pages/sign_up.dart';

class AnimatedLoginScreen extends StatefulWidget {
  @override
  _AnimatedLoginScreenState createState() => _AnimatedLoginScreenState();
}

class _AnimatedLoginScreenState extends State<AnimatedLoginScreen> {
  bool showLoginPage = true;

  void toggleView() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final offsetAnimation = Tween<Offset>(
            begin: showLoginPage ? Offset(-1.0, 0.0) : Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        child: showLoginPage
            ? LoginPage(toggleView: toggleView, key: ValueKey('LoginPage'))
            : SignUpPage(toggleView: toggleView, key: ValueKey('SignUpPage')),
      ),
    );
  }
}
