import '../models/user_profile.dart';

/// Career recommendation engine.
///
/// Matches a user's profile to a set of predefined career options and
/// provides ranked suggestions.
class CareerRecommendationService {
  /// A small sample list of career options. In a real app, this might come
  /// from an API or a database.
  static final List<CareerOption> _careerOptions = [
    CareerOption(
      title: 'Software Engineer',
      description:
          'Build and maintain software systems. Requires strong programming and problem-solving skills.',
      industries: ['Technology', 'Finance', 'Healthcare'],
      skills: ['Programming', 'Problem Solving', 'Teamwork', 'Communication'],
      educationRequired:
          'Bachelor’s Degree in Computer Science or related field',
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
          'Bachelor’s Degree in Statistics, Math, or related field',
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
      educationRequired: 'Bachelor’s Degree in Business or related field',
    ),
    CareerOption(
      title: 'UX/UI Designer',
      description:
          'Design user interfaces and experiences for digital products.',
      industries: ['Technology', 'Design', 'Media'],
      skills: ['Design', 'Creativity', 'Communication', 'Critical Thinking'],
      educationRequired: 'Bachelor’s Degree in Design or related field',
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
          'Bachelor’s Degree in Computer Science or Cybersecurity',
    ),
    // Government / Public Service
    CareerOption(
      title: 'Civil Services Officer (UPSC)',
      description:
          'Serve in central government administration after clearing the UPSC Civil Services Examination.',
      industries: ['Government', 'Public Service'],
      skills: ['General Knowledge', 'Analytical Thinking', 'Communication'],
      educationRequired: 'Bachelorâ€™s Degree in any discipline',
    ),
    CareerOption(
      title: 'State Public Service Officer',
      description:
          'Work in state government departments through State Public Service Commission exams.',
      industries: ['Government', 'Public Service'],
      skills: ['General Knowledge', 'Problem Solving', 'Administration'],
      educationRequired: 'Bachelorâ€™s Degree in any discipline',
    ),
    CareerOption(
      title: 'Bank Probationary Officer (PO)',
      description:
          'Manage retail banking operations, lending, and customer service in public sector banks.',
      industries: ['Banking', 'Finance', 'Government'],
      skills: ['Quantitative Aptitude', 'Customer Service', 'Communication'],
      educationRequired: 'Bachelorâ€™s Degree in any discipline',
    ),
    CareerOption(
      title: 'Railway Junior Engineer',
      description:
          'Maintain and supervise technical systems in Indian Railways across civil, electrical, or mechanical streams.',
      industries: ['Government', 'Transport', 'Engineering'],
      skills: ['Engineering Basics', 'Problem Solving', 'Safety Awareness'],
      educationRequired: 'Diploma or Bachelorâ€™s in Engineering',
    ),
    CareerOption(
      title: 'Police Sub-Inspector',
      description:
          'Lead policing units, conduct investigations, and maintain law and order at the state level.',
      industries: ['Government', 'Public Safety'],
      skills: ['Physical Fitness', 'Decision Making', 'Communication'],
      educationRequired: 'Bachelorâ€™s Degree; state recruitment exam',
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
      educationRequired: 'Bachelorâ€™s in Agriculture or related field',
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

  /// Getter for career options.
  static List<CareerOption> get careerOptions => _careerOptions;

  /// Returns a ranked list of career options based on the user's profile.
  static List<CareerRecommendation> recommendCareers(UserProfile profile) {
    final scored = _careerOptions.map((career) {
      return CareerRecommendation(
        careerOption: career,
        score: _scoreCareer(career, profile),
      );
    }).toList();

    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored;
  }

  static double _scoreCareer(CareerOption career, UserProfile profile) {
    var score = 0.0;

    // Match user skills.
    final skillOverlap = career.skills
        .where((skill) => profile.skills.contains(skill))
        .length;
    score += skillOverlap * 2.0;

    // Match user interests with career industries.
    final industryOverlap = career.industries
        .where((industry) => profile.interests.contains(industry))
        .length;
    score += industryOverlap * 1.5;

    // Bonus if user preferred industries include this career's industries.
    final preferredIndustryOverlap = career.industries
        .where((industry) => profile.preferredIndustries.contains(industry))
        .length;
    score += preferredIndustryOverlap * 2.0;

    // Match job title preference.
    if (profile.preferredJobTitle != null &&
        profile.preferredJobTitle!.isNotEmpty) {
      final lowerTitle = profile.preferredJobTitle!.toLowerCase();
      final lowerCareer = career.title.toLowerCase();
      if (lowerTitle.contains(lowerCareer) ||
          lowerCareer.contains(lowerTitle)) {
        score += 3.0;
      }
    }

    // Add small random variation.
    score += (DateTime.now().microsecond % 5) / 50.0;

    return score;
  }
}

class CareerOption {
  final String title;
  final String description;
  final List<String> industries;
  final List<String> skills;
  final String educationRequired;

  CareerOption({
    required this.title,
    required this.description,
    required this.industries,
    required this.skills,
    required this.educationRequired,
  });
}

class CareerRecommendation {
  final CareerOption careerOption;
  final double score;

  CareerRecommendation({required this.careerOption, required this.score});
}
