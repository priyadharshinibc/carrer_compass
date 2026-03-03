import 'package:flutter/material.dart';
import 'themes/app_theme.dart';
import 'screens/Splash_screen.dart';

void main() {
  runApp(const CareerCompassApp());
}

class CareerCompassApp extends StatelessWidget {
  const CareerCompassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: SplashScreen(),
    );
  }
}
