import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';

/// Initializes Firebase safely. Call this before runApp.
Future<void> initializeFirebase() async {
  try {
    // Avoid duplicate initialization when using hot reload.
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    // Swallow initialization errors to keep the app usable offline.
    // Log them later if you have a logger attached.
  }
}
