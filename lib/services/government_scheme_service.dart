import '../models/user_profile.dart';

/// Government Scheme Matching Service.
///
/// Matches user profiles to relevant government schemes based on eligibility
/// criteria. Includes schemes from India and Tamil Nadu.
class GovernmentSchemeService {
  /// A curated list of government schemes with eligibility criteria.
  static final List<GovernmentScheme> _schemes = [
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
    GovernmentScheme(
      name: 'Pradhan Mantri Mudra Yojana',
      description:
          'Collateral-free loans for micro and small enterprises under Shishu, Kishor, and Tarun categories.',
      benefits: 'Loans up to Rs 10 lakh via partner banks and NBFCs.',
      eligibility: {
        'occupation': 'micro/small business owner',
        'location': 'India',
      },
      category: 'Entrepreneurship',
      government: 'India',
      applyUrl: 'https://www.mudra.org.in/',
    ),
    GovernmentScheme(
      name: 'Stand-Up India Scheme',
      description:
          'Bank loans to support entrepreneurship among women and SC/ST applicants.',
      benefits: 'Loans from Rs 10 lakh to Rs 1 crore for greenfield enterprises.',
      eligibility: {
        'category': 'SC/ST/woman',
        'location': 'India',
      },
      category: 'Entrepreneurship',
      government: 'India',
      applyUrl: 'https://www.standupmitra.in/',
    ),
    GovernmentScheme(
      name: 'Atal Pension Yojana',
      description:
          'Pension scheme for unorganized sector workers with government co-contribution.',
      benefits: 'Pension of Rs 1,000 to 5,000 per month after age 60 based on contribution.',
      eligibility: {'age': '18-40', 'location': 'India'},
      category: 'Social Security',
      government: 'India',
      applyUrl: 'https://www.npscra.nsdl.co.in/scheme-details.php',
    ),
    GovernmentScheme(
      name: 'National Scholarship Portal',
      description:
          'Single window for central and state scholarships for students.',
      benefits: 'Scholarship disbursal for eligible students across levels.',
      eligibility: {
        'education': 'students',
        'location': 'India',
      },
      category: 'Education',
      government: 'India',
      applyUrl: 'https://scholarships.gov.in/',
    ),
    GovernmentScheme(
      name: 'Pradhan Mantri Jan Dhan Yojana',
      description:
          'Zero-balance bank accounts with overdraft, insurance, and RuPay card for financial inclusion.',
      benefits: 'No minimum balance; overdraft up to Rs 10,000; accidental insurance cover.',
      eligibility: {'location': 'India'},
      category: 'Finance',
      government: 'India',
      applyUrl: 'https://pmjdy.gov.in/',
    ),
    GovernmentScheme(
      name: 'Pradhan Mantri Ujjwala Yojana',
      description:
          'Free LPG connections for women from below-poverty-line households to promote clean cooking.',
      benefits: 'Deposit-free LPG connection with first refill and stove assistance.',
      eligibility: {'category': 'BPL', 'gender': 'female', 'location': 'India'},
      category: 'Health',
      government: 'India',
      applyUrl: 'https://www.pmuy.gov.in/',
    ),
    GovernmentScheme(
      name: 'Sukanya Samriddhi Yojana',
      description:
          'Small savings scheme for girl child offering high interest and tax benefits.',
      benefits: 'Competitive interest rate; tax deduction under Section 80C.',
      eligibility: {'gender': 'female', 'age': '0-10', 'location': 'India'},
      category: 'Savings',
      government: 'India',
      applyUrl: 'https://www.nsiindia.gov.in/InternalPage.aspx?Id_Pk=89',
    ),
    GovernmentScheme(
      name: 'Kisan Credit Card',
      description:
          'Credit facility for farmers to meet cultivation and contingency needs.',
      benefits: 'Flexible credit limits with interest subsidy for timely repayment.',
      eligibility: {'occupation': 'farmer', 'location': 'India'},
      category: 'Agriculture',
      government: 'India',
      applyUrl: 'https://www.pmkisan.gov.in/Documents/KCC.pdf',
    ),
    GovernmentScheme(
      name: 'Jal Jeevan Mission',
      description:
          'Household tap water supply to rural homes with functional tap connections.',
      benefits: 'Support for piped water infrastructure in rural areas.',
      eligibility: {'location': 'India', 'category': 'rural household'},
      category: 'Water',
      government: 'India',
      applyUrl: 'https://jaljeevanmission.gov.in/',
    ),
    GovernmentScheme(
      name: 'Pradhan Mantri Fasal Bima Yojana',
      description: 'Crop insurance for farmers against natural calamities.',
      benefits: 'Subsidized premiums and claim support for notified crops.',
      eligibility: {'occupation': 'farmer', 'location': 'India'},
      category: 'Agriculture',
      government: 'India',
      applyUrl: 'https://pmfby.gov.in/',
    ),
    GovernmentScheme(
      name: 'Deen Dayal Upadhyaya Grameen Kaushalya Yojana',
      description: 'Skill development and placement support for rural youth.',
      benefits: 'Free residential training with placement assistance.',
      eligibility: {'age': '15-35', 'location': 'India', 'category': 'rural'},
      category: 'Skill Development',
      government: 'India',
      applyUrl: 'https://ddugky.gov.in/',
    ),
    GovernmentScheme(
      name: 'Pradhan Mantri Kaushal Vikas Yojana',
      description: 'Short-term skilling with assessment and certification.',
      benefits: 'Free training and monetary reward on certification.',
      eligibility: {'age': '18-35', 'location': 'India'},
      category: 'Skill Development',
      government: 'India',
      applyUrl: 'https://www.pmkvyofficial.org/',
    ),
    GovernmentScheme(
      name: 'National Apprenticeship Promotion Scheme',
      description: 'On-the-job apprenticeship training with stipend support.',
      benefits: 'Stipend reimbursement and training support.',
      eligibility: {'age': '14+', 'location': 'India'},
      category: 'Skill Development',
      government: 'India',
      applyUrl: 'https://apprenticeshipindia.gov.in/',
    ),
    GovernmentScheme(
      name: 'Prime Minister Employment Generation Programme',
      description: 'Credit-linked subsidy for micro and small enterprises.',
      benefits: 'Subsidy up to 35% on project cost for eligible entrepreneurs.',
      eligibility: {'location': 'India', 'category': 'micro/small business'},
      category: 'Entrepreneurship',
      government: 'India',
      applyUrl: 'https://www.kviconline.gov.in/pmegp/',
    ),
    GovernmentScheme(
      name: 'Startup India Seed Fund Scheme',
      description: 'Seed funding support for early-stage startups.',
      benefits: 'Grants and convertible debt for MVP and market entry.',
      eligibility: {'location': 'India', 'category': 'startup'},
      category: 'Entrepreneurship',
      government: 'India',
      applyUrl: 'https://seedfund.startupindia.gov.in/',
    ),
    GovernmentScheme(
      name: 'Khelo India',
      description: 'National program for sports development and scholarships.',
      benefits: 'Training, infrastructure, and scholarships for athletes.',
      eligibility: {'age': '10-21', 'location': 'India', 'category': 'athlete'},
      category: 'Sports',
      government: 'India',
      applyUrl: 'https://kheloindia.gov.in/',
    ),
    GovernmentScheme(
      name: 'National Means-cum-Merit Scholarship',
      description: 'Scholarship to reduce dropouts at class VIII and encourage higher studies.',
      benefits: 'Annual scholarship for eligible students via NSP.',
      eligibility: {'education': 'class 8', 'location': 'India'},
      category: 'Education',
      government: 'India',
      applyUrl: 'https://scholarships.gov.in/',
    ),
    GovernmentScheme(
      name: 'AMRUT',
      description: 'Urban infrastructure for water supply, sewerage, and green spaces.',
      benefits: 'Central assistance to cities for infrastructure projects.',
      eligibility: {'location': 'Urban India'},
      category: 'Urban Development',
      government: 'India',
      applyUrl: 'https://amrut.gov.in/',
    ),
    GovernmentScheme(
      name: 'National Rural Livelihood Mission',
      description: 'Livelihood support through SHGs and skill training.',
      benefits: 'Financial inclusion, credit linkage, and skilling for rural poor.',
      eligibility: {'location': 'rural', 'category': 'low-income'},
      category: 'Livelihood',
      government: 'India',
      applyUrl: 'https://aajeevika.gov.in/',
    ),
    GovernmentScheme(
      name: 'Atal Innovation Mission',
      description: 'Promotes innovation via Atal Tinkering Labs and incubators.',
      benefits: 'Grants for labs, incubation, and startup support.',
      eligibility: {'location': 'India', 'category': 'schools/startups'},
      category: 'Innovation',
      government: 'India',
      applyUrl: 'https://aim.gov.in/',
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
    GovernmentScheme(
      name: 'Tamil Nadu Amma Two Wheeler Scheme',
      description: 'Subsidy for working women to purchase two-wheelers.',
      benefits: '50% subsidy up to ₹25,000 on a new two-wheeler.',
      eligibility: {
        'gender': 'female',
        'location': 'Tamil Nadu',
        'category': 'working women',
      },
      category: 'Women Empowerment',
      government: 'Tamil Nadu',
      applyUrl: 'https://www.tamilnadumahalir.org/',
    ),
    GovernmentScheme(
      name: 'Tamil Nadu Free Laptop Scheme',
      description: 'Free laptops for students to promote digital learning.',
      benefits: 'Laptop provided by state government.',
      eligibility: {'education': 'students', 'location': 'Tamil Nadu'},
      category: 'Education',
      government: 'Tamil Nadu',
      applyUrl: 'https://it.tn.gov.in/en/ELCOT',
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
