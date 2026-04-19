import 'package:flutter/material.dart';
import '../../theme.dart';
import 'name_age_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  Container(
                    width: 96,
                    height: 96,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: SynqTheme.fill,
                      shape: BoxShape.circle,
                      border: Border.all(color: SynqTheme.border, width: 2),
                    ),
                    child: const Text(
                      '✦',
                      style: TextStyle(fontSize: 44, color: SynqTheme.primary),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Synq',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 42,
                      color: SynqTheme.primaryDk,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Beyond profile pictures.\nMatched by the things you feel.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: SynqTheme.textMuted,
                      height: 1.6,
                    ),
                  ),
                  const Spacer(flex: 3),
                  _PrimaryButton(
                    label: 'Get started',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NameAgeScreen()),
                    ),
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'I already have an account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: SynqTheme.textMuted,
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
