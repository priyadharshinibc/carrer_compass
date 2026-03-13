import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../services/secure_storage_service.dart';
import '../../themes/app_theme.dart';
import '../home_page.dart';

/// Career Goals Screen - Step 4
/// Collects user's career goals and preferences
class CareerGoalsScreen extends StatefulWidget {
  final UserProfile userProfile;

  const CareerGoalsScreen({super.key, required this.userProfile});

  @override
  State<CareerGoalsScreen> createState() => _CareerGoalsScreenState();
}

class _CareerGoalsScreenState extends State<CareerGoalsScreen> {
  List<CareerGoal> careerGoals = [];
  late TextEditingController _preferredJobTitleController;
  String? _selectedEmploymentType;
  List<String> selectedIndustries = [];
  List<String> selectedLanguages = [];

  final List<String> employmentTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Freelance',
    'Internship',
  ];

  final List<String> industries = [
    'Technology',
    'Finance',
    'Healthcare',
    'Education',
    'Manufacturing',
    'Retail',
    'Real Estate',
    'Entertainment',
    'Government',
    'Non-Profit',
    'Consulting',
    'Telecommunications',
  ];

  final List<String> languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Mandarin',
    'Japanese',
    'Arabic',
    'Portuguese',
    'Russian',
    'Korean',
  ];

  @override
  void initState() {
    super.initState();
    _preferredJobTitleController = TextEditingController(
      text: widget.userProfile.preferredJobTitle ?? '',
    );
    _selectedEmploymentType = widget.userProfile.employmentType;
    careerGoals = List.from(widget.userProfile.careerGoals);
    selectedIndustries = List.from(widget.userProfile.preferredIndustries);
    selectedLanguages = List.from(widget.userProfile.languages);
  }

  @override
  void dispose() {
    _preferredJobTitleController.dispose();
    super.dispose();
  }

  void _addCareerGoal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.primaryBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _CareerGoalForm(
        onSave: (goal) {
          setState(() {
            careerGoals.add(goal);
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _editCareerGoal(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.primaryBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _CareerGoalForm(
        initialGoal: careerGoals[index],
        onSave: (goal) {
          setState(() {
            careerGoals[index] = goal;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _deleteCareerGoal(int index) {
    setState(() {
      careerGoals.removeAt(index);
    });
  }

  Future<void> _completeProfileSetup() async {
    if (_preferredJobTitleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your preferred job title'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create final profile
    final finalProfile = widget.userProfile.copyWith(
      preferredJobTitle: _preferredJobTitleController.text,
      employmentType: _selectedEmploymentType,
      preferredIndustries: selectedIndustries,
      languages: selectedLanguages,
      careerGoals: careerGoals,
      isProfileComplete: true,
      updatedAt: DateTime.now(),
      createdAt: widget.userProfile.createdAt ?? DateTime.now(),
    );

    // Save to secure storage
    final storageService = SecureStorageService();
    final saved = await storageService.saveUserProfile(finalProfile);

    if (!mounted) return;

    if (saved) {
      // Navigate to home page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomePage(userProfile: finalProfile)),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving profile. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Goals & Preferences'),
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
              _buildProgressIndicator(4),
              const SizedBox(height: 30),
              _buildSectionTitle('2.3 Career Goals & Preferences'),
              const SizedBox(height: 12),
              _buildDescription(
                'Define your career aspirations and preferences',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                'Preferred Job Title *',
                _preferredJobTitleController,
              ),
              const SizedBox(height: 20),
              _buildEmploymentTypeDropdown(),
              const SizedBox(height: 20),
              _buildSubsectionTitle('Preferred Industries'),
              const SizedBox(height: 12),
              _buildChipGroup(industries, selectedIndustries, (industry) {
                setState(() {
                  if (selectedIndustries.contains(industry)) {
                    selectedIndustries.remove(industry);
                  } else {
                    selectedIndustries.add(industry);
                  }
                });
              }),
              const SizedBox(height: 20),
              _buildSubsectionTitle('Languages'),
              const SizedBox(height: 12),
              _buildChipGroup(languages, selectedLanguages, (language) {
                setState(() {
                  if (selectedLanguages.contains(language)) {
                    selectedLanguages.remove(language);
                  } else {
                    selectedLanguages.add(language);
                  }
                });
              }),
              const SizedBox(height: 20),
              _buildSubsectionTitle('Career Goals'),
              const SizedBox(height: 12),
              if (careerGoals.isEmpty)
                _buildEmptyGoalsState()
              else
                _buildCareerGoalsList(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addCareerGoal,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Career Goal'),
                ),
              ),
              const SizedBox(height: 40),
              _buildFinalButtons(),
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
        color: const Color.fromARGB(255, 40, 219, 216).withOpacity(0.1),
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
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSubsectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
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

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter job title',
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
      ],
    );
  }

  Widget _buildEmploymentTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Employment Type',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: _selectedEmploymentType,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
            dropdownColor: AppColors.primaryBlue,
            underline: Container(),
            hint: const Text(
              'Select employment type',
              style: TextStyle(color: Colors.white54),
            ),
            items: employmentTypes.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedEmploymentType = value;
              });
            },
          ),
        ),
      ],
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

  Widget _buildEmptyGoalsState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Icon(
            Icons.track_changes,
            size: 48,
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No career goals yet',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your career goals to get personalized\nrecommendations',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCareerGoalsList() {
    return Column(
      children: List.generate(careerGoals.length, (index) {
        final goal = careerGoals[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildGoalCard(goal, index),
        );
      }),
    );
  }

  Widget _buildGoalCard(CareerGoal goal, int index) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.goalTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Target: ${goal.targetYear}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Edit'),
                    onTap: () => _editCareerGoal(index),
                  ),
                  PopupMenuItem(
                    child: const Text('Delete'),
                    onTap: () => _deleteCareerGoal(index),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            goal.description,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFinalButtons() {
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
            onPressed: _completeProfileSetup,
            child: const Text('Complete Setup'),
          ),
        ),
      ],
    );
  }
}

