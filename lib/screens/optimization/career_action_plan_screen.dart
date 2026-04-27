import 'package:flutter/material.dart';

import '../../models/user_profile.dart';
import '../../services/career_action_planner.dart';
import '../../themes/app_theme.dart';

class CareerActionPlanScreen extends StatelessWidget {
  final UserProfile userProfile;

  const CareerActionPlanScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    final plan = CareerActionPlanner.buildPlan(userProfile);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Action Plan'),
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
        child: plan.isEmpty
            ? _buildEmptyState()
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildSummaryCard(plan),
                  const SizedBox(height: 16),
                  ...plan.map((item) => _buildPlanCard(item)),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Add career goals first to generate your action plan.',
          style: TextStyle(color: Colors.white70, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSummaryCard(List<ActionPlanItem> plan) {
    final top = plan.first;
    final avg =
        plan.map((e) => e.readinessScore).reduce((a, b) => a + b) / plan.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Priority Goal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            top.goal.goalTitle,
            style: const TextStyle(color: AppColors.goldAccent, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            'Overall readiness: ${avg.toStringAsFixed(1)}%',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(ActionPlanItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.goal.goalTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                '${item.readinessScore.toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: AppColors.goldAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.goal.description,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          _buildChipSection('Matched Skills', item.matchedSkills, Colors.green),
          const SizedBox(height: 10),
          _buildChipSection(
            'Missing Skills',
            item.missingSkills,
            Colors.orange,
          ),
          const SizedBox(height: 12),
          const Text(
            'Next Steps',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          ...item.suggestions.map(
            (step) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '• $step',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipSection(String title, List<String> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 13)),
        const SizedBox(height: 6),
        if (items.isEmpty)
          const Text('None', style: TextStyle(color: Colors.white54))
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items
                .map(
                  (item) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: color),
                    ),
                    child: Text(
                      item,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
