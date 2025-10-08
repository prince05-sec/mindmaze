import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/community_provider.dart';
import '../../utils/app_theme.dart';
import '../../models/community_message_model.dart';

class CommunityWallScreen extends StatefulWidget {
  const CommunityWallScreen({super.key});

  @override
  State<CommunityWallScreen> createState() => _CommunityWallScreenState();
}

class _CommunityWallScreenState extends State<CommunityWallScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isAnonymous = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Wall'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F9FF), Color(0xFFE6F3FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Consumer<CommunityProvider>(
                builder: (context, provider, child) {
                  final messages = provider.messages;
                  if (messages.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return _buildMessageCard(provider, message);
                    },
                  );
                },
              ),
            ),
            _buildComposer(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.spa, size: 48, color: AppTheme.primaryColor),
          SizedBox(height: 16),
          Text(
            'Leave a gentle note of support. Your words might brighten someone\'s day.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(CommunityProvider provider, CommunityMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child: Text(
                  message.isAnonymous ? 'A' : message.userId.characters.first.toUpperCase(),
                  style: const TextStyle(color: AppTheme.primaryColor),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.isAnonymous ? 'Anonymous Ally' : message.userId,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  Text(
                    _formatTimestamp(message.timestamp),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(
            message.message,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          if (message.tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: message.tags
                  .map(
                    (tag) => Chip(
                      label: Text('#$tag'),
                      backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
                      labelStyle: const TextStyle(color: AppTheme.primaryColor),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              for (final entry in message.reactions.entries)
                _ReactionButton(
                  emoji: entry.key,
                  count: entry.value,
                  onTap: () => provider.reactToMessage(message.id, entry.key),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComposer(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  'Share anonymously',
                  style: TextStyle(color: AppTheme.textSecondaryColor),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: _isAnonymous,
                  onChanged: (value) {
                    setState(() => _isAnonymous = value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Offer a gentle note or words of encouragement...'
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _submit(context),
                icon: const Icon(Icons.send),
                label: const Text('Share warmth'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final provider = context.read<CommunityProvider>();
    final text = _controller.text;
    try {
      await provider.sendMessage('local_user', text, isAnonymous: _isAnonymous);
      _controller.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    if (difference.inMinutes < 1) return 'just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} mins ago';
    if (difference.inHours < 24) return '${difference.inHours} hrs ago';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}

class _ReactionButton extends StatelessWidget {
  final String emoji;
  final int count;
  final VoidCallback onTap;

  const _ReactionButton({
    required this.emoji,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 6),
              Text(
                count.toString(),
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
