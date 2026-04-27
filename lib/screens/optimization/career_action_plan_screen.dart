import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_profile.dart';
import '../../services/career_action_planner.dart';
import '../../themes/app_theme.dart';

class CareerActionPlanScreen extends StatefulWidget {
  final UserProfile userProfile;

  const CareerActionPlanScreen({super.key, required this.userProfile});

  @override
  State<CareerActionPlanScreen> createState() => _CareerActionPlanScreenState();
}

class _CareerActionPlanScreenState extends State<CareerActionPlanScreen> {
  static const String _completedTasksPrefix = 'career_action_completed_tasks';
  static const String _streakPrefix = 'career_action_streak';
  static const String _lastActivityPrefix = 'career_action_last_activity';
  static const String _modePrefix = 'career_action_mode';

  Set<String> _completedTasks = <String>{};
  int _weeklyStreakDays = 0;
  PlanMode _mode = PlanMode.balanced;
  bool _isLoading = true;

  String get _userKey {
    final stableId = widget.userProfile.userId?.trim();
    if (stableId != null && stableId.isNotEmpty) return stableId;
    return widget.userProfile.email ?? 'local_user';
  }

  String get _completedTasksKey => '$_completedTasksPrefix:$_userKey';
  String get _streakKey => '$_streakPrefix:$_userKey';
  String get _lastActivityKey => '$_lastActivityPrefix:$_userKey';
  String get _modeKey => '$_modePrefix:$_userKey';

  List<ActionPlanItem> get _plan =>
      CareerActionPlanner.buildPlan(widget.userProfile, mode: _mode);

  @override
  void initState() {
    super.initState();
    _loadPlanState();
  }

  Future<void> _loadPlanState() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getStringList(_completedTasksKey) ?? const [];
    final streak = prefs.getInt(_streakKey) ?? 0;
    final modeIndex = prefs.getInt(_modeKey) ?? PlanMode.balanced.index;

