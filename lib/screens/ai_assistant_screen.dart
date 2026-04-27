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
  bool _isResponding = false;

  static const List<String> _quickPrompts = [
    'Recommend the best career for me',
    'Show my skill gaps',
    'Give me a 30 day roadmap',
    'Find schemes I can apply for',
  ];

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    _messages.add(
      ChatMessage(
        text:
            'Hey ${widget.userProfile.fullName ?? 'friend'}! I can help you pick a career, spot skill gaps, build a roadmap, and find schemes. Ask me something specific like “best career for my profile” or “roadmap for bank PO”.',
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
              _buildQuickPrompts(),
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
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.92),
        border: Border(
          top: BorderSide(color: AppColors.goldAccent.withOpacity(0.35)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ask me anything about your career...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.78)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.14),
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
            onPressed: _isResponding ? null : _sendMessage,
            backgroundColor: AppColors.goldAccent,
            child: const Icon(Icons.send, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPrompts() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.tealBlue.withOpacity(0.22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.goldAccent.withOpacity(0.25)),
      ),
      child: SizedBox(
        height: 48,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _quickPrompts.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final prompt = _quickPrompts[index];
            return ActionChip(
              label: Text(prompt),
              backgroundColor: AppColors.goldAccent,
              labelStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
              shape: StadiumBorder(
                side: BorderSide(color: AppColors.goldAccent.withOpacity(0.65)),
              ),
              onPressed: _isResponding
                  ? null
                  : () {
                      _messageController.text = prompt;
                      _sendMessage();
                    },
            );
          },
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _messageController.clear();
      _messages.add(
        ChatMessage(text: 'Thinking...', isUser: false, isTyping: true),
      );
      _isResponding = true;
    });

    _scrollToBottom();

    final response = await _generateResponse(text);

    if (!mounted) return;

    setState(() {
      if (_messages.isNotEmpty && _messages.last.isTyping) {
        _messages.removeLast();
      }
      _messages.add(ChatMessage(text: response, isUser: false));
      _isResponding = false;
    });

    _scrollToBottom();
  }

  Future<String> _generateResponse(String userMessage) async {
    final lowerMessage = userMessage.toLowerCase();
    final intent = _detectIntent(lowerMessage);

    switch (intent) {
      case Intent.careerRoadmap:
        return _warmify(await _buildCareerResponse(userMessage));

      case Intent.skillsGap:
        return _warmify(await _buildSkillGapResponse(userMessage));

      case Intent.govScheme:
        return _warmify(_buildSchemeResponse());

      case Intent.goalHelp:
        return _warmify(_buildGoalResponse());

      case Intent.profileSummary:
        return _warmify(_buildProfileSummary());

      case Intent.greeting:
        return _warmify(
          'Hi! I\'m your career buddy. Tell me a target role or goal and I\'ll give you a focused plan, skill gaps, and the next best action.',
        );

      case Intent.thanks:
        return _warmify('Anytime! Want another roadmap or a tiny next step?');

      case Intent.help:
        return _warmify(
          'I can help with career recommendations, skill gaps, roadmaps, government schemes, and goal planning. Try: "best career for me", "roadmap for data analyst", or "schemes for entrepreneurs".',
        );

      default:
        return _warmify(await _buildDefaultResponse(userMessage));
    }
  }

  Future<String> _buildCareerResponse(String userMessage) async {
    final target = _extractRole(userMessage);
    final recommendations =
        await CareerRecommendationService.analyzeCareerRecommendations(
          widget.userProfile,
        );

    if (recommendations.isEmpty) {
      return 'I could not build a strong match yet. Add a few skills, interests, and a preferred job title, then ask me again.';
    }

    CareerRecommendationInsight? selected;

    if (target != null) {
      final loweredTarget = target.toLowerCase();
      for (final item in recommendations) {
        final title = item.recommendation.careerOption.title.toLowerCase();
        if (title.contains(loweredTarget) || loweredTarget.contains(title)) {
          selected = item;
          break;
        }
      }
    }

    selected ??= recommendations.first;
    final buffer = StringBuffer();
    buffer.writeln('Best match: ${selected.recommendation.careerOption.title}');
    buffer.writeln('Confidence: ${selected.confidence.toStringAsFixed(1)}%');
    buffer.writeln('Why it fits:');
    for (final reason in selected.strengths.take(3)) {
      buffer.writeln('• $reason');
    }

    if (selected.skillGaps.isNotEmpty) {
      buffer.writeln(
        'Skill gaps to close: ${selected.skillGaps.take(4).join(', ')}',
      );
    }

    buffer.writeln('Next actions:');
    for (final action in selected.nextActions.take(3)) {
      buffer.writeln('• $action');
    }

    if (recommendations.length > 1) {
      buffer.writeln('Other good options:');
      for (final item in recommendations.skip(1).take(2)) {
        buffer.writeln(
          '• ${item.recommendation.careerOption.title} (${item.confidence.toStringAsFixed(0)}%)',
        );
      }
    }

    buffer.writeln(
      'If you want, I can turn this into a 30/60/90 day roadmap next.',
    );
    return buffer.toString();
  }

  Future<String> _buildSkillGapResponse(String userMessage) async {
    final recommendations =
        await CareerRecommendationService.analyzeCareerRecommendations(
          widget.userProfile,
        );

    if (recommendations.isEmpty) {
      return 'I need a little more profile data before I can estimate gaps. Add skills, interests, and a job title and I\'ll map them for you.';
    }

    final target = _extractRole(userMessage);
    CareerRecommendationInsight? selected;

    if (target != null) {
      final loweredTarget = target.toLowerCase();
      for (final item in recommendations) {
        final title = item.recommendation.careerOption.title.toLowerCase();
        if (title.contains(loweredTarget) || loweredTarget.contains(title)) {
          selected = item;
          break;
        }
      }
    }

    selected ??= recommendations.first;
    if (selected.skillGaps.isEmpty) {
      return 'For ${selected.recommendation.careerOption.title}, I do not see any major skill gap from your current profile. The next move is to build proof: projects, certificates, or experience.\nNext step: ${selected.nextActions.first}';
    }

    final gapSummary = selected.skillGaps.take(5).join(', ');
    final actionSummary = selected.nextActions.take(3).join('\n• ');
    return 'For ${selected.recommendation.careerOption.title}, the biggest gaps are: $gapSummary.\n\nRecommended actions:\n• $actionSummary';
  }

  String _buildSchemeResponse() {
    final eligibleSchemes = GovernmentSchemeService.getEligibleSchemes(
      widget.userProfile,
    );
    if (eligibleSchemes.isEmpty) {
      return 'I couldn\'t find schemes based on your profile. Add your location, occupation, and income range to unlock matches.';
    }
    final buffer = StringBuffer();
    buffer.writeln(
      'I found ${eligibleSchemes.length} scheme match(es). Top options:',
    );
    for (final scheme in eligibleSchemes.take(3)) {
      final eligibility = scheme.eligibility.entries
          .map((e) => '${e.key}: ${e.value}')
          .join(', ');
      buffer.writeln('• ${scheme.name}');
      buffer.writeln('  ${scheme.description}');
      buffer.writeln('  Benefits: ${scheme.benefits}');
      buffer.writeln('  Eligibility: $eligibility');
    }
    buffer.writeln(
      'If you want, I can narrow this to only scholarships, jobs, or entrepreneurship schemes.',
    );
    return buffer.toString();
  }

  String _buildGoalResponse() {
    if (widget.userProfile.careerGoals.isEmpty) {
      return 'No goals yet. Share one goal and a deadline, and I\'ll turn it into milestones and weekly actions.';
    }
    final buffer = StringBuffer();
    buffer.writeln('Your goals:');
    for (final goal in widget.userProfile.careerGoals.take(5)) {
      buffer.writeln('• ${goal.goalTitle} (target ${goal.targetYear})');
      if (goal.description.isNotEmpty) {
        buffer.writeln('  ${goal.description}');
      }
    }
    buffer.writeln('I can convert one of these into a 30/60/90 plan next.');
    return buffer.toString();
  }

  String _buildProfileSummary() {
    final profileName = widget.userProfile.fullName ?? 'not set';
    return 'Profile snapshot:\nName: $profileName\nSkills: ${widget.userProfile.skills.join(', ').ifEmpty('not set')}\nInterests: ${widget.userProfile.interests.join(', ').ifEmpty('not set')}\nLocation: ${widget.userProfile.location ?? 'not set'}\nPreferred job: ${widget.userProfile.preferredJobTitle ?? 'not set'}\nPreferred industries: ${widget.userProfile.preferredIndustries.join(', ').ifEmpty('not set')}\nTell me a role and I\'ll give you the best next move.';
  }

  Future<String> _buildDefaultResponse(String userMessage) async {
    final recommendations =
        await CareerRecommendationService.analyzeCareerRecommendations(
          widget.userProfile,
        );

    final profileSkills = widget.userProfile.skills;
    final tone = userMessage.contains('?')
        ? 'Here is the clearest answer I can give right now.'
        : 'I can help with that.';

    if (recommendations.isEmpty) {
      return '$tone I need a bit more profile data to give a strong answer. Add skills, interests, and a preferred job title, then ask me again.';
    }

    final top = recommendations.first;
    final buffer = StringBuffer();
    buffer.writeln(
      '$tone Based on your profile, your strongest career match is ${top.recommendation.careerOption.title} (${top.confidence.toStringAsFixed(0)}%).',
    );
    if (profileSkills.isNotEmpty) {
      buffer.writeln(
        'Your current skills: ${profileSkills.take(5).join(', ')}',
      );
    }
    if (top.skillGaps.isNotEmpty) {
      buffer.writeln('Main gap to close: ${top.skillGaps.take(3).join(', ')}');
    }
    buffer.writeln('Best next move: ${top.nextActions.first}');
    buffer.writeln(
      'If you want, ask me for a roadmap, skill gap analysis, or the best schemes for this path.',
    );
    return buffer.toString();
  }

  Intent _detectIntent(String lowerMessage) {
    if (_isCareerQuestion(lowerMessage)) {
      return Intent.careerRoadmap;
    }
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
    if (lowerMessage.contains('goal') ||
        lowerMessage.contains('milestone') ||
        lowerMessage.contains('target')) {
      return Intent.goalHelp;
    }
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

  bool _isCareerQuestion(String lowerMessage) {
    return lowerMessage.contains('best career') ||
        lowerMessage.contains('what career') ||
        lowerMessage.contains('recommend') ||
        lowerMessage.contains('suggest') ||
        lowerMessage.contains('job for me');
  }

  String? _extractRole(String message) {
    final lowered = message.toLowerCase();
    final patterns = [
      ' for ',
      ' as ',
      ' in ',
      ' into ',
      ' to become ',
      ' for the role of ',
    ];
    for (final pattern in patterns) {
      final index = lowered.indexOf(pattern);
      if (index != -1 && index + pattern.length < message.length) {
        return lowered.substring(index + pattern.length).trim();
      }
    }

    final cleaned = lowered
        .replaceAll('best career', '')
        .replaceAll('recommend', '')
        .replaceAll('suggest', '')
        .replaceAll('job', '')
        .trim();
    return cleaned.isEmpty ? null : cleaned;
  }

  String _warmify(String text) {
    if (text.contains('😊') ||
        text.contains('🙌') ||
        text.contains('💪') ||
        text.contains('🙂')) {
      return text;
    }
    return '🙂 $text';
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
  final bool isTyping;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isTyping = false,
  });
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
