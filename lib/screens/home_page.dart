import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../screens/admin/admin_screen.dart';
import '../screens/ai_assistant_screen.dart';
import '../screens/career_recommendation/career_recommendation_screen.dart';
import '../screens/government_schemes/government_schemes_screen.dart';
import '../screens/optimization/quantum_optimization_screen.dart';
import '../screens/profile_setup/basic_profile_screen.dart';
import 'learn/learn_detail_screen.dart';
import '../themes/app_theme.dart';

/// Home Page - Displayed after profile creation
/// Shows user profile summary and provides navigation to profile management
class HomePage extends StatefulWidget {
  final UserProfile userProfile;

  const HomePage({super.key, required this.userProfile});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Guide'),
        elevation: 0,
        backgroundColor: AppColors.primaryBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showProfileSettings(context),
          ),
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
        child: _buildBody(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.primaryBlue,
        selectedItemColor: AppColors.goldAccent,
        unselectedItemColor: Colors.white70,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Goals'),
          BottomNavigationBarItem(
            icon: Icon(Icons.laptop_chromebook),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: 'AI Assistant',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeScreen();
      case 1:
        return _buildProfileScreen();
      case 2:
        return _buildGoalsScreen();
      case 3:
        return _buildLearnScreen();
      case 4:
        return _buildAIAssistantScreen();
      default:
        return _buildHomeScreen();
    }
  }

  Widget _buildLearnScreen() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Learn',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Explore curated paths and courses across domains.',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            const SizedBox(height: 20),
            _buildLearnCard('CS/IT'),
            const SizedBox(height: 12),
            _buildLearnCard('Trending Courses'),
            const SizedBox(height: 12),
            _buildLearnCard('Architecture'),
            const SizedBox(height: 12),
            _buildLearnCard('Management'),
            const SizedBox(height: 12),
            _buildLearnCard('Maths and Science'),
            const SizedBox(height: 12),
            _buildLearnCard('Law'),
            const SizedBox(height: 12),
            _buildLearnCard('Government Exam Preparation'),
          ],
        ),
      ),
    );
  }

  Widget _buildLearnCard(String title) {
    return GestureDetector(
      onTap: () {
        if (title == 'CS/IT') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LearnDetailScreen(topic: 'CS/IT'),
            ),
          );
        } else if (title == 'Trending Courses') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LearnDetailScreen(topic: 'Trending Courses'),
            ),
          );
        } else if (title == 'Architecture') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LearnDetailScreen(topic: 'Architecture'),
            ),
          );
        } else if (title == 'Management') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LearnDetailScreen(topic: 'Management'),
            ),
          );
        } else if (title == 'Maths and Science') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LearnDetailScreen(topic: 'Maths and Science'),
            ),
          );
        } else if (title == 'Law') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LearnDetailScreen(topic: 'Law'),
            ),
          );
        } else if (title == 'Government Exam Preparation') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LearnDetailScreen(
                topic: 'Government Exam Preparation',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Coming soon: $title resources'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.laptop_chromebook,
              color: AppColors.goldAccent,
              size: 28,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to view roadmap & courses',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 11,
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

  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(),
          const SizedBox(height: 24),
          _buildProfileCompletionCard(),
          const SizedBox(height: 24),
          _buildQuickStatsSection(),
          const SizedBox(height: 24),
          _buildUpcomingGoalsSection(),
        ],
      ),
    );
  }

  Widget _buildProfileScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(widget.userProfile),
          const SizedBox(height: 24),
          _buildProfileSection('Basic Information', [
            _buildProfileTile(
              'Full Name',
              widget.userProfile.fullName ?? 'Not set',
            ),
            _buildProfileTile('Email', widget.userProfile.email ?? 'Not set'),
            _buildProfileTile(
              'Phone',
              widget.userProfile.phoneNumber ?? 'Not set',
            ),
            _buildProfileTile(
              'Location',
              widget.userProfile.location ?? 'Not set',
            ),
          ]),
          const SizedBox(height: 16),
          _buildProfileSection('Skills & Interests', [
            if (widget.userProfile.skills.isNotEmpty)
              _buildTagsList('Skills', widget.userProfile.skills),
            if (widget.userProfile.interests.isNotEmpty)
              _buildTagsList('Interests', widget.userProfile.interests),
            if (widget.userProfile.hobbies.isNotEmpty)
              _buildTagsList('Hobbies', widget.userProfile.hobbies),
          ]),
          const SizedBox(height: 16),
          _buildProfileSection('Career Information', [
            _buildProfileTile(
              'Preferred Job Title',
              widget.userProfile.preferredJobTitle ?? 'Not set',
            ),
            _buildProfileTile(
              'Employment Type',
              widget.userProfile.employmentType ?? 'Not set',
            ),
            if (widget.userProfile.languages.isNotEmpty)
              _buildTagsList('Languages', widget.userProfile.languages),
          ]),
          const SizedBox(height: 24),
          _buildEditProfileButton(),
        ],
      ),
    );
  }

  Widget _buildGoalsScreen() {
    if (widget.userProfile.careerGoals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flag_outlined,
              size: 64,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No career goals yet',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your career goals to track progress',
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Career Goals',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          ...widget.userProfile.careerGoals.map((goal) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildGoalCard(goal),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAIAssistantScreen() {
    return AIAssistantScreen(userProfile: widget.userProfile);
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${widget.userProfile.fullName ?? "User"}! 👋',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your profile is complete. Let\'s explore your career path together!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCompletionCard() {
    int completionPercentage = 0;
    List<String> completedSections = [];

    if (widget.userProfile.fullName != null) {
      completedSections.add('Basic Info');
    }
    if (widget.userProfile.skills.isNotEmpty) completedSections.add('Skills');
    if (widget.userProfile.educationHistory.isNotEmpty) {
      completedSections.add('Education');
    }
    if (widget.userProfile.careerGoals.isNotEmpty) {
      completedSections.add('Goals');
    }

    completionPercentage = ((completedSections.length / 4) * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profile Completion',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: completionPercentage / 100,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                completionPercentage == 100
                    ? Colors.green
                    : AppColors.goldAccent,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$completionPercentage% Complete',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Start',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildStatCard('Skills', '${widget.userProfile.skills.length}'),
            const SizedBox(width: 12),
            _buildStatCard(
              'Education',
              '${widget.userProfile.educationHistory.length}',
            ),
            const SizedBox(width: 12),
            _buildStatCard('Goals', '${widget.userProfile.careerGoals.length}'),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: widget.userProfile.careerGoals.isEmpty
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuantumOptimizationScreen(
                          userProfile: widget.userProfile,
                        ),
                      ),
                    );
                  },
            icon: const Icon(Icons.science),
            label: const Text('Optimize Career Choices'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed:
                widget.userProfile.skills.isEmpty &&
                    widget.userProfile.interests.isEmpty
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CareerRecommendationScreen(
                          userProfile: widget.userProfile,
                        ),
                      ),
                    );
                  },
            icon: const Icon(Icons.lightbulb),
            label: const Text('Get Career Suggestions'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      GovernmentSchemesScreen(userProfile: widget.userProfile),
                ),
              );
            },
            icon: const Icon(Icons.account_balance),
            label: const Text('Check Government Schemes'),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.goldAccent,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingGoalsSection() {
    if (widget.userProfile.careerGoals.isEmpty) {
      return const SizedBox.shrink();
    }

    final upcomingGoals = widget.userProfile.careerGoals.take(3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Goals',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...upcomingGoals.map((goal) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildGoalCard(goal),
          );
        }),
      ],
    );
  }

  Widget _buildGoalCard(CareerGoal goal) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getPriorityColor(goal.priority),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  goal.priority,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Target: ${goal.targetYear}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            goal.goalTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            goal.description,
            style: const TextStyle(fontSize: 13, color: Colors.white70),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildProfileHeader(dynamic userProfile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.goldAccent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                (userProfile.fullName ?? 'U')[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userProfile.fullName ?? 'User',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userProfile.preferredJobTitle ?? 'No job title set',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color.fromARGB(60, 252, 250, 250)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsList(String label, List<String> tags) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.goldAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.goldAccent),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Re-open profile setup flow with existing data; replace current home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  BasicProfileScreen(existingProfile: widget.userProfile),
            ),
          );
        },
        child: const Text('Edit Profile'),
      ),
    );
  }

  void _showProfileSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primaryBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.white),
              title: const Text(
                'Edit Profile',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        BasicProfileScreen(existingProfile: widget.userProfile),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.admin_panel_settings,
                color: Colors.white,
              ),
              title: const Text(
                'Administration',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.white),
              title: const Text(
                'Privacy Settings',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showLogoutConfirmation();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
