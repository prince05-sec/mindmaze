import 'package:flutter/material.dart';

class BreathingWidget extends StatefulWidget {
  final Duration inhale;
  final Duration hold;
  final Duration exhale;

  const BreathingWidget({
    super.key,
    this.inhale = const Duration(seconds: 4),
    this.hold = const Duration(seconds: 4),
    this.exhale = const Duration(seconds: 6),
  });

  @override
  State<BreathingWidget> createState() => _BreathingWidgetState();
}

class _BreathingWidgetState extends State<BreathingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    final totalDuration = widget.inhale + widget.hold + widget.exhale;
    _controller = AnimationController(vsync: this, duration: totalDuration)
      ..repeat();

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 1.1).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: widget.inhale.inMilliseconds.toDouble(),
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.1),
        weight: widget.hold.inMilliseconds.toDouble(),
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 0.8).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: widget.exhale.inMilliseconds.toDouble(),
      ),
    ]).animate(_controller);

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.4, end: 0.8),
        weight: widget.inhale.inMilliseconds.toDouble(),
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(0.8),
        weight: widget.hold.inMilliseconds.toDouble(),
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 0.4),
        weight: widget.exhale.inMilliseconds.toDouble(),
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(_opacityAnimation.value),
                  ],
                ),
              ),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF6B73FF).withOpacity(0.7),
                        const Color(0xFF9DCEFF).withOpacity(0.7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _phaseInstruction(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Inhale • Hold • Exhale',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
                letterSpacing: 1.2,
              ),
            ),
          ],
        );
      },
    );
  }

  String _phaseInstruction() {
    final progress = _controller.value;
    final inhaleEnd = widget.inhale.inMilliseconds /
        (widget.inhale + widget.hold + widget.exhale).inMilliseconds;
    final holdEnd = (widget.inhale + widget.hold).inMilliseconds /
        (widget.inhale + widget.hold + widget.exhale).inMilliseconds;

    if (progress <= inhaleEnd) {
      return 'Inhale';
    } else if (progress <= holdEnd) {
      return 'Hold';
    }
    return 'Exhale';
  }
}
