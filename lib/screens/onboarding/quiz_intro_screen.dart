import 'package:flutter/material.dart';
import '../../theme.dart';
import 'permissions_screen.dart';

class QuizIntroScreen extends StatelessWidget {
  const QuizIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _OnboardingAppBar(progress: 0.5),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'A quick personality quiz',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Five questions. About two minutes. '
                    'We use your answers to find the people you\'ll click with.',
                    style: TextStyle(
                      fontSize: 14,
                      color: SynqTheme.textMuted,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const _InfoCard(
                    emoji: '✎',
                    title: 'Honest, not optimized',
                    subtitle:
                        'Answer how you actually feel, not how you want to seem.',
                  ),
                  const SizedBox(height: 12),
                  const _InfoCard(
                    emoji: '◉',
                    title: 'Not visible to others',
                    subtitle: 'Only the algorithm sees your answers.',
                  ),
                  const SizedBox(height: 12),
                  const _InfoCard(
                    emoji: '↻',
                    title: 'You can retake it',
                    subtitle: 'Update anytime from settings as you change.',
                  ),
                  const Spacer(),
                  _PrimaryButton(
                    label: 'Skip for now',
                    filled: false,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PermissionsScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _PrimaryButton(
                    label: 'Start the quiz',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PermissionsScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  const _InfoCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SynqTheme.surface,
        border: Border.all(color: SynqTheme.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: SynqTheme.fill,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 16, color: SynqTheme.primary),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: SynqTheme.textMain,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: SynqTheme.textMuted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double progress;
  const _OnboardingAppBar({required this.progress});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: SynqTheme.bg,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: SynqTheme.textMain, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: SizedBox(
        width: 180,
        height: 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: SynqTheme.borderSoft,
            valueColor: const AlwaysStoppedAnimation(SynqTheme.primary),
          ),
        ),
      ),
      centerTitle: true,
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool filled;
  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: filled ? SynqTheme.primary : Colors.transparent,
          border: filled ? null : Border.all(color: SynqTheme.border),
          borderRadius: BorderRadius.circular(27),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: filled ? Colors.white : SynqTheme.textMuted,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
