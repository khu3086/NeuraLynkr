import 'package:flutter/material.dart';
import '../../data/quiz_questions.dart';
import '../../theme.dart';
import 'permissions_screen.dart';
import '../../services/api.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int qIdx = 0;
  final Map<int, int> answers = {};

  void _pickAnswer(int optionIdx) {
    setState(() => answers[qIdx] = optionIdx);
    Future.delayed(const Duration(milliseconds: 220), _next);
  }

  Future<void> _next() async {
    if (qIdx < quizQuestions.length - 1) {
      setState(() => qIdx++);
      return;
    }

    final payload = answers.entries
        .map((e) => {'question_idx': e.key, 'answer_idx': e.value})
        .toList();

    try {
      await ApiClient.submitQuizAnswers(payload);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not save quiz: $e')));
      return;
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PermissionsScreen()),
    );
  }

  void _back() {
    if (qIdx > 0) {
      setState(() => qIdx--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = quizQuestions[qIdx];
    final progress = 0.5 + (qIdx + 1) / quizQuestions.length * 0.25;
    final selected = answers[qIdx];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: SynqTheme.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: SynqTheme.textMain,
            size: 20,
          ),
          onPressed: _back,
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
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Question ${qIdx + 1} of ${quizQuestions.length}',
                    style: const TextStyle(
                      fontSize: 11,
                      letterSpacing: 0.8,
                      color: SynqTheme.textSoft,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    q.question,
                    style: const TextStyle(
                      fontSize: 24,
                      color: SynqTheme.primaryDk,
                      fontWeight: FontWeight.w400,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ...List.generate(q.options.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _OptionCard(
                        label: q.options[i],
                        selected: selected == i,
                        onTap: () => _pickAnswer(i),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _OptionCard({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? SynqTheme.fill : SynqTheme.surface,
          border: Border.all(
            color: selected ? SynqTheme.primary : SynqTheme.border,
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? SynqTheme.primary : SynqTheme.border,
                  width: 1.5,
                ),
                color: selected ? SynqTheme.primary : Colors.transparent,
              ),
              alignment: Alignment.center,
              child: selected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: selected ? SynqTheme.primaryDk : SynqTheme.textMain,
                  height: 1.5,
                  fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
