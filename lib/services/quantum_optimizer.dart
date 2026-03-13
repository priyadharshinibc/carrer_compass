import '../models/user_profile.dart';

/// A lightweight, "quantum-inspired" optimizer that ranks career goals
/// based on the user's skills, interests, and preferences.
///
/// This is not a real quantum algorithm; it is inspired by the idea of
/// exploring multiple alternatives and selecting the best solutions.
class QuantumOptimizer {
  /// Given a list of career goals and the user's profile, returns a list of
  /// goals sorted by estimated fit (best first).
  static List<OptimizedGoal> rankAlternatives(
    List<CareerGoal> goals,
    UserProfile profile,
  ) {
    final scoredGoals = goals.map((goal) {
      final score = _scoreGoal(goal, profile);
      return OptimizedGoal(goal: goal, score: score);
    }).toList();

    scoredGoals.sort((a, b) => b.score.compareTo(a.score));
    return scoredGoals;
  }

  /// Creates a compact ranked list of the "best" options.
  ///
  /// Returns the top [count] items (default 3).
  static List<OptimizedGoal> selectBest(
    List<CareerGoal> goals,
    UserProfile profile, {
    int count = 3,
  }) {
    final ranked = rankAlternatives(goals, profile);
    return ranked.take(count).toList();
  }

  /// Computes a score based on skill overlap, preferences, and other hints.
  /// Adds a small randomized component to mimic a "quantum" exploration.
  static double _scoreGoal(CareerGoal goal, UserProfile profile) {
    var score = 0.0;

    // Reward matching required skills.
    final matchingSkills = goal.requiredSkills
        .where((skill) => profile.skills.contains(skill))
        .length;
    score += matchingSkills * 2.0;

    // Reward if preferred job title is similar to the goal title.
    if (profile.preferredJobTitle != null &&
        profile.preferredJobTitle!.isNotEmpty) {
      final title = profile.preferredJobTitle!.toLowerCase();
      final goalTitle = goal.goalTitle.toLowerCase();
      if (title.contains(goalTitle) || goalTitle.contains(title)) {
        score += 3.0;
      }
    }

    // Reward matching industries.
    if (profile.preferredIndustries.isNotEmpty) {
      final industryMatch = profile.preferredIndustries
          .where(
            (industry) =>
                goal.description.toLowerCase().contains(industry.toLowerCase()),
          )
          .length;
      score += industryMatch * 1.5;
    }

    // Reward major interests appearing in the goal description.
    final interestMatch = profile.interests
        .where(
          (interest) =>
              goal.description.toLowerCase().contains(interest.toLowerCase()),
        )
        .length;
    score += interestMatch * 1.2;

    // Add a small random component to encourage exploration.
    score += _quantumFluctuation();

    return score;
  }

  /// Simulates a very small "quantum fluctuation".
  static double _quantumFluctuation() {
    return (DateTime.now().microsecond % 10) / 100.0;
  }
}

/// A goal paired with a computed fitness score.
class OptimizedGoal {
  final CareerGoal goal;
  final double score;

  OptimizedGoal({required this.goal, required this.score});
}
