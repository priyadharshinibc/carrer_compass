import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../services/secure_storage_service.dart';
import '../themes/app_theme.dart';
import 'home_page.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const String _splashVideoAsset = 'assets/videos/splash_intro.mp4';

  late AnimationController _controller;
  VideoPlayerController? _videoController;
  bool _didNavigate = false;
  final SecureStorageService _storageService = SecureStorageService();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _initializeSplashMedia();
  }

  Future<void> _initializeSplashMedia() async {
    try {
      final controller = VideoPlayerController.asset(
        _splashVideoAsset,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false),
      );
      await controller.initialize();
      controller.setLooping(false);
      await controller.setVolume(1.0);
      controller.play();

      controller.addListener(() {
        final value = controller.value;
        if (!value.isInitialized || _didNavigate) return;

        if (!value.isPlaying && value.position >= value.duration) {
          _navigateNext();
        }
      });

      if (!mounted) {
        controller.dispose();
        return;
      }

      setState(() {
        _videoController = controller;
      });
    } catch (_) {
      Future.delayed(const Duration(seconds: 2), _navigateNext);
    }
  }

  Future<void> _navigateNext() async {
    if (_didNavigate || !mounted) return;
    _didNavigate = true;

    final profile = await _storageService.getUserProfile();
    if (!mounted) return;

    if (profile != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(userProfile: profile)),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.softBlue,
              AppColors.tealBlue,
              AppColors.primaryBlue,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _controller,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_videoController != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      width: 220,
                      child: AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      ),
                    ),
                  )
                else
                  const SizedBox(
                    width: 220,
                    height: 220,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.goldAccent,
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                const SizedBox(height: 30),
                const Text(
                  "Career Compass",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Dream it. Plan it. Achieve it.",
                  style: TextStyle(color: AppColors.goldAccent, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _controller.dispose();
    super.dispose();
  }
}
