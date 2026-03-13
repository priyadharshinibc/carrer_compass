import '../models/user_profile.dart';

/// Government Scheme Matching Service.
///
/// Matches user profiles to relevant government schemes based on eligibility
/// criteria. Includes schemes from India and Tamil Nadu.
class GovernmentSchemeService {
  /// A curated list of government schemes with eligibility criteria.
  static List<GovernmentScheme> _schemes = [
    // Indian Government Schemes
    GovernmentScheme(
      name: 'PM Kisan Samman Nidhi',
      description: 'Financial support to small and marginal farmers.',
      benefits: '₹6,000 per year in three installments.',
      eligibility: {
        'occupation': 'farmer',
        'location': 'India',
        'landHolding': 'small/marginal',
      },
      category: 'Agriculture',
      government: 'India',
      applyUrl: 'https://pmkisan.gov.in/',
    ),
    GovernmentScheme(
      name: 'Ayushman Bharat - Pradhan Mantri Jan Arogya Yojana',
      description: 'Health insurance for low-income families.',
      benefits: 'Up to ₹5 lakh per family per year for hospitalization.',
      eligibility: {'income': 'below poverty line', 'location': 'India'},
      category: 'Health',
      government: 'India',
      applyUrl: 'https://pmjay.gov.in/',
    ),
    GovernmentScheme(
      name: 'Swachh Bharat Mission',
      description: 'Clean India initiative for sanitation.',
      benefits: 'Subsidies for toilets, awareness programs.',
      eligibility: {'location': 'India'},
      category: 'Sanitation',
      government: 'India',
      applyUrl: 'https://swachhbharatmission.gov.in/',
    ),
    GovernmentScheme(
      name: 'Pradhan Mantri Awas Yojana',
      description: 'Housing for all by 2022.',
      benefits: 'Financial assistance for house construction.',
      eligibility: {
        'income': 'low/middle',
        'location': 'India',
        'housingStatus': 'no pucca house',
      },
      category: 'Housing',
      government: 'India',
      applyUrl: 'https://pmaymis.gov.in/',
    ),
    GovernmentScheme(
      name: 'Beti Bachao Beti Padhao',
      description: 'Promote education of girl child.',
      benefits: 'Scholarships, awareness campaigns.',
      eligibility: {'gender': 'female', 'age': '0-18', 'location': 'India'},
      category: 'Education',
      government: 'India',
      applyUrl: 'https://wcd.nic.in/bbbp',
    ),

    // Tamil Nadu Government Schemes
    GovernmentScheme(
      name: 'Dr. Muthulakshmi Reddy Maternity Benefit Scheme',
      description: 'Financial assistance for pregnant women.',
      benefits: '₹18,000 for institutional delivery.',
      eligibility: {
        'gender': 'female',
        'pregnant': true,
        'location': 'Tamil Nadu',
        'income': 'below ₹1 lakh',
      },
      category: 'Health',
      government: 'Tamil Nadu',
      applyUrl: 'https://tnhealth.tn.gov.in/maternity-benefit-scheme/',
    ),
    GovernmentScheme(
      name:
          'Tamil Nadu Chief Minister\'s Comprehensive Health Insurance Scheme',
      description: 'Health insurance for families below poverty line.',
      benefits: 'Up to ₹4 lakh per family per year.',
      eligibility: {'income': 'below poverty line', 'location': 'Tamil Nadu'},
      category: 'Health',
      government: 'Tamil Nadu',
      applyUrl: 'https://www.cghs.tn.gov.in/',
    ),
    GovernmentScheme(
      name: 'Tamil Nadu Pension Scheme',
      description: 'Pension for elderly, widows, and disabled.',
      benefits: 'Monthly pension of ₹1,000.',
      eligibility: {
        'age': 'above 60',
        'location': 'Tamil Nadu',
        'category': 'elderly/widow/disabled',
      },
      category: 'Social Welfare',
      government: 'Tamil Nadu',
      applyUrl: 'https://tnsocialwelfare.tn.gov.in/pension-schemes/',
    ),
    GovernmentScheme(
      name: 'Tamil Nadu Educational Loan Subsidy',
      description: 'Subsidy for educational loans.',
      benefits: 'Interest subsidy up to ₹7.5 lakh.',
      eligibility: {
        'education': 'higher education',
        'location': 'Tamil Nadu',
        'income': 'family income below ₹6 lakh',
      },
      category: 'Education',
      government: 'Tamil Nadu',
      applyUrl: 'https://www.tn.gov.in/scheme/educational-loan-subsidy-scheme/',
    ),
    GovernmentScheme(
      name: 'Tamil Nadu Agricultural Labourers Pension Scheme',
      description: 'Pension for agricultural laborers.',
      benefits: 'Monthly pension.',
      eligibility: {
        'occupation': 'agricultural labourer',
        'age': 'above 60',
        'location': 'Tamil Nadu',
      },
      category: 'Agriculture',
      government: 'Tamil Nadu',
      applyUrl:
          'https://tnsocialwelfare.tn.gov.in/agricultural-labourers-pension-scheme/',
    ),
  ];

