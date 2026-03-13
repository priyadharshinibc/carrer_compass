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
            'Hello ${widget.userProfile.fullName ?? 'User'}! I\'m your AI career assistant. How can I help you today? You can ask me about career advice, recommendations, government schemes, or anything related to your career journey.',
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
    Future.delayed(const Duration(seconds: 1), () {
      final response = _generateResponse(text);
      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
      });
      _scrollToBottom();
    });

    _scrollToBottom();
  }

  String _generateResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    // Career recommendations
    if (lowerMessage.contains('career') ||
        lowerMessage.contains('job') ||
        lowerMessage.contains('recommend')) {
      final recommendations = CareerRecommendationService.recommendCareers(
        widget.userProfile,
      );
      if (recommendations.isNotEmpty) {
        final topCareer = recommendations.first.careerOption;
        return 'Based on your profile, I recommend ${topCareer.title}. ${topCareer.description} It requires skills in ${topCareer.skills.join(', ')} and ${topCareer.educationRequired}.';
      }
    }

    // Government schemes
    if (lowerMessage.contains('scheme') ||
        lowerMessage.contains('government') ||
        lowerMessage.contains('benefit')) {
      final eligibleSchemes = GovernmentSchemeService.getEligibleSchemes(
        widget.userProfile,
      );
      if (eligibleSchemes.isNotEmpty) {
        final scheme = eligibleSchemes.first;
        return 'You might be eligible for ${scheme.name}. ${scheme.description} Benefits include ${scheme.benefits}. Check eligibility: ${scheme.eligibility.entries.map((e) => '${e.key}: ${e.value}').join(', ')}.';
      }
    }

    // Profile related
    if (lowerMessage.contains('profile') ||
        lowerMessage.contains('skill') ||
        lowerMessage.contains('interest')) {
      return 'Your profile shows you have skills in ${widget.userProfile.skills.join(', ')} and interests in ${widget.userProfile.interests.join(', ')}. Your career goals include ${widget.userProfile.careerGoals.isNotEmpty ? widget.userProfile.careerGoals.map((g) => g.goalTitle).join(', ') : 'none set yet'}.';
    }

    // Goals
    if (lowerMessage.contains('goal') || lowerMessage.contains('objective')) {
      if (widget.userProfile.careerGoals.isNotEmpty) {
        return 'Your career goals are: ${widget.userProfile.careerGoals.map((g) => g.goalTitle).join(', ')}. I can help you achieve these through personalized recommendations and resources.';
      } else {
        return 'You haven\'t set any career goals yet. Let me help you define some based on your skills and interests!';
      }
    }

    // Education
    if (lowerMessage.contains('education') ||
        lowerMessage.contains('degree') ||
        lowerMessage.contains('study')) {
      if (widget.userProfile.educationHistory.isNotEmpty) {
        final edu = widget.userProfile.educationHistory.first;
        return 'Your education background: ${edu.degree} from ${edu.institutionName} (${edu.endYear ?? 'Ongoing'}). This opens up many career opportunities!';
      }
    }

    // General responses
    if (lowerMessage.contains('hello') || lowerMessage.contains('hi')) {
      return 'Hello! How can I assist you with your career journey today?';
    }

    if (lowerMessage.contains('thank')) {
      return 'You\'re welcome! I\'m here to help you succeed in your career goals.';
    }

    if (lowerMessage.contains('help')) {
      return 'I can help you with career recommendations, government scheme information, skill development advice, goal setting, and much more. What would you like to know?';
    }

    // Default response
    return 'That\'s an interesting question! Based on your profile, I suggest exploring career options that match your skills in ${widget.userProfile.skills.join(', ')}. Would you like me to recommend some specific careers or provide more details about government schemes?';
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
