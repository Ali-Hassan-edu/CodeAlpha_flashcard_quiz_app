// ═══════════════════════════════════════════════════════════════════
// flashcard_widget.dart  —  Animated 3-D flip card component
// ═══════════════════════════════════════════════════════════════════
// The card flips on the Y axis with a smooth ease-in-out curve.
// Front  = question  (white / dark-card surface, indigo badge)
// Back   = answer    (indigo-gradient surface, white text)
// ═══════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlashcardWidget extends StatefulWidget {
  final String question;
  final String answer;
  final bool   showAnswer;   // driven from provider

  const FlashcardWidget({
    Key? key,
    required this.question,
    required this.answer,
    required this.showAnswer,
  }) : super(key: key);

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget>
    with SingleTickerProviderStateMixin {

  late AnimationController _ctrl;
  late Animation<double>   _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 500),
    );
    // 0 = front face visible, pi = back face visible
    _anim = Tween<double>(begin: 0, end: math.pi).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void didUpdateWidget(FlashcardWidget old) {
    super.didUpdateWidget(old);
    // React to external flip command
    if (widget.showAnswer != old.showAnswer) {
      widget.showAnswer ? _ctrl.forward() : _ctrl.reverse();
    }
    // If the card itself changed (Next/Prev), reset instantly
    if (widget.question != old.question) {
      _ctrl.reset();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final isPastHalf = _anim.value > (math.pi / 2);
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0008) // perspective depth
            ..rotateY(_anim.value),
          alignment: Alignment.center,
          child: isPastHalf
              ? _CardFace.back(
                  answer:  widget.answer,
                  context: context,
                )
              : _CardFace.front(
                  question: widget.question,
                  context:  context,
                ),
        );
      },
    );
  }
}

// ── Private helper widget for each card face ─────────────────────
class _CardFace extends StatelessWidget {
  final String text;
  final String badge;
  final bool   isBack;

  const _CardFace({
    required this.text,
    required this.badge,
    required this.isBack,
  });

  // Named constructors for clarity at call sites
  factory _CardFace.front({
    required String question,
    required BuildContext context,
  }) => _CardFace(text: question, badge: 'QUESTION', isBack: false);

  factory _CardFace.back({
    required String answer,
    required BuildContext context,
  }) => _CardFace(text: answer, badge: 'ANSWER', isBack: true);

  @override
  Widget build(BuildContext context) {
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    Widget face = Container(
      width:  double.infinity,
      height: 300,
      decoration: BoxDecoration(
        // Front: plain surface with subtle border
        // Back:  indigo/violet gradient — clearly different
        gradient: isBack
            ? LinearGradient(
                begin:  Alignment.topLeft,
                end:    Alignment.bottomRight,
                colors: isDark
                    ? [const Color(0xFF312E81), const Color(0xFF4C1D95)]
                    : [const Color(0xFF4F46E5), const Color(0xFF7C3AED)],
              )
            : null,
        color: isBack
            ? null
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: isBack
            ? null
            : Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 1.5,
              ),
        boxShadow: [
          BoxShadow(
            color: isBack
                ? primary.withOpacity(0.35)
                : Colors.black.withOpacity(isDark ? 0.4 : 0.08),
            blurRadius:   isBack ? 28 : 20,
            spreadRadius: isBack ? 2 : 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // ── Pill badge (QUESTION / ANSWER) ──────────────────
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 5,
            ),
            decoration: BoxDecoration(
              color: isBack
                  ? Colors.white.withOpacity(0.15)
                  : Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              badge,
              style: GoogleFonts.nunito(
                fontSize:      11,
                fontWeight:    FontWeight.w800,
                letterSpacing: 2,
                color: isBack
                    ? Colors.white.withOpacity(0.9)
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 28),

          // ── Main text ────────────────────────────────────────
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize:   isBack ? 19 : 21,
              fontWeight: FontWeight.w600,
              height:     1.55,
              color: isBack
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 24),

          // ── Tap hint at bottom ───────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isBack
                    ? Icons.touch_app_outlined
                    : Icons.flip_outlined,
                size:  14,
                color: isBack
                    ? Colors.white.withOpacity(0.5)
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 5),
              Text(
                isBack ? 'tap to see question' : 'tap to reveal answer',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: isBack
                      ? Colors.white.withOpacity(0.5)
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    // The back face needs a counter-rotation so text isn't mirrored
    if (isBack) {
      return Transform(
        transform: Matrix4.identity()..rotateY(math.pi),
        alignment: Alignment.center,
        child: face,
      );
    }
    return face;
  }
}