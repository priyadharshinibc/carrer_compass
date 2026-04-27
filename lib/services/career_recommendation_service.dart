import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/user_profile.dart';

/// Career recommendation engine with Firestore backend + offline fallback.
class CareerRecommendationService {
  /// Firestore collection name.
  static const String _collection = 'career_options';

  /// Ranked recommendations using the offline fallback list (no network call).
  static List<CareerRecommendation> recommendCareersOffline(
    UserProfile profile,
  ) {
    return _rankCareers(_fallbackCareerOptions, profile);
  }

  /// Ranked recommendations using Firestore when available.
  ///
  /// - If Firebase isn't initialized or the collection is empty, the offline
  ///   fallback list is used.
  /// - Set [useFallbackOnError] to false to bubble up errors instead.
  static Future<List<CareerRecommendation>> recommendCareers(
    UserProfile profile, {
    bool useFallbackOnError = true,
  }) async {
    final options = await fetchCareerOptions(
      useFallbackOnError: useFallbackOnError,
    );
    return _rankCareers(options, profile);
  }

  /// AI-style analysis that includes confidence, reasons, skill gaps,
  /// and suggested next actions for each recommendation.
  static Future<List<CareerRecommendationInsight>> analyzeCareerRecommendations(
    UserProfile profile, {
    bool useFallbackOnError = true,
  }) async {
    final options = await fetchCareerOptions(
      useFallbackOnError: useFallbackOnError,
    );
    final ranked = _rankCareers(options, profile);

    return ranked.map((rec) {
      final career = rec.careerOption;
      final matchedSkills = career.skills
          .where((skill) => _containsIgnoreCase(profile.skills, skill))
          .toList();
      final missingSkills = career.skills
          .where((skill) => !_containsIgnoreCase(profile.skills, skill))
          .toList();

      final strengths = <String>[];
      if (matchedSkills.isNotEmpty) {
        strengths.add(
          'You already have ${matchedSkills.length} required skills.',
        );
      }

      final industryMatches = career.industries
          .where(
            (industry) =>
                _containsIgnoreCase(profile.interests, industry) ||
                _containsIgnoreCase(profile.preferredIndustries, industry),
          )
          .toList();
      if (industryMatches.isNotEmpty) {
        strengths.add(
          'Matches your interests in ${industryMatches.join(', ')}.',
        );
      }

      if (_hasTitleMatch(profile.preferredJobTitle, career.title)) {
        strengths.add('Aligned with your preferred job title.');
      }

      if (strengths.isEmpty) {
        strengths.add(
          'A balanced option based on your profile and market relevance.',
        );
      }

      final nextActions = _buildActionPlan(career, missingSkills);
      final confidence = _toConfidence(rec.score);

      return CareerRecommendationInsight(
        recommendation: rec,
        confidence: confidence,
        strengths: strengths,
        skillGaps: missingSkills,
        nextActions: nextActions,
      );
    }).toList();
  }

