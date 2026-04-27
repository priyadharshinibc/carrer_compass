import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/career_recommendation_service.dart';
import '../services/government_scheme_service.dart';
import '../themes/app_theme.dart';

/// AI Assistant Screen
///
/// A personalized AI chat assistant that provides career guidance and advice.
class AIAssistantScreen extends StatefulWidget {
  final UserProfile userProfile;

  const AIAssistantScreen({super.key, required this.userProfile});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    _messages.add(
      ChatMessage(
        text:
            'Hey ${widget.userProfile.fullName ?? 'friend'}! 😊 I\'m here to cheer you on and help with careers, roadmaps, and schemes. What\'s on your mind?',
        isUser: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
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
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return _buildMessageBubble(message);
                  },
                ),
              ),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? AppColors.goldAccent.withOpacity(0.8)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: TextStyle(color: message.isUser ? Colors.black : Colors.white),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white.withOpacity(0.05),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ask me anything about your career...',
                hintStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: _sendMessage,
            backgroundColor: AppColors.goldAccent,
            child: const Icon(Icons.send, color: Colors.black),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _messageController.clear();
    });

    // Simulate typing delay
    Future.delayed(const Duration(milliseconds: 600), () async {
      final response = await _generateResponse(text);
      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
      });
      _scrollToBottom();
    });

    _scrollToBottom();
  }

  Future<String> _generateResponse(String userMessage) async {
    final lowerMessage = userMessage.toLowerCase();
    final intent = _detectIntent(lowerMessage);

    switch (intent) {
      case Intent.careerRoadmap:
        final target = _extractRole(userMessage);
        final recommendations =
            await CareerRecommendationService.recommendCareers(
              widget.userProfile,
            );
        if (target != null) {
          final match = recommendations
              .map((r) => r.careerOption)
              .firstWhere(
                (c) => c.title.toLowerCase().contains(target),
                orElse: () => recommendations.first.careerOption,
              );
          return _warmify(_buildCareerRoadmap(match));
        }
        if (recommendations.isNotEmpty) {
          return _warmify(
            _buildCareerRoadmap(recommendations.first.careerOption),
          );
        }
        return _warmify(
          'I couldn\'t find a good match yet. Add some skills/interests to your profile and try again— we\'ll nail this together!',
        );

      case Intent.skillsGap:
        return _warmify(_buildSkillGapResponse());

      case Intent.govScheme:
        return _warmify(_buildSchemeResponse());

      case Intent.goalHelp:
        return _warmify(_buildGoalResponse());

      case Intent.profileSummary:
        return _warmify(_buildProfileSummary());

      case Intent.greeting:
        return _warmify(
          'Hi! I\'m your career buddy—ask me for any roadmap and I\'ll keep it short, clear, and doable.',
        );

      case Intent.thanks:
        return _warmify('Anytime! Want another roadmap or a tiny next step?');

      case Intent.help:
        return _warmify(
          'I can be your ChatGPT-style friend for careers: roadmaps, skill gaps, government schemes, and next actions. Try: "Roadmap for Bank PO" or "Schemes for women entrepreneurs".',
        );

      default:
        return _warmify(
          'Tell me a role or goal (e.g., "become a data analyst" or "clear state PSC"). I\'ll share a supportive, realistic plan.',
        );
    }
  }

  String _buildCareerRoadmap(CareerOption career) {
    final buffer = StringBuffer();
    final skills = career.skills.join(', ');
    buffer.writeln('Top match: ${career.title}');
    buffer.writeln(career.description);
    buffer.writeln('You\'ll need: $skills');
    buffer.writeln('Education: ${career.educationRequired}');
    buffer.writeln('Roadmap:');
    buffer.writeln(
      '• Month 0–1: Foundation — cover basics, glossary, and daily 45-min practice.',
    );
    buffer.writeln(
      '• Month 1–2: Skills — follow one solid course; build 2 small portfolio pieces or mock case studies.',
    );
    buffer.writeln(
      '• Month 2–3: Credential — attempt one certification/exam or license relevant to ${career.title}.',
    );
    buffer.writeln(
      '• Ongoing: Applications — 5–10 targeted applications per week; practice interview/aptitude weekly.',
    );
    buffer.writeln(
      'You got this! Want a tighter 30/60/90 or specific course links?',
    );
    return buffer.toString();
  }

  String _buildSchemeResponse() {
    final eligibleSchemes = GovernmentSchemeService.getEligibleSchemes(
      widget.userProfile,
    );
    if (eligibleSchemes.isEmpty) {
      return 'I couldn\'t find schemes based on your profile. Add your location, occupation, and income range to unlock matches.';
    }
    final scheme = eligibleSchemes.first;
    final eligibility = scheme.eligibility.entries
        .map((e) => '${e.key}: ${e.value}')
        .join(', ');
    return 'Closest match: ${scheme.name}\nWhat it is: ${scheme.description}\nBenefits: ${scheme.benefits}\nEligibility hints: $eligibility\nAction: Tap “Apply Now” to open the official portal and submit.';
  }

  String _buildSkillGapResponse() {
    final skills = widget.userProfile.skills;
    if (skills.isEmpty) {
      return 'I don\'t see skills yet—share 3 you have and 3 you want, and I\'ll map gaps + learning steps. We\'ll keep it light and doable. 💪';
    }
    return 'You already have: ${skills.join(', ')}.\nPick a target role and I\'ll map gaps + 3 resources each. Example: "Gap for Railway JE" or "Gap for Registered Nurse".';
  }

  String _buildGoalResponse() {
    if (widget.userProfile.careerGoals.isEmpty) {
      return 'No goals yet. Drop one goal + deadline + priority (e.g., "Bank PO by Dec 2026, high priority") and I\'ll turn it into milestones. I\'m with you. 🙌';
    }
    final goals = widget.userProfile.careerGoals
        .map((g) => '${g.goalTitle} (target ${g.targetYear})')
        .join('; ');
    return 'Your goals: $goals.\nWant me to break one into 30/60/90 milestones and weekly actions?';
  }

  String _buildProfileSummary() {
    return 'Here’s your snapshot:\nSkills: ${widget.userProfile.skills.join(', ').ifEmpty('not set')}\nInterests: ${widget.userProfile.interests.join(', ').ifEmpty('not set')}\nLocation: ${widget.userProfile.location ?? 'not set'}\nJob title: ${widget.userProfile.preferredJobTitle ?? 'not set'}\nTell me a role and I\'ll draft a friendly roadmap.';
  }

  Intent _detectIntent(String lowerMessage) {
    if (lowerMessage.contains('roadmap') ||
        lowerMessage.contains('plan') ||
        lowerMessage.contains('become')) {
      return Intent.careerRoadmap;
    }
    if (lowerMessage.contains('gap') ||
        lowerMessage.contains('skill gap') ||
        lowerMessage.contains('learn')) {
      return Intent.skillsGap;
    }
    if (lowerMessage.contains('scheme') ||
        lowerMessage.contains('government') ||
        lowerMessage.contains('benefit')) {
      return Intent.govScheme;
    }
    if (lowerMessage.contains('goal')) return Intent.goalHelp;
    if (lowerMessage.contains('profile') || lowerMessage.contains('summary')) {
      return Intent.profileSummary;
    }
    if (lowerMessage.contains('hello') ||
        lowerMessage.contains('hi') ||
        lowerMessage.contains('hey')) {
      return Intent.greeting;
    }
    if (lowerMessage.contains('thank')) return Intent.thanks;
    if (lowerMessage.contains('help')) return Intent.help;
    return Intent.defaultIntent;
  }

  String? _extractRole(String message) {
    final lowered = message.toLowerCase();
    // crude extraction: look for words after 'for' or 'as'
    final forIndex = lowered.indexOf(' for ');
    if (forIndex != -1 && forIndex + 5 < message.length) {
      return lowered.substring(forIndex + 5).trim();
    }
    final asIndex = lowered.indexOf(' as ');
    if (asIndex != -1 && asIndex + 4 < message.length) {
      return lowered.substring(asIndex + 4).trim();
    }
    return null;
  }

  String _warmify(String text) {
    // sprinkle a supportive emoji only if not already present to keep it subtle
    final emoji = '🙂';
    if (text.contains('😊') ||
        text.contains('🙌') ||
        text.contains('💪') ||
        text.contains('🙂')) {
      return text;
    }
    return '$emoji $text';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

enum Intent {
  careerRoadmap,
  skillsGap,
  govScheme,
  goalHelp,
  profileSummary,
  greeting,
  thanks,
  help,
  defaultIntent,
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
