import 'package:flutter/material.dart';
import '../data/mock_matches.dart';
import '../widgets/match_card.dart';
import '../theme.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});
  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen>
    with SingleTickerProviderStateMixin {
  int idx = 0;
  int tabIdx = 2;

  Offset dragOffset = Offset.zero;
  bool isAnimating = false;

  late AnimationController _resetCtrl;
  late Animation<Offset> _resetAnim;

  static const double swipeThreshold = 120.0;
  static const double screenWidth = 400.0;

  @override
  void initState() {
    super.initState();
    _resetCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _resetAnim =
        Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
          CurvedAnimation(parent: _resetCtrl, curve: Curves.easeOut),
        )..addListener(() {
          setState(() => dragOffset = _resetAnim.value);
        });
  }

  @override
  void dispose() {
    _resetCtrl.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (isAnimating) return;
    setState(() => dragOffset += d.delta);
  }

  void _onPanEnd(DragEndDetails d) {
    if (isAnimating) return;
    if (dragOffset.dx > swipeThreshold) {
      _flyOff(true);
    } else if (dragOffset.dx < -swipeThreshold) {
      _flyOff(false);
    } else {
      _springBack();
    }
  }

  void _springBack() {
    _resetAnim =
        Tween<Offset>(begin: dragOffset, end: Offset.zero).animate(
          CurvedAnimation(parent: _resetCtrl, curve: Curves.easeOut),
        )..addListener(() {
          setState(() => dragOffset = _resetAnim.value);
        });
    _resetCtrl.forward(from: 0);
  }

  void _flyOff(bool liked) {
    setState(() => isAnimating = true);
    final target = Offset(
      liked ? screenWidth * 2 : -screenWidth * 2,
      dragOffset.dy,
    );
    _resetAnim =
        Tween<Offset>(begin: dragOffset, end: target).animate(
          CurvedAnimation(parent: _resetCtrl, curve: Curves.easeIn),
        )..addListener(() {
          setState(() => dragOffset = _resetAnim.value);
        });
    _resetCtrl.forward(from: 0).then((_) {
      setState(() {
        idx = (idx + 1) % mockMatches.length;
        dragOffset = Offset.zero;
        isAnimating = false;
      });
    });
  }

  void _triggerButton(bool liked) {
    if (isAnimating) return;
    setState(() => dragOffset = Offset(liked ? 20 : -20, 0));
    _flyOff(liked);
  }

  @override
  Widget build(BuildContext context) {
    final rotation = dragOffset.dx / 1000;
    final likeOpacity = (dragOffset.dx / swipeThreshold).clamp(0.0, 1.0);
    final skipOpacity = (-dragOffset.dx / swipeThreshold).clamp(0.0, 1.0);

    final backIdx = (idx + 1) % mockMatches.length;

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
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.scale(
                          scale: 0.95,
                          child: Opacity(
                            opacity: 0.6,
                            child: MatchCard(match: mockMatches[backIdx]),
                          ),
                        ),
                        Transform.translate(
                          offset: dragOffset,
                          child: Transform.rotate(
                            angle: rotation,
                            child: GestureDetector(
                              onPanUpdate: _onPanUpdate,
                              onPanEnd: _onPanEnd,
                              child: Stack(
                                children: [
                                  MatchCard(match: mockMatches[idx]),
                                  Positioned(
                                    top: 30,
                                    left: 20,
                                    child: Opacity(
                                      opacity: likeOpacity,
                                      child: _StampLabel(
                                        text: 'LIKE',
                                        color: SynqTheme.primary,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 30,
                                    right: 20,
                                    child: Opacity(
                                      opacity: skipOpacity,
                                      child: _StampLabel(
                                        text: 'SKIP',
                                        color: Colors.red.shade400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _Actions(
                    onSkip: () => _triggerButton(false),
                    onLike: () => _triggerButton(true),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StampLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _StampLabel({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: text == 'LIKE' ? -0.2 : 0.2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
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