/// Career Goal Form Dialog
class _CareerGoalForm extends StatefulWidget {
  final CareerGoal? initialGoal;
  final Function(CareerGoal) onSave;

  const _CareerGoalForm({this.initialGoal, required this.onSave});

  @override
  State<_CareerGoalForm> createState() => _CareerGoalFormState();
}

class _CareerGoalFormState extends State<_CareerGoalForm> {
  late TextEditingController _goalTitleController;
  late TextEditingController _descriptionController;
  late TextEditingController _targetYearController;
  String _selectedPriority = 'Medium';
  List<String> _selectedSkills = [];

  final List<String> availableSkills = [
    'Communication',
    'Leadership',
    'Technical Skills',
    'Data Analysis',
    'Project Management',
    'Problem Solving',
    'Critical Thinking',
  ];

  final List<String> priorityLevels = ['High', 'Medium', 'Low'];

  @override
  void initState() {
    super.initState();
    _goalTitleController = TextEditingController(
      text: widget.initialGoal?.goalTitle ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialGoal?.description ?? '',
    );
    _targetYearController = TextEditingController(
      text:
          widget.initialGoal?.targetYear.toString() ??
          DateTime.now().year.toString(),
    );
    _selectedPriority = widget.initialGoal?.priority ?? 'Medium';
    _selectedSkills = List.from(widget.initialGoal?.requiredSkills ?? []);
  }

  @override
  void dispose() {
    _goalTitleController.dispose();
    _descriptionController.dispose();
    _targetYearController.dispose();
    super.dispose();
  }

  void _saveGoal() {
    if (_goalTitleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _targetYearController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final goal = CareerGoal(
      id: widget.initialGoal?.id,
      goalTitle: _goalTitleController.text,
      description: _descriptionController.text,
      targetYear: int.parse(_targetYearController.text),
      priority: _selectedPriority,
      requiredSkills: _selectedSkills,
    );

    widget.onSave(goal);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Career Goal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField('Goal Title', _goalTitleController),
            const SizedBox(height: 16),
            _buildTextField('Description', _descriptionController, maxLines: 3),
            const SizedBox(height: 16),
            _buildTextField(
              'Target Year',
              _targetYearController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildPriorityDropdown(),
            const SizedBox(height: 16),
            const Text(
              'Required Skills',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableSkills.map((skill) {
                final isSelected = _selectedSkills.contains(skill);
                return FilterChip(
                  label: Text(skill),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      if (isSelected) {
                        _selectedSkills.remove(skill);
                      } else {
                        _selectedSkills.add(skill);
                      }
                    });
                  },
                  backgroundColor: Colors.white.withOpacity(0.1),
                  selectedColor: AppColors.goldAccent,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white70),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveGoal,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Priority',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: _selectedPriority,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
            dropdownColor: AppColors.primaryBlue,
            underline: Container(),
            items: priorityLevels.map((level) {
              return DropdownMenuItem(
                value: level,
                child: Text(level, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedPriority = value ?? 'Medium';
              });
            },
          ),
        ),
      ],
    );
  }
}
