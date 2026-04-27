import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/user_profile.dart';

class BackendUserService {
  BackendUserService({String? baseUrl})
    : _baseUrl = _normalizeBaseUrl(baseUrl ?? _defaultBaseUrl());

  final String _baseUrl;
  static const Duration _requestTimeout = Duration(seconds: 12);

  String get baseUrl => _baseUrl;

  static const String _configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  Uri _usersUri() => Uri.parse('$_baseUrl/api/users');

  Uri _userUri(String id) => Uri.parse('$_baseUrl/api/users/$id');

  static String _defaultBaseUrl() {
    if (_configuredBaseUrl.trim().isNotEmpty) return _configuredBaseUrl;

    if (kIsWeb) return 'http://localhost:3000';

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:3000';
      default:
        return 'http://127.0.0.1:3000';
    }
  }

  static String _normalizeBaseUrl(String input) {
    var url = input.trim();

    // Tolerate common typing mistakes such as `hhtp://` and `;` before port.
    if (url.startsWith('hhtp://')) {
      url = url.replaceFirst('hhtp://', 'http://');
    }
    url = url.replaceAll(';', ':');

    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }

    return url;
  }

  Future<UserProfile?> findByEmail(String email) async {
    final users = await listUsers();
    final normalized = email.trim().toLowerCase();

    for (final user in users) {
      final userEmail = user.email?.trim().toLowerCase();
      if (userEmail == normalized) {
        return user;
      }
    }

    return null;
  }

  Future<List<UserProfile>> listUsers() async {
    try {
      final response = await http.get(_usersUri()).timeout(_requestTimeout);
      final body = _decodeJsonObject(response.body);

      if (response.statusCode != 200) {
        throw Exception(
          '${body['message'] ?? 'Failed to fetch users'} (status: ${response.statusCode})',
        );
      }

      final data = body['data'];
      if (data is! List) return const [];

      return data
          .whereType<Map<String, dynamic>>()
          .map(_toUserProfile)
          .toList();
    } on TimeoutException {
      throw Exception(_networkHint('Request timed out'));
    } on SocketException {
      throw Exception(_networkHint('Could not connect to server'));
    }
  }

  Future<UserProfile> upsertUserProfile(UserProfile profile) async {
    if (profile.userId != null && profile.userId!.isNotEmpty) {
      return _updateUser(profile);
    }

    final email = profile.email?.trim();
    if (email != null && email.isNotEmpty) {
      final existing = await findByEmail(email);
      if (existing?.userId != null && existing!.userId!.isNotEmpty) {
        return _updateUser(profile.copyWith(userId: existing.userId));
      }
    }

    return _createUser(profile);
  }

  Future<void> deleteUser(String id) async {
    try {
      final response = await http.delete(_userUri(id)).timeout(_requestTimeout);

      if (response.statusCode == 204 || response.statusCode == 200) {
        return;
      }

      final body = _decodeJsonObject(response.body);
      throw Exception(
        '${body['message'] ?? 'Failed to delete user'} (status: ${response.statusCode})',
      );
    } on TimeoutException {
      throw Exception(_networkHint('Request timed out'));
    } on SocketException {
      throw Exception(_networkHint('Could not connect to server'));
    }
  }

  Future<UserProfile> _createUser(UserProfile profile) async {
    try {
      final response = await http
          .post(
            _usersUri(),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(_toBackendPayload(profile)),
          )
          .timeout(_requestTimeout);

      final body = _decodeJsonObject(response.body);

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception(
          '${body['message'] ?? 'Failed to create user'} (status: ${response.statusCode}) body: ${response.body}',
        );
      }

      final data = body['data'];
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid response from server');
      }

      return _toUserProfile(data);
    } on TimeoutException {
      throw Exception(_networkHint('Request timed out'));
    } on SocketException {
      throw Exception(_networkHint('Could not connect to server'));
    }
  }

  Future<UserProfile> _updateUser(UserProfile profile) async {
    try {
      final response = await http
          .put(
            _userUri(profile.userId!),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(_toBackendPayload(profile)),
          )
          .timeout(_requestTimeout);

      final body = _decodeJsonObject(response.body);

      if (response.statusCode != 200) {
        throw Exception(
          '${body['message'] ?? 'Failed to update user'} (status: ${response.statusCode}) body: ${response.body}',
        );
      }

      final data = body['data'];
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid response from server');
      }

      return _toUserProfile(data);
    } on TimeoutException {
      throw Exception(_networkHint('Request timed out'));
    } on SocketException {
      throw Exception(_networkHint('Could not connect to server'));
    }
  }

  String _networkHint(String reason) {
    return '$reason. API base URL: $_baseUrl. If you are using a real Android device, run with --dart-define=API_BASE_URL=http://<YOUR_PC_IP>:3000';
  }

  Map<String, dynamic> _toBackendPayload(UserProfile profile) {
    return {
      'email': profile.email,
      'fullName': profile.fullName,
      'phoneNumber': profile.phoneNumber,
      'profilePhotoUrl': profile.profilePhotoUrl,
      'bio': profile.bio,
      'dateOfBirth': profile.dateOfBirth?.toIso8601String(),
      'location': profile.location,
      'skills': profile.skills,
      'interests': profile.interests,
      'hobbies': profile.hobbies,
      'educationHistory': profile.educationHistory
          .map((education) => education.toJson())
          .toList(),
      'careerGoals': profile.careerGoals.map((goal) => goal.toJson()).toList(),
      'preferredJobTitle': profile.preferredJobTitle,
      'employmentType': profile.employmentType,
      'preferredIndustries': profile.preferredIndustries,
      'languages': profile.languages,
      'isProfileComplete': profile.isProfileComplete,
    };
  }

  UserProfile _toUserProfile(Map<String, dynamic> map) {
    return UserProfile(
      userId: map['id']?.toString(),
      email: map['email'] as String?,
      fullName: map['fullName'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      profilePhotoUrl: map['profilePhotoUrl'] as String?,
      bio: map['bio'] as String?,
      dateOfBirth: _parseDateTime(map['dateOfBirth']),
      location: map['location'] as String?,
      skills: _toStringList(map['skills']),
      interests: _toStringList(map['interests']),
      hobbies: _toStringList(map['hobbies']),
      educationHistory: _toEducationList(map['educationHistory']),
      careerGoals: _toCareerGoalsList(map['careerGoals']),
      preferredJobTitle: map['preferredJobTitle'] as String?,
      employmentType: map['employmentType'] as String?,
      preferredIndustries: _toStringList(map['preferredIndustries']),
      languages: _toStringList(map['languages']),
      isProfileComplete: map['isProfileComplete'] == true,
      createdAt: _parseDateTime(map['createdAt']),
      updatedAt: _parseDateTime(map['updatedAt']),
    );
  }

  static Map<String, dynamic> _decodeJsonObject(String body) {
    if (body.isEmpty) return <String, dynamic>{};
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return <String, dynamic>{};
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    return const [];
  }

  static List<Education> _toEducationList(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map<String, dynamic>>()
          .map(Education.fromJson)
          .toList();
    }
    return const [];
  }

  static List<CareerGoal> _toCareerGoalsList(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map<String, dynamic>>()
          .map(CareerGoal.fromJson)
          .toList();
    }
    return const [];
  }
}