  /// Getter for schemes.
  static List<GovernmentScheme> get schemes => _schemes;

  /// Returns a list of schemes the user is eligible for, based on their profile.
  static List<GovernmentScheme> getEligibleSchemes(UserProfile profile) {
    return _schemes.where((scheme) => _isEligible(scheme, profile)).toList();
  }

  /// Checks if a user is eligible for a specific scheme.
  static bool _isEligible(GovernmentScheme scheme, UserProfile profile) {
    final eligibility = scheme.eligibility;

    // Check location
    if (eligibility.containsKey('location')) {
      final requiredLocation = eligibility['location'];
      if (requiredLocation == 'India' ||
          (requiredLocation == 'Tamil Nadu' &&
              profile.location?.toLowerCase().contains('tamil nadu') == true)) {
        // OK
      } else {
        return false;
      }
    }

    // Check age
    if (eligibility.containsKey('age')) {
      final ageRange = eligibility['age'];
      final userAge = _calculateAge(profile.dateOfBirth);
      if (ageRange == 'above 60' && (userAge == null || userAge < 60)) {
        return false;
      }
      if (ageRange == '0-18' && (userAge == null || userAge > 18)) {
        return false;
      }
    }

    // Check income (simplified, assuming user has income field or infer from profile)
    if (eligibility.containsKey('income')) {
      final requiredIncome = eligibility['income'];
      // For simplicity, assume if user has low education or no job title, they might qualify for low-income schemes
      // In a real app, add income field to UserProfile
      if (requiredIncome == 'below poverty line' ||
          requiredIncome == 'below ₹1 lakh' ||
          requiredIncome == 'family income below ₹6 lakh') {
        // Placeholder: assume eligible if no preferred job title or low education
        if (profile.preferredJobTitle == null &&
            profile.educationHistory.isEmpty) {
          // OK
        } else {
          // For demo, allow
        }
      }
    }

    // Check gender
    if (eligibility.containsKey('gender')) {
      // UserProfile doesn't have gender, so skip or assume
      // In real app, add gender to profile
    }

    // Check occupation
    if (eligibility.containsKey('occupation')) {
      final requiredOccupation = eligibility['occupation'];
      if (requiredOccupation == 'farmer' &&
          !profile.interests.contains('Agriculture')) {
        return false;
      }
      if (requiredOccupation == 'agricultural labourer' &&
          !profile.skills.contains('Agriculture')) {
        return false;
      }
    }

    // Check education
    if (eligibility.containsKey('education')) {
      if (profile.educationHistory.isEmpty) {
        return false;
      }
    }

    // Other checks can be added as needed

    return true; // Default to eligible if no disqualifiers
  }

  /// Calculates age from date of birth.
  static int? _calculateAge(DateTime? dob) {
    if (dob == null) return null;
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }
}

class GovernmentScheme {
  final String name;
  final String description;
  final String benefits;
  final Map<String, dynamic> eligibility;
  final String category;
  final String government;
  final String? applyUrl; // URL to apply for the scheme

  GovernmentScheme({
    required this.name,
    required this.description,
    required this.benefits,
    required this.eligibility,
    required this.category,
    required this.government,
    this.applyUrl,
  });
}
