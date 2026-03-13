import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../services/quantum_optimizer.dart';
import '../../themes/app_theme.dart';

/// A simple UI for exploring "quantum-inspired" optimization of career goals.
///
/// It ranks the user's career goals and highlights the top choices based on
/// skills, interests, and preferences.
class QuantumOptimizationScreen extends StatefulWidget {
  final UserProfile userProfile;

  const QuantumOptimizationScreen({super.key, required this.userProfile});

  @override
  State<QuantumOptimizationScreen> createState() =>
      _QuantumOptimizationScreenState();
}

class _QuantumOptimizationScreenState extends State<QuantumOptimizationScreen> {
  List<OptimizedGoal> _rankedGoals = [];
  bool _hasRun = false;

  void _runOptimization() {
    final ranked = QuantumOptimizer.rankAlternatives(
      widget.userProfile.careerGoals,
      widget.userProfile,
    );
    setState(() {
      _rankedGoals = ranked;
      _hasRun = true;
    });
  }

  void _selectBest() {
    final best = QuantumOptimizer.selectBest(
      widget.userProfile.careerGoals,
      widget.userProfile,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Top Recommendations'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: best.map((opt) {
            return ListTile(
              title: Text(opt.goal.goalTitle),
              subtitle: Text(opt.goal.description),
              trailing: Text(opt.score.toStringAsFixed(2)),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quantum Optimization'),
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
                'Quantum-Inspired Optimization',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Run an optimization pass to rank your career goals and find the best matches.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.userProfile.careerGoals.isEmpty
                          ? null
                          : _runOptimization,
                      child: const Text('Run Optimization'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.userProfile.careerGoals.isEmpty
                          ? null
                          : _selectBest,
                      child: const Text('Select Best Options'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (!_hasRun)
                Expanded(
                  child: Center(
                    child: Text(
                      widget.userProfile.careerGoals.isEmpty
                          ? 'Add career goals first to run optimization.'
                          : 'Press "Run Optimization" to rank your goals.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _rankedGoals.length,
                    itemBuilder: (context, index) {
                      final opt = _rankedGoals[index];
                      return Card(
                        color: Colors.white.withOpacity(0.08),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(
                            opt.goal.goalTitle,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            opt.goal.description,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          trailing: Text(
                            opt.score.toStringAsFixed(2),
                            style: const TextStyle(
                              color: AppColors.goldAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Score: ${opt.score.toStringAsFixed(2)}',
                                ),
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
