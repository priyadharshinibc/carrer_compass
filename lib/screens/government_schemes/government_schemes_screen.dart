import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/user_profile.dart';
import '../../services/government_scheme_service.dart';
import '../../themes/app_theme.dart';

/// Government Schemes screen.
///
/// Displays schemes the user is eligible for, with details on benefits and eligibility.
class GovernmentSchemesScreen extends StatelessWidget {
  final UserProfile userProfile;

  const GovernmentSchemesScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    final eligibleSchemes = GovernmentSchemeService.getEligibleSchemes(
      userProfile,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Government Schemes'),
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
                'Eligible Government Schemes',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Schemes from ${userProfile.location?.contains('Tamil Nadu') == true ? 'Tamil Nadu and India' : 'India'} you may qualify for.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              if (eligibleSchemes.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'No eligible schemes found based on your profile.\nUpdate your profile for better matches.',
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
                    itemCount: eligibleSchemes.length,
                    itemBuilder: (context, index) {
                      final scheme = eligibleSchemes[index];
                      return Card(
                        color: Colors.white.withOpacity(0.08),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(
                            scheme.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            '${scheme.category} - ${scheme.government}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    SchemeDetailScreen(scheme: scheme),
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

class SchemeDetailScreen extends StatelessWidget {
  final GovernmentScheme scheme;

  const SchemeDetailScreen({super.key, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(scheme.name),
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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                scheme.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${scheme.category} - ${scheme.government}',
                style: TextStyle(color: AppColors.goldAccent, fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                'Description',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                scheme.description,
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              const SizedBox(height: 20),
              Text(
                'Benefits',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                scheme.benefits,
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              const SizedBox(height: 20),
              Text(
                'Eligibility Criteria',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              ...scheme.eligibility.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '${entry.key}: ${entry.value}',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                );
              }),
              const SizedBox(height: 20),
              Offstage(
                offstage: scheme.applyUrl == null,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final url = Uri.parse(scheme.applyUrl!);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Could not open the application page.',
                              ),
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.open_in_browser),
                    label: const Text('Apply Now'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
