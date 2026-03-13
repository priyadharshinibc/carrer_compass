import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

/// Monitor System Usage Screen
///
/// Displays usage statistics and analytics for the system.
class MonitorUsageScreen extends StatelessWidget {
  const MonitorUsageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitor System Usage'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'System Usage Analytics',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Overview of app usage and user engagement.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 32),
              _buildStatCard('Total Users', '1,250', Icons.people),
              const SizedBox(height: 16),
              _buildStatCard('Active Sessions', '345', Icons.access_time),
              const SizedBox(height: 16),
              _buildStatCard(
                'Career Recommendations Viewed',
                '2,890',
                Icons.work,
              ),
              const SizedBox(height: 16),
              _buildStatCard('Schemes Applied', '567', Icons.account_balance),
              const SizedBox(height: 16),
              _buildStatCard('Profile Completions', '980', Icons.person),
              const SizedBox(height: 16),
              _buildStatCard('Average Session Time', '12 min', Icons.timer),
              const SizedBox(height: 32),
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildActivityItem('User completed profile setup', '2 hours ago'),
              _buildActivityItem(
                'New career recommendation generated',
                '4 hours ago',
              ),
              _buildActivityItem(
                'Government scheme application submitted',
                '6 hours ago',
              ),
              _buildActivityItem('User logged in', '8 hours ago'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.goldAccent, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String activity, String time) {
    return Card(
      color: Colors.white.withOpacity(0.05),
      child: ListTile(
        title: Text(activity, style: const TextStyle(color: Colors.white)),
        subtitle: Text(time, style: TextStyle(color: Colors.white70)),
        leading: const Icon(Icons.history, color: AppColors.goldAccent),
      ),
    );
  }
}