    if (!mounted) return;
    setState(() {
      _completedTasks = completed.toSet();
      _weeklyStreakDays = streak;
      _mode = PlanMode.values[modeIndex.clamp(0, PlanMode.values.length - 1)];
      _isLoading = false;
    });
  }

  Future<void> _saveCompletedTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_completedTasksKey, _completedTasks.toList());
  }

  Future<void> _saveMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_modeKey, _mode.index);
  }

  Future<void> _markLearningActivity() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _dateOnly(DateTime.now());
    final todayString = today.toIso8601String();

    final lastActivityRaw = prefs.getString(_lastActivityKey);
    final lastActivity = lastActivityRaw != null
        ? DateTime.tryParse(lastActivityRaw)
        : null;

    int streak = prefs.getInt(_streakKey) ?? 0;
    if (lastActivity != null) {
      final diff = today.difference(_dateOnly(lastActivity)).inDays;
      if (diff == 0) {
        // Keep streak unchanged for multiple completions on same day.
      } else if (diff == 1) {
        streak += 1;
      } else {
        streak = 1;
      }
    } else {
      streak = 1;
    }

    await prefs.setString(_lastActivityKey, todayString);
    await prefs.setInt(_streakKey, streak);

    if (!mounted) return;
    setState(() {
      _weeklyStreakDays = streak;
    });
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  String _taskId(ActionPlanItem item, String section, int index) {
    return '${item.goal.goalTitle}|${item.goal.targetYear}|$section|$index';
  }

  int _countCompletedTasks(List<ActionPlanItem> plan) {
    var total = 0;
    for (final item in plan) {
      for (var i = 0; i < item.milestones.length; i++) {
        if (_completedTasks.contains(_taskId(item, 'milestone', i))) total++;
      }
      for (var i = 0; i < item.suggestions.length; i++) {
        if (_completedTasks.contains(_taskId(item, 'suggestion', i))) total++;
      }
    }
    return total;
  }

  int _countTotalTasks(List<ActionPlanItem> plan) {
    var total = 0;
    for (final item in plan) {
      total += item.milestones.length;
      total += item.suggestions.length;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final plan = _plan;

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
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.goldAccent),
              )
            : plan.isEmpty
            ? _buildEmptyState()
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildModeSelector(),
                  const SizedBox(height: 12),
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

  Widget _buildModeSelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2E46).withOpacity(0.92),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.goldAccent.withOpacity(0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Plan Strategy',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PlanMode.values.map((mode) {
              final selected = _mode == mode;
              return ChoiceChip(
                label: Text(_modeLabel(mode)),
                selected: selected,
                selectedColor: AppColors.goldAccent,
                backgroundColor: const Color(0xFF1A4867),
                disabledColor: const Color(0xFF1A4867),
                labelStyle: TextStyle(
                  color: selected ? Colors.black : Colors.white,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: selected
                      ? AppColors.goldAccent
                      : Colors.white.withOpacity(0.35),
                ),
                onSelected: (value) async {
                  if (!value) return;
                  setState(() {
                    _mode = mode;
                  });
                  await _saveMode();
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _modeLabel(PlanMode mode) {
    switch (mode) {
      case PlanMode.fastTrack:
        return 'Fast-track';
      case PlanMode.lowStress:
        return 'Low-stress';
      case PlanMode.balanced:
        return 'Balanced';
    }
  }

  Widget _buildSummaryCard(List<ActionPlanItem> plan) {
    final top = plan.first;
    final avg =
        plan.map((e) => e.readinessScore).reduce((a, b) => a + b) / plan.length;
    final criticalCount = plan
        .where((item) => item.priorityLabel == 'Critical')
        .length;
    final avgWeeklyHours =
        (plan.map((item) => item.weeklyHoursTarget).reduce((a, b) => a + b) /
                plan.length)
            .toStringAsFixed(0);
    final completedTasks = _countCompletedTasks(plan);
    final totalTasks = _countTotalTasks(plan);
    final completionPct = totalTasks == 0
        ? 0
        : ((completedTasks / totalTasks) * 100).round();

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
            'Priority: ${top.priorityLabel}  •  Timeline: ${top.urgencyLabel}',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            'Overall readiness: ${avg.toStringAsFixed(1)}%',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            'Critical goals: $criticalCount  •  Avg weekly effort: $avgWeeklyHours hrs',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            'Task completion: $completedTasks/$totalTasks ($completionPct%)  •  Streak: $_weeklyStreakDays days',
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
              _buildBadge(
                item.priorityLabel,
                _priorityColor(item.priorityLabel),
              ),
              const SizedBox(width: 8),
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
            'Timeline: ${item.urgencyLabel} (${item.monthsLeft} months left)  •  Weekly target: ${item.weeklyHoursTarget} hrs',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 8),
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
            '30-60-90 Milestones',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          ...item.milestones.asMap().entries.map(
            (entry) => _buildTaskTile(
              item: item,
              section: 'milestone',
              index: entry.key,
              text: entry.value,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Next Steps',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          ...item.suggestions.asMap().entries.map(
            (entry) => _buildTaskTile(
              item: item,
              section: 'suggestion',
              index: entry.key,
              text: entry.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTile({
    required ActionPlanItem item,
    required String section,
    required int index,
    required String text,
  }) {
    final id = _taskId(item, section, index);
    final isDone = _completedTasks.contains(id);

    return CheckboxListTile(
      dense: true,
      value: isDone,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: AppColors.goldAccent,
      checkColor: Colors.black,
      title: Text(
        text,
        style: TextStyle(
          color: Colors.white70,
          decoration: isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      onChanged: (value) async {
        if (value == null) return;

        setState(() {
          if (value) {
            _completedTasks.add(id);
          } else {
            _completedTasks.remove(id);
          }
        });

        await _saveCompletedTasks();
        if (value) {
          await _markLearningActivity();
        }
      },
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _priorityColor(String label) {
    switch (label) {
      case 'Critical':
        return Colors.redAccent;
      case 'High':
        return Colors.orangeAccent;
      case 'Medium':
        return Colors.amber;
      default:
        return Colors.green;
    }
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
