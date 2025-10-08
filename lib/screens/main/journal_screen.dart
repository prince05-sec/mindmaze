import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/journal_entry_model.dart';
import '../../providers/journal_provider.dart';
import '../../utils/app_theme.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Sanctuary'),
        centerTitle: true,
      ),
      body: Consumer<JournalProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final entries = provider.entries;
          if (entries.isEmpty) {
            return _emptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return _JournalCard(entry: entry);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddOptions(context),
        icon: const Icon(Icons.add),
        label: const Text('New Entry'),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.book_outlined,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your sanctuary awaits',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Capture your thoughts, feelings, and reflections in this safe space. Every entry is a step in your journey of self-discovery.',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showAddOptions(context),
              icon: const Icon(Icons.add),
              label: const Text('Start Your First Entry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: AppTheme.primaryColor.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit, color: AppTheme.primaryColor),
                  title: const Text('Write a journal entry'),
                  subtitle: const Text('Capture your thoughts with words'),
                  onTap: () {
                    Navigator.pop(context);
                    _showTextJournalDialog(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showTextJournalDialog(BuildContext context) async {
    final provider = context.read<JournalProvider>();
    final formKey = GlobalKey<FormState>();
    final entryController = TextEditingController();
    final tagsController = TextEditingController();
    String mood = 'calm';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text('New Journal Entry'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: mood,
                    decoration: const InputDecoration(labelText: 'Mood'),
                    items: const [
                      DropdownMenuItem(value: 'calm', child: Text('Calm')),
                      DropdownMenuItem(value: 'happy', child: Text('Happy')),
                      DropdownMenuItem(value: 'neutral', child: Text('Neutral')),
                      DropdownMenuItem(value: 'sad', child: Text('Sad')),
                      DropdownMenuItem(value: 'anxious', child: Text('Anxious')),
                      DropdownMenuItem(value: 'angry', child: Text('Angry')),
                    ],
                    onChanged: (value) => mood = value ?? 'calm',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: entryController,
                    minLines: 4,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'What would you like to express?',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Share at least a few words';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: tagsController,
                    decoration: const InputDecoration(
                      labelText: 'Tags (comma separated)',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  try {
                    final tags = tagsController.text
                        .split(',')
                        .map((tag) => tag.trim())
                        .where((tag) => tag.isNotEmpty)
                        .toList();
                    await provider.addEntry(
                      mood: mood,
                      entry: entryController.text.trim(),
                      tags: tags,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Journal entry saved successfully!'),
                        backgroundColor: AppTheme.successColor,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to save journal entry. Please try again.'),
                        backgroundColor: AppTheme.errorColor,
                      ),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    entryController.dispose();
    tagsController.dispose();
  }
}

class _JournalCard extends StatelessWidget {
  final JournalEntry entry;

  const _JournalCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.mood.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(entry.date),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
              if (entry.isVoice)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.mic, size: 16, color: AppTheme.primaryColor),
                      SizedBox(width: 4),
                      Text(
                        'Voice',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            entry.entry,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          if (entry.tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: entry.tags
                  .map(
                    (tag) => Chip(
                      label: Text('#$tag'),
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      labelStyle: const TextStyle(color: AppTheme.primaryColor),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            'Tone: ${entry.tone}',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
