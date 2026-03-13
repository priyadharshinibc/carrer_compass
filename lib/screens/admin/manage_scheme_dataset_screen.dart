import 'package:flutter/material.dart';
import '../../services/government_scheme_service.dart';
import '../../themes/app_theme.dart';

/// Manage Government Scheme Dataset Screen
///
/// Allows administrators to view, add, edit, and delete government schemes.
class ManageSchemeDatasetScreen extends StatefulWidget {
  const ManageSchemeDatasetScreen({super.key});

  @override
  State<ManageSchemeDatasetScreen> createState() =>
      _ManageSchemeDatasetScreenState();
}

class _ManageSchemeDatasetScreenState extends State<ManageSchemeDatasetScreen> {
  late List<GovernmentScheme> _schemes;

  @override
  void initState() {
    super.initState();
    _schemes = List.from(GovernmentSchemeService.schemes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Scheme Dataset'),
        elevation: 0,
        backgroundColor: AppColors.primaryBlue,
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _addScheme),
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
        child: _schemes.isEmpty
            ? const Center(
                child: Text(
                  'No schemes available.',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _schemes.length,
                itemBuilder: (context, index) {
                  final scheme = _schemes[index];
                  return Card(
                    color: Colors.white.withOpacity(0.1),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(
                        scheme.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        scheme.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white70),
                            onPressed: () => _editScheme(index),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () => _deleteScheme(index),
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

  void _addScheme() {
    // For simplicity, add a dummy scheme
    setState(() {
      _schemes.add(
        GovernmentScheme(
          name: 'New Scheme',
          description: 'Description here.',
          benefits: 'Benefits here.',
          eligibility: {'location': 'India'},
          category: 'General',
          government: 'India',
          applyUrl: null,
        ),
      );
    });
  }

  void _editScheme(int index) {
    // For simplicity, just show a dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit functionality not implemented yet.')),
    );
  }

  void _deleteScheme(int index) {
    setState(() {
      _schemes.removeAt(index);
    });
  }
}
