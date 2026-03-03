import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../themes/app_theme.dart';
import 'education_screen.dart';

/// Skills and Interests Screen - Step 2
/// Collects user's skills and interests
class SkillsInterestsScreen extends StatefulWidget {
  final UserProfile userProfile;

  const SkillsInterestsScreen({super.key, required this.userProfile});

  @override
  State<SkillsInterestsScreen> createState() => _SkillsInterestsScreenState();
}

class _SkillsInterestsScreenState extends State<SkillsInterestsScreen> {
  List<String> selectedSkills = [];
  List<String> selectedInterests = [];

  late TextEditingController _customSkillController;
  late TextEditingController _customInterestController;

  // Predefined options
  final List<String> predefinedSkills = [
    'Communication',
    'Leadership',
    'Problem Solving',
    'Time Management',
    'Teamwork',
    'Critical Thinking',
    'Creativity',
    'Technical Skills',
    'Data Analysis',
    'Project Management',
    'Public Speaking',
    'Writing',
    'Research',
    'Programming',
    'Design',
  ];

  final List<String> predefinedInterests = [
    'Technology',
    'Business',
    'Healthcare',
    'Education',
    'Finance',
    'Creative Arts',
    'Environmental Science',
    'Sports',
    'Travel',
    'Photography',
    'Writing',
    'Entrepreneurship',
    'Social Work',
    'Research',
    'Gaming',
  ];

  @override
  void initState() {
    super.initState();
    _customSkillController = TextEditingController();
    _customInterestController = TextEditingController();
    selectedSkills = List.from(widget.userProfile.skills);
    selectedInterests = List.from(widget.userProfile.interests);
  }

  @override
  void dispose() {
    _customSkillController.dispose();
    _customInterestController.dispose();
    super.dispose();
  }

  void _addCustomSkill() {
    final skill = _customSkillController.text.trim();
    if (skill.isNotEmpty && !selectedSkills.contains(skill)) {
      setState(() {
        selectedSkills.add(skill);
        _customSkillController.clear();
      });
    }
  }

  void _addCustomInterest() {
    final interest = _customInterestController.text.trim();
    if (interest.isNotEmpty && !selectedInterests.contains(interest)) {
      setState(() {
        selectedInterests.add(interest);
        _customInterestController.clear();
      });
    }
  }

  void _proceedToNextStep() {
    if (selectedSkills.isEmpty || selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one skill and one interest'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final updatedProfile = widget.userProfile.copyWith(
      skills: selectedSkills,
      interests: selectedInterests,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EducationScreen(userProfile: updatedProfile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skills & Interests'),
        elevation: 0,
        backgroundColor: AppColors.primaryBlue,
      ),
      body: Container(
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
              _buildProgressIndicator(2),
              const SizedBox(height: 30),
              _buildSectionTitle('Your Skills'),
              const SizedBox(height: 12),
              _buildDescription('Select skills you have or add your own'),
              const SizedBox(height: 16),
              _buildChipGroup(predefinedSkills, selectedSkills, (skill) {
                setState(() {
                  if (selectedSkills.contains(skill)) {
                    selectedSkills.remove(skill);
                  } else {
                    selectedSkills.add(skill);
                  }
                });
              }),
              const SizedBox(height: 16),
              _buildAddCustomField(
                controller: _customSkillController,
                hintText: 'Add custom skill',
                onAdd: _addCustomSkill,
                icon: Icons.add,
              ),
              const SizedBox(height: 12),
              if (selectedSkills.isNotEmpty)
                _buildSelectedChips(selectedSkills),
              const SizedBox(height: 30),
              _buildSectionTitle('Your Interests'),
              const SizedBox(height: 12),
              _buildDescription('Select interests that motivate you'),
              const SizedBox(height: 16),
              _buildChipGroup(predefinedInterests, selectedInterests, (
                interest,
              ) {
                setState(() {
                  if (selectedInterests.contains(interest)) {
                    selectedInterests.remove(interest);
                  } else {
                    selectedInterests.add(interest);
                  }
                });
              }),
              const SizedBox(height: 16),
              _buildAddCustomField(
                controller: _customInterestController,
                hintText: 'Add custom interest',
                onAdd: _addCustomInterest,
                icon: Icons.add,
              ),
              const SizedBox(height: 12),
              if (selectedInterests.isNotEmpty)
                _buildSelectedChips(selectedInterests),
              const SizedBox(height: 40),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(int currentStep) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildProgressStep(1, currentStep >= 1, 'Basic Info'),
          _buildProgressLine(),
          _buildProgressStep(2, currentStep >= 2, 'Skills'),
          _buildProgressLine(),
          _buildProgressStep(3, currentStep >= 3, 'Education'),
          _buildProgressLine(),
          _buildProgressStep(4, currentStep >= 4, 'Goals'),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int step, bool isActive, String label) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: isActive ? AppColors.goldAccent : Colors.white30,
            child: Text(
              '$step',
              style: TextStyle(
                color: isActive ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? Colors.white : Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressLine() {
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: Colors.white30,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDescription(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, color: Colors.white70),
    );
  }

  Widget _buildChipGroup(
    List<String> items,
    List<String> selected,
    Function(String) onSelect,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final isSelected = selected.contains(item);
        return FilterChip(
          label: Text(item),
          selected: isSelected,
          onSelected: (_) => onSelect(item),
          backgroundColor: Colors.white.withOpacity(0.1),
          selectedColor: AppColors.goldAccent,
          labelStyle: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w500,
          ),
          side: BorderSide(
            color: isSelected ? AppColors.goldAccent : Colors.white30,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSelectedChips(List<String> items) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: items.map((item) {
          return Chip(
            label: Text(item),
            onDeleted: () {
              setState(() {
                selectedSkills.remove(item);
                selectedInterests.remove(item);
              });
            },
            backgroundColor: AppColors.goldAccent.withOpacity(0.2),
            labelStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            deleteIconColor: Colors.white70,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAddCustomField({
    required TextEditingController controller,
    required String hintText,
    required VoidCallback onAdd,
    required IconData icon,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.goldAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.black),
            onPressed: onAdd,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white70),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Back', style: TextStyle(color: Colors.white70)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _proceedToNextStep,
            child: const Text('Next Step'),
          ),
        ),
      ],
    );
  }
}
