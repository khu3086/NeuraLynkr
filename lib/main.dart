import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/onboarding/welcome_screen.dart';

void main() => runApp(const SynqApp());

class SynqApp extends StatelessWidget {
  const SynqApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Synq',
      debugShowCheckedModeBanner: false,
      theme: SynqTheme.build(),
      home: const WelcomeScreen(),
    );
  }
}
