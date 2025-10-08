import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

/// Legacy placeholder retained so routes still resolve while the
/// voice capture capability is temporarily disabled.
class VoiceJournalScreen extends StatelessWidget {
  const VoiceJournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Journal'),
        centerTitle: true,
      ),
      body: const _VoiceJournalUnavailableBody(),
    );
  }
}

class _VoiceJournalUnavailableBody extends StatelessWidget {
  const _VoiceJournalUnavailableBody();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8F9FF), Color(0xFFE6F3FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.mic_off, size: 64, color: Colors.grey),
              SizedBox(height: 24),
              Text(
                'Voice journaling is temporarily unavailable.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'We removed the speech-recognition dependency so you can continue using the app while we work on an alternative.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
