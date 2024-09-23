import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_at/Aahaar/aadhaar_scan.dart';
import 'presentation/animations/animation.dart';
import 'utils/translation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: AppTranslations(),
      locale: Locale('en', 'US'),
      fallbackLocale: Locale('en', 'US'),
      title: 'Flutter Animated Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: AnimatedLoginScreen(),
      home: AadhaarScanDetailsPage(),
    );
  }
}
