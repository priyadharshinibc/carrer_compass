import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../services/career_recommendation_service.dart';
import '../../themes/app_theme.dart';

/// Career Recommendation screen.
///
/// Matches the user's profile to predefined career paths and displays
/// personalized suggestions.
class CareerRecommendationScreen extends StatelessWidget {
  final UserProfile userProfile;

  const CareerRecommendationScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    final recommendations = CareerRecommendationService.recommendCareers(
      userProfile,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Recommendations'),
        elevation: 0,
        backgroundColor: AppColors.primaryBlue,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryBlue, AppColors.tealBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personalized Career Suggestions',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Based on your skills, interests, and preferences.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: recommendations.length,
                  itemBuilder: (context, index) {
                    final rec = recommendations[index];
                    return Card(
                      color: Colors.white.withOpacity(0.08),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          rec.careerOption.title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          rec.careerOption.description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          rec.score.toStringAsFixed(2),
                          style: const TextStyle(
                            color: AppColors.goldAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CareerDetailScreen(career: rec.careerOption),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CareerDetailScreen extends StatelessWidget {
  final CareerOption career;

  const CareerDetailScreen({super.key, required this.career});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(career.title),
        elevation: 0,
        backgroundColor: AppColors.primaryBlue,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryBlue, AppColors.tealBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                career.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                career.description,
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              const SizedBox(height: 20),
              Text(
                'Required Skills',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: career.skills.map((skill) {
                  return Chip(
                    label: Text(skill),
                    backgroundColor: Colors.white.withOpacity(0.1),
                    labelStyle: const TextStyle(color: Colors.white),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text(
                'Industries',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: career.industries.map((industry) {
                  return Chip(
                    label: Text(industry),
                    backgroundColor: Colors.white.withOpacity(0.1),
                    labelStyle: const TextStyle(color: Colors.white),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text(
                'Typical Education',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                career.educationRequired,
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
