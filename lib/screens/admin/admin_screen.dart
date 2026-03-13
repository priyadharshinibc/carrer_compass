import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';
import 'manage_career_dataset_screen.dart';
import 'manage_scheme_dataset_screen.dart';
import 'monitor_usage_screen.dart';

/// Administration Module Screen
///
/// Provides access to administrative functions for managing datasets and monitoring usage.
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administration'),
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
                'Admin Modules',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Manage datasets and monitor system usage.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 32),
              _buildModuleCard(
                context,
                'Manage Career Dataset',
                'Add, edit, or remove career options.',
                Icons.work,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ManageCareerDatasetScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildModuleCard(
                context,
                'Manage Government Scheme Dataset',
                'Add, edit, or remove government schemes.',
                Icons.account_balance,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ManageSchemeDatasetScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildModuleCard(
                context,
                'Monitor System Usage',
                'View usage statistics and analytics.',
                Icons.analytics,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MonitorUsageScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: ListTile(
        leading: Icon(icon, color: AppColors.goldAccent),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.white70)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
        onTap: onTap,
      ),
    );
  }
}
