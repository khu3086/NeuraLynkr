import 'package:flutter/material.dart';
import '../data/mock_matches.dart';
import '../widgets/match_card.dart';
import '../theme.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});
  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  int idx = 0;
  int tabIdx = 2;

  void next() => setState(() => idx = (idx + 1) % mockMatches.length);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  _ModeTabs(
                    selected: tabIdx,
                    onChange: (i) => setState(() => tabIdx = i),
                  ),
                  const SizedBox(height: 20),
                  Expanded(child: MatchCard(match: mockMatches[idx])),
                  const SizedBox(height: 18),
                  _Actions(onSkip: next, onLike: next),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeTabs extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChange;
  const _ModeTabs({required this.selected, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final labels = ['Friends', 'Network', 'Dating'];
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: SynqTheme.borderSoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final active = i == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChange(i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: active ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: active ? SynqTheme.primary : SynqTheme.textMuted,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  final VoidCallback onSkip;
  final VoidCallback onLike;
  const _Actions({required this.onSkip, required this.onLike});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CircleBtn(icon: '✕', onTap: onSkip, size: 52, border: true),
        const SizedBox(width: 18),
        _CircleBtn(
          icon: '♥',
          onTap: onLike,
          size: 64,
          border: false,
          primary: true,
        ),
        const SizedBox(width: 18),
        _CircleBtn(icon: '★', onTap: () {}, size: 52, border: true),
      ],
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  final double size;
  final bool border;
  final bool primary;
  const _CircleBtn({
    required this.icon,
    required this.onTap,
    required this.size,
    required this.border,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: primary ? SynqTheme.primary : Colors.white,
          shape: BoxShape.circle,
          border: border ? Border.all(color: SynqTheme.border) : null,
          boxShadow: primary
              ? [
                  BoxShadow(
                    color: SynqTheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          icon,
          style: TextStyle(
            fontSize: primary ? 22 : 18,
            color: primary ? Colors.white : SynqTheme.textSoft,
          ),
        ),
      ),
    );
  }
}
