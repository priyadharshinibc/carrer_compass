import 'package:flutter/material.dart';
import '../../services/career_recommendation_service.dart';
import '../../themes/app_theme.dart';

/// Manage Career Dataset Screen
///
/// Allows administrators to view, add, edit, and delete career options.
class ManageCareerDatasetScreen extends StatefulWidget {
  const ManageCareerDatasetScreen({super.key});

  @override
  State<ManageCareerDatasetScreen> createState() =>
      _ManageCareerDatasetScreenState();
}

class _ManageCareerDatasetScreenState extends State<ManageCareerDatasetScreen> {
  late List<CareerOption> _careers;

  @override
  void initState() {
    super.initState();
    _careers = List.from(CareerRecommendationService.careerOptions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Career Dataset'),
        elevation: 0,
        backgroundColor: AppColors.primaryBlue,
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _addCareer),
        ],
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
        child: _careers.isEmpty
            ? const Center(
                child: Text(
                  'No careers available.',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _careers.length,
                itemBuilder: (context, index) {
                  final career = _careers[index];
                  return Card(
                    color: Colors.white.withOpacity(0.1),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(
                        career.title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        career.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white70),
                            onPressed: () => _editCareer(index),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () => _deleteCareer(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _addCareer() {
    // For simplicity, add a dummy career
    setState(() {
      _careers.add(
        CareerOption(
          title: 'New Career',
          description: 'Description here.',
          industries: ['Industry'],
          skills: ['Skill'],
          educationRequired: 'Education',
        ),
      );
    });
  }

  void _editCareer(int index) {
    // For simplicity, just show a dialog or navigate to edit
    // In a real app, would have a form
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit functionality not implemented yet.')),
    );
  }

  void _deleteCareer(int index) {
    setState(() {
      _careers.removeAt(index);
    });
  }
}
