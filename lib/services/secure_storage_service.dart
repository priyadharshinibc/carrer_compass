import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

/// Secure Storage Service
/// Handles secure storage and retrieval of sensitive user data
/// Can be extended to use flutter_secure_storage or similar packages
class SecureStorageService {
  static const String _userProfileKey = 'user_profile_secure';
  static const String _userPreferencesKey = 'user_preferences';
  static const String _educationHistoryKey = 'education_history';
  static const String _careerGoalsKey = 'career_goals';
  static const String _userDataEncryptionKey = 'user_data_encryption_key';

  Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  /// Save user profile securely
  Future<bool> saveUserProfile(UserProfile profile) async {
    try {
      final jsonData = jsonEncode(profile.toJson());
      // Encrypt data (basic implementation - can be enhanced)
      final encryptedData = _encryptData(jsonData);
      final prefs = await _prefs();
      await prefs.setString(_userProfileKey, encryptedData);
      return true;
    } catch (e) {
      debugPrint('Error saving user profile: $e');
      return false;
    }
  }

  /// Retrieve user profile securely
  Future<UserProfile?> getUserProfile() async {
    try {
      final prefs = await _prefs();
      final encryptedData = prefs.getString(_userProfileKey);
      if (encryptedData == null) return null;

      // Decrypt data
      final jsonData = _decryptData(encryptedData);
      final jsonMap = jsonDecode(jsonData) as Map<String, dynamic>;
      return UserProfile.fromJson(jsonMap);
    } catch (e) {
      debugPrint('Error retrieving user profile: $e');
      return null;
    }
  }

  /// Save user preferences
  Future<bool> saveUserPreferences({
    required List<String> skills,
    required List<String> interests,
    required List<String> languages,
    required List<String> preferredIndustries,
  }) async {
    try {
      final preferences = {
        'skills': skills,
        'interests': interests,
        'languages': languages,
        'preferredIndustries': preferredIndustries,
      };
      final jsonData = jsonEncode(preferences);
      final encryptedData = _encryptData(jsonData);
      final prefs = await _prefs();
      await prefs.setString(_userPreferencesKey, encryptedData);
      return true;
    } catch (e) {
      debugPrint('Error saving preferences: $e');
      return false;
    }
  }

  /// Save education history
  Future<bool> saveEducationHistory(List<Education> educationHistory) async {
    try {
      final data = educationHistory.map((e) => e.toJson()).toList();
      final jsonData = jsonEncode(data);
      final encryptedData = _encryptData(jsonData);
      final prefs = await _prefs();
      await prefs.setString(_educationHistoryKey, encryptedData);
      return true;
    } catch (e) {
      debugPrint('Error saving education history: $e');
      return false;
    }
  }

  /// Save career goals
  Future<bool> saveCareerGoals(List<CareerGoal> careerGoals) async {
    try {
      final data = careerGoals.map((g) => g.toJson()).toList();
      final jsonData = jsonEncode(data);
      final encryptedData = _encryptData(jsonData);
      final prefs = await _prefs();
      await prefs.setString(_careerGoalsKey, encryptedData);
      return true;
    } catch (e) {
      debugPrint('Error saving career goals: $e');
      return false;
    }
  }

  /// Clear user data (for logout)
  Future<bool> clearUserData() async {
    try {
      final prefs = await _prefs();
      await prefs.remove(_userProfileKey);
      await prefs.remove(_userPreferencesKey);
      await prefs.remove(_educationHistoryKey);
      await prefs.remove(_careerGoalsKey);
      return true;
    } catch (e) {
      debugPrint('Error clearing user data: $e');
      return false;
    }
  }

  /// Check if user profile exists
  Future<bool> hasUserProfile() async {
    final prefs = await _prefs();
    return prefs.containsKey(_userProfileKey);
  }

  /// Basic encryption (XOR with key) - For enhanced security, use proper encryption
  String _encryptData(String data) {
    // This is a simple implementation. For production, use proper encryption
    // such as encrypt package or flutter_secure_storage
    final bytes = utf8.encode(data);
    final keyBytes = utf8.encode(_userDataEncryptionKey);
    final encrypted = <int>[];

    for (int i = 0; i < bytes.length; i++) {
      encrypted.add(bytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return base64Encode(encrypted);
  }

  /// Basic decryption (XOR with key)
  String _decryptData(String encryptedData) {
    // This is a simple implementation. For production, use proper encryption
    final encrypted = base64Decode(encryptedData);
    final keyBytes = utf8.encode(_userDataEncryptionKey);
    final decrypted = <int>[];

    for (int i = 0; i < encrypted.length; i++) {
      decrypted.add(encrypted[i] ^ keyBytes[i % keyBytes.length]);
    }

    return utf8.decode(decrypted);
  }

  /// Validate sensitive data before saving
  bool validateUserData(UserProfile profile) {
    // Email validation
    if (profile.email != null && !_isValidEmail(profile.email!)) {
      return false;
    }

    // Phone validation
    if (profile.phoneNumber != null &&
        !_isValidPhoneNumber(profile.phoneNumber!)) {
      return false;
    }

    return true;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhoneNumber(String phone) {
    // Remove non-digit characters
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    // Basic validation: 10-15 digits
    return digits.length >= 10 && digits.length <= 15;
  }
}
