import 'package:flutter/material.dart';
import 'theme.dart';
import 'services/api.dart';
import 'screens/onboarding/welcome_screen.dart';
import 'screens/swipe_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient.init();
  runApp(const SynqApp());
}

class SynqApp extends StatelessWidget {
  const SynqApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Synq',
      debugShowCheckedModeBanner: false,
      theme: SynqTheme.build(),
      home: ApiClient.isLoggedIn ? const SwipeScreen() : const WelcomeScreen(),
    );
  }
}