  /// Fetches career options from Firestore.
  static Future<List<CareerOption>> fetchCareerOptions({
    bool useFallbackOnError = true,
  }) async {
    try {
      if (Firebase.apps.isEmpty) {
        throw StateError('Firebase not initialized');
      }

      final snapshot = await FirebaseFirestore.instance
          .collection(_collection)
          .get();

      if (snapshot.docs.isEmpty) {
        return _fallbackCareerOptions;
      }

      return snapshot.docs
          .map((doc) => CareerOption.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      if (useFallbackOnError) return _fallbackCareerOptions;
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Scoring
  // ---------------------------------------------------------------------------
  static List<CareerRecommendation> _rankCareers(
    List<CareerOption> options,
    UserProfile profile,
  ) {
    final scored = options
        .map(
          (career) => CareerRecommendation(
            careerOption: career,
            score: _scoreCareer(career, profile),
          ),
        )
        .toList();

    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored;
  }

  static double _scoreCareer(CareerOption career, UserProfile profile) {
    final skillScore = _normalizedOverlap(profile.skills, career.skills) * 6.0;
    final interestScore =
        _normalizedOverlap(profile.interests, career.industries) * 3.0;
    final preferredIndustryScore =
        _normalizedOverlap(profile.preferredIndustries, career.industries) *
        4.0;
    final titleScore = _hasTitleMatch(profile.preferredJobTitle, career.title)
        ? 2.0
        : 0.0;

    final goalAlignmentScore = _goalAlignment(profile.careerGoals, career);

    return skillScore +
        interestScore +
        preferredIndustryScore +
        titleScore +
        goalAlignmentScore;
  }

  static bool _containsIgnoreCase(List<String> source, String value) {
    final target = value.trim().toLowerCase();
    return source.any((item) => item.trim().toLowerCase() == target);
  }

  static bool _hasTitleMatch(String? preferredTitle, String careerTitle) {
    if (preferredTitle == null || preferredTitle.trim().isEmpty) return false;

    final userTitle = preferredTitle.toLowerCase();
    final title = careerTitle.toLowerCase();
    return userTitle.contains(title) || title.contains(userTitle);
  }

  static double _normalizedOverlap(List<String> source, List<String> target) {
    if (source.isEmpty || target.isEmpty) return 0;

    var count = 0;
    for (final item in target) {
      if (_containsIgnoreCase(source, item)) count++;
    }

    return count / target.length;
  }

  static double _goalAlignment(List<CareerGoal> goals, CareerOption career) {
    if (goals.isEmpty) return 0;

    var score = 0.0;
    for (final goal in goals) {
      final title = goal.goalTitle.toLowerCase();
      final desc = goal.description.toLowerCase();
      final careerTitle = career.title.toLowerCase();

      if (title.contains(careerTitle) || careerTitle.contains(title)) {
        score += 1.2;
      }

      for (final industry in career.industries) {
        if (desc.contains(industry.toLowerCase())) {
          score += 0.3;
        }
      }
    }

    return score.clamp(0, 3).toDouble();
  }

  static double _toConfidence(double score) {
    // Map raw score to a practical confidence band.
    final normalized = (score / 15.0).clamp(0, 1);
    return (normalized * 100).toDouble();
  }

  static List<String> _buildActionPlan(
    CareerOption career,
    List<String> missingSkills,
  ) {
    final steps = <String>[];

    if (missingSkills.isEmpty) {
      steps.add('Start applying for entry roles and build portfolio evidence.');
    } else {
      for (final skill in missingSkills.take(3)) {
        steps.add('Complete one project focused on "$skill".');
      }
    }

    steps.add('Study the qualification path: ${career.educationRequired}.');
    steps.add('Set a 30-day milestone and review progress weekly.');

    return steps;
  }

  // ---------------------------------------------------------------------------
  // Fallback data
  // ---------------------------------------------------------------------------
  static final List<CareerOption> _fallbackCareerOptions = [
    CareerOption(
      title: 'Software Engineer',
      description:
          'Build and maintain software systems. Requires strong programming and problem-solving skills.',
      industries: ['Technology', 'Finance', 'Healthcare'],
      skills: ['Programming', 'Problem Solving', 'Teamwork', 'Communication'],
      educationRequired:
          'Bachelor\'s Degree in Computer Science or related field',
    ),
    CareerOption(
      title: 'Data Analyst',
      description: 'Analyze data to help businesses make informed decisions.',
      industries: ['Technology', 'Finance', 'Healthcare', 'Research'],
      skills: [
        'Data Analysis',
        'Critical Thinking',
        'Statistics',
        'Communication',
      ],
      educationRequired:
          'Bachelor\'s Degree in Statistics, Math, or related field',
    ),
    CareerOption(
      title: 'Product Manager',
      description:
          'Guide product development and strategy, working with cross-functional teams.',
      industries: ['Technology', 'Retail', 'Consumer Goods'],
      skills: [
        'Leadership',
        'Communication',
        'Project Management',
        'Creativity',
      ],
      educationRequired: 'Bachelor\'s Degree in Business or related field',
    ),
    CareerOption(
      title: 'UX/UI Designer',
      description:
          'Design user interfaces and experiences for digital products.',
      industries: ['Technology', 'Design', 'Media'],
      skills: ['Design', 'Creativity', 'Communication', 'Critical Thinking'],
      educationRequired: 'Bachelor\'s Degree in Design or related field',
    ),
    CareerOption(
      title: 'Cybersecurity Analyst',
      description:
          'Protect organizations from cyber threats by monitoring and responding to security incidents.',
      industries: ['Technology', 'Finance', 'Government'],
      skills: [
        'Security',
        'Problem Solving',
        'Attention to Detail',
        'Technical Skills',
      ],
      educationRequired:
          'Bachelor\'s Degree in Computer Science or Cybersecurity',
    ),
    // Government / Public Service
    CareerOption(
      title: 'Civil Services Officer (UPSC)',
      description:
          'Serve in central government administration after clearing the UPSC Civil Services Examination.',
      industries: ['Government', 'Public Service'],
      skills: ['General Knowledge', 'Analytical Thinking', 'Communication'],
      educationRequired: 'Bachelor\'s Degree in any discipline',
    ),
    CareerOption(
      title: 'State Public Service Officer',
      description:
          'Work in state government departments through State Public Service Commission exams.',
      industries: ['Government', 'Public Service'],
      skills: ['General Knowledge', 'Problem Solving', 'Administration'],
      educationRequired: 'Bachelor\'s Degree in any discipline',
    ),
    CareerOption(
      title: 'Bank Probationary Officer (PO)',
      description:
          'Manage retail banking operations, lending, and customer service in public sector banks.',
      industries: ['Banking', 'Finance', 'Government'],
      skills: ['Quantitative Aptitude', 'Customer Service', 'Communication'],
      educationRequired: 'Bachelor\'s Degree in any discipline',
    ),
    CareerOption(
      title: 'Railway Junior Engineer',
      description:
          'Maintain and supervise technical systems in Indian Railways across civil, electrical, or mechanical streams.',
      industries: ['Government', 'Transport', 'Engineering'],
      skills: ['Engineering Basics', 'Problem Solving', 'Safety Awareness'],
      educationRequired: 'Diploma or Bachelor\'s in Engineering',
    ),
    CareerOption(
      title: 'Police Sub-Inspector',
      description:
          'Lead policing units, conduct investigations, and maintain law and order at the state level.',
      industries: ['Government', 'Public Safety'],
      skills: ['Physical Fitness', 'Decision Making', 'Communication'],
      educationRequired: 'Bachelor\'s Degree; state recruitment exam',
    ),
    // Healthcare & Education
    CareerOption(
      title: 'Registered Nurse',
      description:
          'Provide patient care in hospitals and clinics, coordinating with doctors and ensuring treatment adherence.',
      industries: ['Healthcare'],
      skills: ['Clinical Skills', 'Compassion', 'Attention to Detail'],
      educationRequired: 'B.Sc Nursing / GNM with registration',
    ),
    CareerOption(
      title: 'School Teacher',
      description:
          'Teach and mentor students in primary or secondary schools; specialize by subject.',
      industries: ['Education'],
      skills: ['Subject Expertise', 'Classroom Management', 'Communication'],
      educationRequired: 'B.Ed with relevant subject degree',
    ),
    // Agriculture & Rural Development
    CareerOption(
      title: 'Agricultural Extension Officer',
      description:
          'Guide farmers on best practices, government schemes, and modern techniques.',
      industries: ['Agriculture', 'Government'],
      skills: ['Agronomy Basics', 'Field Work', 'Communication'],
      educationRequired: 'Bachelor\'s in Agriculture or related field',
    ),
    // Skilled Trades & Manufacturing
    CareerOption(
      title: 'Electrician',
      description:
          'Install and maintain electrical systems in homes, industries, and infrastructure projects.',
      industries: ['Construction', 'Manufacturing'],
      skills: ['Electrical Wiring', 'Safety', 'Troubleshooting'],
      educationRequired: 'ITI/Polytechnic certification with license',
    ),
    CareerOption(
      title: 'Manufacturing Technician',
      description:
          'Operate and maintain machinery on production lines while ensuring quality and safety standards.',
      industries: ['Manufacturing', 'Automotive'],
      skills: ['Machine Operation', 'Quality Control', 'Teamwork'],
      educationRequired: 'Diploma/ITI in relevant trade',
    ),
  ];

  static Iterable<dynamic> get careerOptions => [];
}

class CareerOption {
  final String? id;
  final String title;
  final String description;
  final List<String> industries;
  final List<String> skills;
  final String educationRequired;

  const CareerOption({
    this.id,
    required this.title,
    required this.description,
    required this.industries,
    required this.skills,
    required this.educationRequired,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'industries': industries,
    'skills': skills,
    'educationRequired': educationRequired,
  };

  factory CareerOption.fromJson(Map<String, dynamic> json) => CareerOption(
    id: json['id'] as String?,
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    industries: List<String>.from(json['industries'] ?? const []),
    skills: List<String>.from(json['skills'] ?? const []),
    educationRequired: json['educationRequired'] ?? '',
  );
}

class CareerRecommendation {
  final CareerOption careerOption;
  final double score;

  CareerRecommendation({required this.careerOption, required this.score});
}

class CareerRecommendationInsight {
  final CareerRecommendation recommendation;
  final double confidence;
  final List<String> strengths;
  final List<String> skillGaps;
  final List<String> nextActions;

  CareerRecommendationInsight({
    required this.recommendation,
    required this.confidence,
    required this.strengths,
    required this.skillGaps,
    required this.nextActions,
  });
}
