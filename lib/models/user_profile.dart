/// User Profile Model
/// Handles all user data including personal, educational, skills, and career information
class UserProfile {
  final String? userId;
  final String? email;
  final String? fullName;
  final String? phoneNumber;
  final String? profilePhotoUrl;
  final String? bio;
  final DateTime? dateOfBirth;
  final String? location;

  // Skills and Interests
  final List<String> skills;
  final List<String> interests;
  final List<String> hobbies;

  // Educational Background
  final List<Education> educationHistory;

  // Career Information
  final List<CareerGoal> careerGoals;
  final String? preferredJobTitle;
  final String? employmentType; // Full-time, Part-time, Contract, etc.
  final List<String> preferredIndustries;
  final List<String> languages;

  // Profile Status
  final bool isProfileComplete;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile({
    this.userId,
    this.email,
    this.fullName,
    this.phoneNumber,
    this.profilePhotoUrl,
    this.bio,
    this.dateOfBirth,
    this.location,
    this.skills = const [],
    this.interests = const [],
    this.hobbies = const [],
    this.educationHistory = const [],
    this.careerGoals = const [],
    this.preferredJobTitle,
    this.employmentType,
    this.preferredIndustries = const [],
    this.languages = const [],
    this.isProfileComplete = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Create a copy with some fields replaced
  UserProfile copyWith({
    String? userId,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? profilePhotoUrl,
    String? bio,
    DateTime? dateOfBirth,
    String? location,
    List<String>? skills,
    List<String>? interests,
    List<String>? hobbies,
    List<Education>? educationHistory,
    List<CareerGoal>? careerGoals,
    String? preferredJobTitle,
    String? employmentType,
    List<String>? preferredIndustries,
    List<String>? languages,
    bool? isProfileComplete,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      bio: bio ?? this.bio,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      location: location ?? this.location,
      skills: skills ?? this.skills,
      interests: interests ?? this.interests,
      hobbies: hobbies ?? this.hobbies,
      educationHistory: educationHistory ?? this.educationHistory,
      careerGoals: careerGoals ?? this.careerGoals,
      preferredJobTitle: preferredJobTitle ?? this.preferredJobTitle,
      employmentType: employmentType ?? this.employmentType,
      preferredIndustries: preferredIndustries ?? this.preferredIndustries,
      languages: languages ?? this.languages,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'email': email,
    'fullName': fullName,
    'phoneNumber': phoneNumber,
    'profilePhotoUrl': profilePhotoUrl,
    'bio': bio,
    'dateOfBirth': dateOfBirth?.toIso8601String(),
    'location': location,
    'skills': skills,
    'interests': interests,
    'hobbies': hobbies,
    'educationHistory': educationHistory.map((e) => e.toJson()).toList(),
    'careerGoals': careerGoals.map((g) => g.toJson()).toList(),
    'preferredJobTitle': preferredJobTitle,
    'employmentType': employmentType,
    'preferredIndustries': preferredIndustries,
    'languages': languages,
    'isProfileComplete': isProfileComplete,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  /// Create from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    userId: json['userId'],
    email: json['email'],
    fullName: json['fullName'],
    phoneNumber: json['phoneNumber'],
    profilePhotoUrl: json['profilePhotoUrl'],
    bio: json['bio'],
    dateOfBirth: json['dateOfBirth'] != null
        ? DateTime.parse(json['dateOfBirth'])
        : null,
    location: json['location'],
    skills: List<String>.from(json['skills'] ?? []),
    interests: List<String>.from(json['interests'] ?? []),
    hobbies: List<String>.from(json['hobbies'] ?? []),
    educationHistory:
        (json['educationHistory'] as List<dynamic>?)
            ?.map((e) => Education.fromJson(e))
            .toList() ??
        [],
    careerGoals:
        (json['careerGoals'] as List<dynamic>?)
            ?.map((g) => CareerGoal.fromJson(g))
            .toList() ??
        [],
    preferredJobTitle: json['preferredJobTitle'],
    employmentType: json['employmentType'],
    preferredIndustries: List<String>.from(json['preferredIndustries'] ?? []),
    languages: List<String>.from(json['languages'] ?? []),
    isProfileComplete: json['isProfileComplete'] ?? false,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : null,
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : null,
  );
}

/// Educational Background Model
class Education {
  final String institutionName;
  final String degree;
  final String fieldOfStudy;
  final int startYear;
  final int? endYear;
  final bool isCurrentlyStudying;
  final double? gpa;
  final String? description;

  Education({
    required this.institutionName,
    required this.degree,
    required this.fieldOfStudy,
    required this.startYear,
    this.endYear,
    this.isCurrentlyStudying = false,
    this.gpa,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'institutionName': institutionName,
    'degree': degree,
    'fieldOfStudy': fieldOfStudy,
    'startYear': startYear,
    'endYear': endYear,
    'isCurrentlyStudying': isCurrentlyStudying,
    'gpa': gpa,
    'description': description,
  };

  factory Education.fromJson(Map<String, dynamic> json) => Education(
    institutionName: json['institutionName'],
    degree: json['degree'],
    fieldOfStudy: json['fieldOfStudy'],
    startYear: json['startYear'],
    endYear: json['endYear'],
    isCurrentlyStudying: json['isCurrentlyStudying'] ?? false,
    gpa: json['gpa']?.toDouble(),
    description: json['description'],
  );
}

/// Career Goals Model
class CareerGoal {
  final String? id;
  final String goalTitle;
  final String description;
  final int targetYear;
  final String priority; // High, Medium, Low
  final List<String> requiredSkills;
  final String? status; // Not Started, In Progress, Completed

  CareerGoal({
    this.id,
    required this.goalTitle,
    required this.description,
    required this.targetYear,
    this.priority = 'Medium',
    this.requiredSkills = const [],
    this.status = 'Not Started',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'goalTitle': goalTitle,
    'description': description,
    'targetYear': targetYear,
    'priority': priority,
    'requiredSkills': requiredSkills,
    'status': status,
  };

  factory CareerGoal.fromJson(Map<String, dynamic> json) => CareerGoal(
    id: json['id'],
    goalTitle: json['goalTitle'],
    description: json['description'],
    targetYear: json['targetYear'],
    priority: json['priority'] ?? 'Medium',
    requiredSkills: List<String>.from(json['requiredSkills'] ?? []),
    status: json['status'] ?? 'Not Started',
  );
}
