import '../models/user_profile.dart';

class CareerActionPlanner {
  static List<ActionPlanItem> buildPlan(UserProfile profile) {
    final items = profile.careerGoals.map((goal) {
      final requiredSkills = goal.requiredSkills;
      final matchedSkills = requiredSkills
          .where((skill) => _containsIgnoreCase(profile.skills, skill))
          .toList();
      final missingSkills = requiredSkills
          .where((skill) => !_containsIgnoreCase(profile.skills, skill))
          .toList();

      final skillCoverage = requiredSkills.isEmpty
          ? 0.6
          : matchedSkills.length / requiredSkills.length;

      final interestHits = profile.interests
          .where(
            (interest) =>
                goal.goalTitle.toLowerCase().contains(interest.toLowerCase()) ||
                goal.description.toLowerCase().contains(interest.toLowerCase()),
          )
          .length;
      final interestScore = (interestHits / 3).clamp(0, 1).toDouble();

      final titleMatch =
          _hasTitleMatch(profile.preferredJobTitle ?? '', goal.goalTitle)
          ? 1.0
          : 0.0;

      final urgencyScore = _urgencyScore(goal.targetYear);

      final weightedScore =
          (skillCoverage * 60) +
          (interestScore * 15) +
          (titleMatch * 15) +
          (urgencyScore * 10);

      final readinessScore = weightedScore.clamp(0, 100).toDouble();

      final suggestions = _buildSuggestions(
        missingSkills: missingSkills,
        targetYear: goal.targetYear,
      );

      return ActionPlanItem(
        goal: goal,
        readinessScore: readinessScore,
        matchedSkills: matchedSkills,
        missingSkills: missingSkills,
        suggestions: suggestions,
      );
    }).toList();

    items.sort((a, b) => b.readinessScore.compareTo(a.readinessScore));
    return items;
  }

  static bool _containsIgnoreCase(List<String> values, String target) {
    final normalized = target.trim().toLowerCase();
    return values.any((value) => value.trim().toLowerCase() == normalized);
  }

  static bool _hasTitleMatch(String preferredTitle, String goalTitle) {
    if (preferredTitle.trim().isEmpty) return false;

    final preferred = preferredTitle.toLowerCase();
    final goal = goalTitle.toLowerCase();
    return preferred.contains(goal) || goal.contains(preferred);
  }

  static double _urgencyScore(int targetYear) {
    final currentYear = DateTime.now().year;
    final yearsLeft = targetYear - currentYear;

    if (yearsLeft <= 1) return 1.0;
    if (yearsLeft <= 2) return 0.8;
    if (yearsLeft <= 4) return 0.6;
    return 0.4;
  }

  static List<String> _buildSuggestions({
    required List<String> missingSkills,
    required int targetYear,
  }) {
    final actions = <String>[];

    if (missingSkills.isEmpty) {
      actions.add(
        'You are already aligned on required skills. Start applying and building portfolio proof.',
      );
    } else {
      for (final skill in missingSkills.take(3)) {
        actions.add(
          'Learn and practice "$skill" through one project or certification.',
        );
      }
    }

    final monthsLeft = ((targetYear - DateTime.now().year) * 12).clamp(1, 60);
    actions.add(
      'Create a monthly plan for the next $monthsLeft months and review progress every 4 weeks.',
    );

    return actions;
  }
}

class ActionPlanItem {
  final CareerGoal goal;
  final double readinessScore;
  final List<String> matchedSkills;
  final List<String> missingSkills;
  final List<String> suggestions;

  ActionPlanItem({
    required this.goal,
    required this.readinessScore,
    required this.matchedSkills,
    required this.missingSkills,
    required this.suggestions,
  });
}
