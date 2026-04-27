import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/backend_user_service.dart';
import '../themes/app_theme.dart';
import 'profile_setup/basic_profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final BackendUserService _backendUserService;

  @override
  void initState() {
    super.initState();
    _backendUserService = BackendUserService();
  }

  void _handleGetStarted() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BasicProfileScreen(existingProfile: UserProfile()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryBlue, AppColors.tealBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(Icons.rocket_launch, size: 80, color: Colors.white),
                const SizedBox(height: 20),
                const Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Start by filling in your user details.",
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleGetStarted,
                    child: const Text("GET STARTED"),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'API: ${_backendUserService.baseUrl}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
