import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../themes/app_theme.dart';
import 'career_goals_screen.dart';

/// Education Screen - Step 3
/// Collects user's educational background
class EducationScreen extends StatefulWidget {
  final UserProfile userProfile;

  const EducationScreen({super.key, required this.userProfile});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  List<Education> educationHistory = [];

  final List<String> degreeTypes = [
    'High School',
    'Associate Degree',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'PhD',
    'Diploma',
    'Certificate',
  ];

  @override
  void initState() {
    super.initState();
    educationHistory = List.from(widget.userProfile.educationHistory);
  }

  void _addEducation() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.primaryBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _EducationForm(
        onSave: (education) {
          setState(() {
            educationHistory.add(education);
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _editEducation(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.primaryBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _EducationForm(
        initialEducation: educationHistory[index],
        onSave: (education) {
          setState(() {
            educationHistory[index] = education;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _deleteEducation(int index) {
    setState(() {
      educationHistory.removeAt(index);
    });
  }

  void _proceedToNextStep() {
    final updatedProfile = widget.userProfile.copyWith(
      educationHistory: educationHistory,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CareerGoalsScreen(userProfile: updatedProfile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Educational Background'),
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
              _buildProgressIndicator(3),
              const SizedBox(height: 30),
              _buildSectionTitle('2.2 Collect Educational Background'),
              const SizedBox(height: 12),
              _buildDescription('Add your educational qualifications'),
              const SizedBox(height: 20),
              if (educationHistory.isEmpty)
                _buildEmptyState()
              else
                _buildEducationList(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addEducation,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Education'),
                ),
              ),
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
        fontSize: 18,
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

  Widget _buildEmptyState() {
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
            Icons.school_outlined,
            size: 48,
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No education added yet',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your educational background to help us\nrecommend suitable career paths',
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

  Widget _buildEducationList() {
    return Column(
      children: List.generate(educationHistory.length, (index) {
        final edu = educationHistory[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildEducationCard(edu, index),
        );
      }),
    );
  }

  Widget _buildEducationCard(Education education, int index) {
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
                      education.degree,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      education.institutionName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Edit'),
                    onTap: () => _editEducation(index),
                  ),
                  PopupMenuItem(
                    child: const Text('Delete'),
                    onTap: () => _deleteEducation(index),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${education.fieldOfStudy} • ${education.startYear}-${education.isCurrentlyStudying ? 'Present' : education.endYear}',
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          if (education.gpa != null) ...[
            const SizedBox(height: 8),
            Text(
              'GPA: ${education.gpa}',
              style: const TextStyle(color: AppColors.goldAccent, fontSize: 12),
            ),
          ],
        ],
      ),
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

/// Education Form Dialog
class _EducationForm extends StatefulWidget {
  final Education? initialEducation;
  final Function(Education) onSave;

  const _EducationForm({this.initialEducation, required this.onSave});

  @override
  State<_EducationForm> createState() => _EducationFormState();
}

class _EducationFormState extends State<_EducationForm> {
  late TextEditingController _institutionController;
  late TextEditingController _degreeController;
  late TextEditingController _fieldController;
  late TextEditingController _startYearController;
  late TextEditingController _endYearController;
  late TextEditingController _gpaController;
  late TextEditingController _descriptionController;
  bool _isCurrentlyStudying = false;

  final List<String> degreeTypes = [
    'High School',
    'Associate Degree',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'PhD',
    'Diploma',
    'Certificate',
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _institutionController = TextEditingController(
      text: widget.initialEducation?.institutionName ?? '',
    );
    _degreeController = TextEditingController(
      text: widget.initialEducation?.degree ?? '',
    );
    _fieldController = TextEditingController(
      text: widget.initialEducation?.fieldOfStudy ?? '',
    );
    _startYearController = TextEditingController(
      text: widget.initialEducation?.startYear.toString() ?? '',
    );
    _endYearController = TextEditingController(
      text: widget.initialEducation?.endYear?.toString() ?? '',
    );
    _gpaController = TextEditingController(
      text: widget.initialEducation?.gpa?.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialEducation?.description ?? '',
    );
    _isCurrentlyStudying =
        widget.initialEducation?.isCurrentlyStudying ?? false;
  }

  @override
  void dispose() {
    _institutionController.dispose();
    _degreeController.dispose();
    _fieldController.dispose();
    _startYearController.dispose();
    _endYearController.dispose();
    _gpaController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveEducation() {
    if (_institutionController.text.isEmpty ||
        _degreeController.text.isEmpty ||
        _fieldController.text.isEmpty ||
        _startYearController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final education = Education(
      institutionName: _institutionController.text,
      degree: _degreeController.text,
      fieldOfStudy: _fieldController.text,
      startYear: int.parse(_startYearController.text),
      endYear: _endYearController.text.isNotEmpty
          ? int.parse(_endYearController.text)
          : null,
      isCurrentlyStudying: _isCurrentlyStudying,
      gpa: _gpaController.text.isNotEmpty
          ? double.parse(_gpaController.text)
          : null,
      description: _descriptionController.text,
    );

    widget.onSave(education);
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
              'Add Education',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField('Institution Name', _institutionController),
            const SizedBox(height: 16),
            _buildTextField('Degree', _degreeController),
            const SizedBox(height: 16),
            _buildTextField('Field of Study', _fieldController),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Start Year',
                    _startYearController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    'End Year',
                    _endYearController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _isCurrentlyStudying,
                  onChanged: (value) {
                    setState(() {
                      _isCurrentlyStudying = value ?? false;
                    });
                  },
                ),
                const Text(
                  'Currently Studying',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'GPA (Optional)',
              _gpaController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Description (Optional)',
              _descriptionController,
              maxLines: 3,
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
                    onPressed: _saveEducation,
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
}
