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
                child: FutureBuilder<List<CareerRecommendationInsight>>(
                  future:
                      CareerRecommendationService.analyzeCareerRecommendations(
                        userProfile,
                      ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.goldAccent,
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Something went wrong.\n${snapshot.error}',
                          style: const TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    final recommendations = snapshot.data ?? const [];

                    if (recommendations.isEmpty) {
                      return const Center(
                        child: Text(
                          'No recommendations available right now.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: recommendations.length,
                      itemBuilder: (context, index) {
                        final rec = recommendations[index];
                        return Card(
                          color: const Color.fromARGB(
                            255,
                            31,
                            72,
                            95,
                          ).withOpacity(0.92),
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: AppColors.tealBlue.withOpacity(0.45),
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              rec.recommendation.careerOption.title,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              'AI confidence: ${rec.confidence.toStringAsFixed(1)}%\n${rec.strengths.first}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.78),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                              '${rec.confidence.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CareerInsightDetailScreen(insight: rec),
                                ),
                              );
                            },
                          ),
                        );
                      },
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

class CareerInsightDetailScreen extends StatelessWidget {
  final CareerRecommendationInsight insight;

  const CareerInsightDetailScreen({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    final career = insight.recommendation.careerOption;

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
        child: SafeArea(
          child: SingleChildScrollView(
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
                  'AI Confidence: ${insight.confidence.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Why This Matches You',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                ...insight.strengths.map(
                  (reason) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '• $reason',
                      style: TextStyle(color: Colors.white.withOpacity(0.75)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Skill Gaps',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                if (insight.skillGaps.isEmpty)
                  Text(
                    'No critical gaps detected.',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: insight.skillGaps.map((skill) {
                      return Chip(
                        label: Text(skill),
                        backgroundColor: AppColors.tealBlue.withOpacity(0.38),
                        labelStyle: const TextStyle(color: Colors.white),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 20),
                Text(
                  'Next Actions',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                ...insight.nextActions.map(
                  (step) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '• $step',
                      style: TextStyle(color: Colors.white.withOpacity(0.75)),
                    ),
                  ),
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
                      backgroundColor: AppColors.primaryBlue.withOpacity(0.38),
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
                      backgroundColor: AppColors.primaryBlue.withOpacity(0.38),
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
      ),
    );
  }
}
