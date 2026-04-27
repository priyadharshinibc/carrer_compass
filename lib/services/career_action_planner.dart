import '../models/user_profile.dart';

enum PlanMode { fastTrack, balanced, lowStress }

class CareerActionPlanner {
  static List<ActionPlanItem> buildPlan(
    UserProfile profile, {
    PlanMode mode = PlanMode.balanced,
  }) {
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
      final weights = _weightsForMode(mode);

      final weightedScore =
          (skillCoverage * weights.skill) +
          (interestScore * weights.interest) +
          (titleMatch * weights.title) +
          (urgencyScore * weights.urgency);

      final readinessScore = weightedScore.clamp(0, 100).toDouble();
      final monthsLeft = _monthsLeft(goal.targetYear);
      final priorityScore =
          ((100 - readinessScore) * 0.65) + ((urgencyScore * 100) * 0.35);

      final suggestions = _buildSuggestions(
        mode: mode,
        goalTitle: goal.goalTitle,
        missingSkills: missingSkills,
        monthsLeft: monthsLeft,
      );

      final milestones = _buildMilestones(
        goalTitle: goal.goalTitle,
        missingSkills: missingSkills,
        monthsLeft: monthsLeft,
      );

      return ActionPlanItem(
        goal: goal,
        readinessScore: readinessScore,
        priorityLabel: _priorityLabel(priorityScore),
        urgencyLabel: _urgencyLabel(monthsLeft),
        monthsLeft: monthsLeft,
        weeklyHoursTarget: _weeklyHoursTarget(
          mode,
          missingSkills.length,
          monthsLeft,
        ),
        matchedSkills: matchedSkills,
        missingSkills: missingSkills,
        suggestions: suggestions,
        milestones: milestones,
      );
    }).toList();

    items.sort((a, b) {
      final priorityCompare = _priorityRank(
        a.priorityLabel,
      ).compareTo(_priorityRank(b.priorityLabel));
      if (priorityCompare != 0) return priorityCompare;
      return b.readinessScore.compareTo(a.readinessScore);
    });

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

  static int _monthsLeft(int targetYear) {
    return ((targetYear - DateTime.now().year) * 12).clamp(1, 84);
  }

  static ({double skill, double interest, double title, double urgency})
  _weightsForMode(PlanMode mode) {
    switch (mode) {
      case PlanMode.fastTrack:
        return (skill: 55, interest: 10, title: 10, urgency: 25);
      case PlanMode.lowStress:
        return (skill: 60, interest: 20, title: 10, urgency: 10);
      case PlanMode.balanced:
        return (skill: 55, interest: 15, title: 15, urgency: 15);
    }
  }

  static String _priorityLabel(double priorityScore) {
    if (priorityScore >= 70) return 'Critical';
    if (priorityScore >= 55) return 'High';
    if (priorityScore >= 40) return 'Medium';
    return 'Low';
  }

  static int _priorityRank(String label) {
    switch (label) {
      case 'Critical':
        return 0;
      case 'High':
        return 1;
      case 'Medium':
        return 2;
      default:
        return 3;
    }
  }

  static String _urgencyLabel(int monthsLeft) {
    if (monthsLeft <= 6) return 'Immediate';
    if (monthsLeft <= 12) return 'Near-term';
    if (monthsLeft <= 24) return 'Mid-term';
    return 'Long-term';
  }

  static int _weeklyHoursTarget(
    PlanMode mode,
    int missingSkillCount,
    int monthsLeft,
  ) {
    final base = 4 + (missingSkillCount * 2);
    int adjusted;
    if (monthsLeft <= 6) {
      adjusted = base + 4;
    } else if (monthsLeft <= 12) {
      adjusted = base + 2;
    } else {
      adjusted = base;
    }

    if (mode == PlanMode.fastTrack) adjusted += 3;
    if (mode == PlanMode.lowStress) adjusted -= 2;

    return adjusted.clamp(4, 24);
  }

  static List<String> _buildSuggestions({
    required PlanMode mode,
    required String goalTitle,
    required List<String> missingSkills,
    required int monthsLeft,
  }) {
    final actions = <String>[];

    if (missingSkills.isEmpty) {
      actions.add(
        'You are mostly aligned for "$goalTitle". Prioritize interviews, networking, and portfolio evidence.',
      );
    } else {
      for (final skill in missingSkills.take(3)) {
        actions.add(
          'Close "$skill" gap with one mini-project and one guided course.',
        );
      }
    }

    actions.add(
      'Run a weekly review: 3 wins, 2 blockers, and next-week priorities.',
    );

    actions.add(
      'Create measurable outcomes: projects completed, mock tests, or applications submitted.',
    );

    actions.add(
      'Use a $monthsLeft-month roadmap and checkpoint progress every 30 days.',
    );

    switch (mode) {
      case PlanMode.fastTrack:
        actions.add(
          'Fast-track mode: focus on high-impact tasks daily and limit low-priority learning.',
        );
        break;
      case PlanMode.lowStress:
        actions.add(
          'Low-stress mode: use smaller daily sessions and keep consistent progress without burnout.',
        );
        break;
      case PlanMode.balanced:
        actions.add(
          'Balanced mode: combine skill growth, portfolio work, and applications each week.',
        );
        break;
    }

    return actions;
  }

  static List<String> _buildMilestones({
    required String goalTitle,
    required List<String> missingSkills,
    required int monthsLeft,
  }) {
    final milestones = <String>[];

    final firstSkill = missingSkills.isNotEmpty
        ? missingSkills.first
        : 'core interview readiness';
    final secondSkill = missingSkills.length > 1
        ? missingSkills[1]
        : 'portfolio depth';

    milestones.add(
      '0-30 days: Build foundation in $firstSkill and set a weekly learning routine.',
    );
    milestones.add(
      '31-60 days: Complete one portfolio project focused on $secondSkill.',
    );
    milestones.add(
      '61-90 days: Start mock interviews/tests and improve weak areas from feedback.',
    );

    if (monthsLeft <= 12) {
      milestones.add(
        'Final phase: Apply aggressively to roles aligned with "$goalTitle" and track conversion metrics.',
      );
    } else {
      milestones.add(
        'Long phase: Expand real-world proof with internships, hackathons, or certifications.',
      );
    }

    return milestones;
  }
}

class ActionPlanItem {
  final CareerGoal goal;
  final double readinessScore;
  final String priorityLabel;
  final String urgencyLabel;
  final int monthsLeft;
  final int weeklyHoursTarget;
  final List<String> matchedSkills;
  final List<String> missingSkills;
  final List<String> suggestions;
  final List<String> milestones;

  ActionPlanItem({
    required this.goal,
    required this.readinessScore,
    required this.priorityLabel,
    required this.urgencyLabel,
    required this.monthsLeft,
    required this.weeklyHoursTarget,
    required this.matchedSkills,
    required this.missingSkills,
    required this.suggestions,
    required this.milestones,
  });
}
