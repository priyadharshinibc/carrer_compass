import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../themes/app_theme.dart';
import 'skills_interests_screen.dart';

/// Basic Profile Information Screen - Step 1
/// Collects user's personal information
class BasicProfileScreen extends StatefulWidget {
  final UserProfile? existingProfile;

  const BasicProfileScreen({super.key, this.existingProfile});

  @override
  State<BasicProfileScreen> createState() => _BasicProfileScreenState();
}

class _BasicProfileScreenState extends State<BasicProfileScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _bioController;

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _fullNameController = TextEditingController(
      text: widget.existingProfile?.fullName ?? '',
    );
    _emailController = TextEditingController(
      text: widget.existingProfile?.email ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.existingProfile?.phoneNumber ?? '',
    );
    _locationController = TextEditingController(
      text: widget.existingProfile?.location ?? '',
    );
    _bioController = TextEditingController(
      text: widget.existingProfile?.bio ?? '',
    );
    _selectedDate = widget.existingProfile?.dateOfBirth;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _proceedToNextStep() {
    if (_validateInputs()) {
      final profile = UserProfile(
        fullName: _fullNameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        location: _locationController.text,
        bio: _bioController.text,
        dateOfBirth: _selectedDate,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SkillsInterestsScreen(userProfile: profile),
        ),
      );
    }
  }

  bool _validateInputs() {
    if (_fullNameController.text.isEmpty) {
      _showErrorSnackBar('Please enter your full name');
      return false;
    }
    if (_emailController.text.isEmpty) {
      _showErrorSnackBar('Please enter your email');
      return false;
    }
    if (!_isValidEmail(_emailController.text)) {
      _showErrorSnackBar('Please enter a valid email');
      return false;
    }
    if (_phoneController.text.isNotEmpty &&
        !_isValidPhone(_phoneController.text)) {
      _showErrorSnackBar('Please enter a valid phone number');
      return false;
    }
    return true;
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 10 && digits.length <= 15;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Profile'),
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
              _buildProgressIndicator(),
              const SizedBox(height: 30),
              _buildSectionTitle('Basic Information'),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _fullNameController,
                label: 'Full Name',
                icon: Icons.person,
                hintText: 'John Doe',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                icon: Icons.email,
                hintText: 'john@example.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number (Optional)',
                icon: Icons.phone,
                hintText: '+1 (555) 000-0000',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _locationController,
                label: 'Location (Optional)',
                icon: Icons.location_on,
                hintText: 'City, Country',
              ),
              const SizedBox(height: 16),
              _buildDatePickerField(),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _bioController,
                label: 'Bio (Optional)',
                icon: Icons.description,
                hintText: 'Tell us about yourself...',
                maxLines: 3,
              ),
              const SizedBox(height: 40),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildProgressStep(1, true, 'Basic Info'),
          _buildProgressLine(),
          _buildProgressStep(2, false, 'Skills'),
          _buildProgressLine(),
          _buildProgressStep(3, false, 'Education'),
          _buildProgressLine(),
          _buildProgressStep(4, false, 'Goals'),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hintText,
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
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: Colors.white70),
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

  Widget _buildDatePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date of Birth (Optional)',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white70),
                const SizedBox(width: 12),
                Text(
                  _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'Select Date',
                  style: TextStyle(
                    color: _selectedDate != null
                        ? Colors.white
                        : Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
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
