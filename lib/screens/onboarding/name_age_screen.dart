import 'package:flutter/material.dart';
import '../../theme.dart';
import 'quiz_intro_screen.dart';

class NameAgeScreen extends StatefulWidget {
  const NameAgeScreen({super.key});
  @override
  State<NameAgeScreen> createState() => _NameAgeScreenState();
}

class _NameAgeScreenState extends State<NameAgeScreen> {
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();

  bool get _valid =>
      _nameCtrl.text.trim().isNotEmpty &&
      int.tryParse(_ageCtrl.text) != null &&
      int.parse(_ageCtrl.text) >= 18;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _OnboardingAppBar(progress: 0.25),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Let\'s start with the basics',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This is how you\'ll appear to your matches.',
                    style: TextStyle(fontSize: 14, color: SynqTheme.textMuted),
                  ),
                  const SizedBox(height: 36),
                  _Field(
                    label: 'Your name',
                    controller: _nameCtrl,
                    onChange: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 20),
                  _Field(
                    label: 'Age',
                    controller: _ageCtrl,
                    keyboardType: TextInputType.number,
                    onChange: (_) => setState(() {}),
                  ),
                  const Spacer(),
                  _PrimaryButton(
                    label: 'Continue',
                    enabled: _valid,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QuizIntroScreen(),
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

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChange;
  const _Field({
    required this.label,
    required this.controller,
    required this.onChange,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: 0.6,
            color: SynqTheme.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChange,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 16, color: SynqTheme.textMain),
          decoration: InputDecoration(
            filled: true,
            fillColor: SynqTheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: SynqTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: SynqTheme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: SynqTheme.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
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
  final bool enabled;
  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: enabled ? SynqTheme.primary : SynqTheme.borderSoft,
          borderRadius: BorderRadius.circular(27),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: enabled ? Colors.white : SynqTheme.textSoft,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
