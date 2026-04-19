import 'package:flutter/material.dart';
import '../../theme.dart';
import '../swipe_screen.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});
  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool camera = false;
  bool heartRate = false;

  void _finish() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SwipeScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _OnboardingAppBar(progress: 1.0),
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
                    'What we\'d love to measure',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'These signals power your matches. You\'re always in control — grant, revoke, or skip anything.',
                    style: TextStyle(
                      fontSize: 14,
                      color: SynqTheme.textMuted,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _PermCard(
                    title: 'Camera',
                    desc:
                        'Read subtle emotional reactions and eye gaze during short videos. Never recorded.',
                    value: camera,
                    onChange: (v) => setState(() => camera = v),
                  ),
                  const SizedBox(height: 12),
                  _PermCard(
                    title: 'Heart rate',
                    desc:
                        'Measure natural physiological response to scenes and moments. Only aggregate stats.',
                    value: heartRate,
                    onChange: (v) => setState(() => heartRate = v),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: SynqTheme.fill,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('🔒', style: TextStyle(fontSize: 14)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'All biometric data is processed anonymously. '
                            'You can delete everything anytime from settings.',
                            style: TextStyle(
                              fontSize: 12,
                              color: SynqTheme.primaryDk,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _PrimaryButton(label: 'Continue to Synq', onTap: _finish),
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

class _PermCard extends StatelessWidget {
  final String title;
  final String desc;
  final bool value;
  final ValueChanged<bool> onChange;
  const _PermCard({
    required this.title,
    required this.desc,
    required this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SynqTheme.surface,
        border: Border.all(
          color: value ? SynqTheme.primary : SynqTheme.border,
          width: value ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: SynqTheme.textMain,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: SynqTheme.textMuted,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChange,
            activeColor: SynqTheme.primary,
            activeTrackColor: SynqTheme.primaryMid.withOpacity(0.3),
            inactiveTrackColor: SynqTheme.borderSoft,
            inactiveThumbColor: SynqTheme.surface,
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
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: SynqTheme.primary,
          borderRadius: BorderRadius.circular(27),
          boxShadow: [
            BoxShadow(
              color: SynqTheme.primary.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
