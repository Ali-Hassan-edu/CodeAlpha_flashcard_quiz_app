// ═══════════════════════════════════════════════════════════════════
// quiz_screen.dart  —  Main study screen
// ═══════════════════════════════════════════════════════════════════
// Layout (top → bottom):
//   1. Gradient header with title + custom menu icon
//   2. Dot-based progress indicator
//   3. Animated flip card (3D)
//   4. "Flip Card" primary button
//   5. Previous / Next navigation row
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import '../widgets/flashcard_widget.dart';
import '../widgets/app_drawer.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlashcardProvider>();
    final isDark   = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // ── Custom side drawer ──────────────────────────────────
      drawer: const AppDrawer(),

      body: Column(
        children: [

          // ══════════════════════════════════════════════════
          // GRADIENT HEADER — replaces the ugly default AppBar
          // ══════════════════════════════════════════════════
          _GradientHeader(isDark: isDark),

          // ══════════════════════════════════════════════════
          // BODY CONTENT
          // ══════════════════════════════════════════════════
          Expanded(
            child: provider.isLoading
                // Loading state while reading from storage
                ? const Center(child: CircularProgressIndicator())
                : provider.cards.isEmpty
                    // Empty state
                    ? _EmptyState(isDark: isDark)
                    // Normal quiz state
                    : _QuizBody(provider: provider, isDark: isDark),
          ),
        ],
      ),
    );
  }
}

// ── Gradient header widget ───────────────────────────────────────
class _GradientHeader extends StatelessWidget {
  final bool isDark;
  const _GradientHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin:  Alignment.topLeft,
          end:    Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1E1B2E), const Color(0xFF252038)]
              : [const Color(0xFF4F46E5), const Color(0xFF7C3AED)],
        ),
        // Rounded bottom corners for a "card" effect
        borderRadius: const BorderRadius.only(
          bottomLeft:  Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 24),
          child: Row(
            children: [
              // ── Custom drawer button (NOT a hamburger ≡) ───
              Builder(builder: (ctx) => _DrawerButton(onTap: () {
                Scaffold.of(ctx).openDrawer();
              })),

              const SizedBox(width: 4),

              // ── App title + subtitle ─────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FlashMind',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize:   22,
                        fontWeight: FontWeight.w800,
                        color:      Colors.white,
                      ),
                    ),
                    Text(
                      'Study smarter, not harder',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color:    Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Add card quick-action ────────────────────
              _HeaderAction(
                icon:    Icons.add_rounded,
                tooltip: 'Quick add',
                onTap:   () => _showQuickAdd(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Quick-add card bottom sheet
  void _showQuickAdd(BuildContext context) {
    final provider = context.read<FlashcardProvider>();
    final qCtrl    = TextEditingController();
    final aCtrl    = TextEditingController();

    showModalBottomSheet(
      context:      context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _QuickAddSheet(
        qCtrl:    qCtrl,
        aCtrl:    aCtrl,
        provider: provider,
      ),
    );
  }
}

// ── Custom drawer open button (replaces ≡) ──────────────────────
// Uses a "grid" style icon with rounded dots for a modern look
class _DrawerButton extends StatelessWidget {
  final VoidCallback onTap;
  const _DrawerButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      tooltip:   'Menu',
      icon: Container(
        width:  38,
        height: 38,
        decoration: BoxDecoration(
          color:        Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        // Custom icon: two short rounded lines + a dot = modern menu
        child: const Icon(
          Icons.dashboard_rounded,  // grid icon — far more attractive
          color: Colors.white,
          size:  20,
        ),
      ),
    );
  }
}

// ── Header action button ─────────────────────────────────────────
class _HeaderAction extends StatelessWidget {
  final IconData     icon;
  final String       tooltip;
  final VoidCallback onTap;
  const _HeaderAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width:  40,
          height: 40,
          decoration: BoxDecoration(
            color:        Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

// ── Main quiz body ───────────────────────────────────────────────
class _QuizBody extends StatelessWidget {
  final FlashcardProvider provider;
  final bool isDark;
  const _QuizBody({required this.provider, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
      child: Column(
        children: [

          // ── Dot progress indicator ──────────────────────────
          _DotProgress(
            total:   provider.cards.length,
            current: provider.currentIndex,
          ),

          const SizedBox(height: 28),

          // ── Flip card (swipeable) ────────────────────────────
          GestureDetector(
            onTap: provider.flipCard,  // tapping card also flips it
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim, child: child,
              ),
              child: FlashcardWidget(
                key:        ValueKey(provider.currentIndex),
                question:   provider.currentCard!.question,
                answer:     provider.currentCard!.answer,
                showAnswer: provider.showAnswer,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ── Swipe hint ───────────────────────────────────────
          Text(
            'Tap card to flip  •  Use buttons to navigate',
            style: GoogleFonts.nunito(
              fontSize: 12,
              color:    cs.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 28),

          // ── Flip button ──────────────────────────────────────
          SizedBox(
            width:  double.infinity,
            height: 54,
            child: FilledButton.icon(
              onPressed: provider.flipCard,
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  provider.showAnswer
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  key: ValueKey(provider.showAnswer),
                ),
              ),
              label: Text(
                provider.showAnswer ? 'Hide Answer' : 'Reveal Answer',
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ── Prev / Next row ──────────────────────────────────
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: provider.previousCard,
                    icon:      const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                    label:     const Text('Previous'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed:     provider.nextCard,
                    icon:          const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    label:         const Text('Next'),
                    iconAlignment: IconAlignment.end,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Card number chip ─────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color:        cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Card ${provider.currentIndex + 1} of ${provider.cards.length}',
              style: GoogleFonts.nunito(
                fontSize:   13,
                fontWeight: FontWeight.w600,
                color:      cs.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Dot-based progress indicator ────────────────────────────────
class _DotProgress extends StatelessWidget {
  final int total;
  final int current;
  const _DotProgress({required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Show max 10 dots to avoid overflow; still functional for more cards
    const maxDots  = 10;
    final showDots = total <= maxDots;

    if (!showDots) {
      // Fallback: linear progress bar for large decks
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value:   (current + 1) / total,
              minHeight: 6,
              backgroundColor:  cs.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${current + 1} / $total',
            style: GoogleFonts.nunito(
              fontSize: 12, color: cs.onSurfaceVariant,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration:     const Duration(milliseconds: 300),
          curve:        Curves.easeInOut,
          margin:       const EdgeInsets.symmetric(horizontal: 4),
          width:  isActive ? 24 : 8,   // active dot stretches into a pill
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? cs.primary
                : cs.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }
}

// ── Empty state ──────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width:  90,
              height: 90,
              decoration: BoxDecoration(
                color:        cs.primaryContainer,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(
                Icons.style_rounded,
                size:  44,
                color: cs.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No cards yet',
              style: GoogleFonts.plusJakartaSans(
                fontSize:   22,
                fontWeight: FontWeight.w800,
                color:      cs.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Open the menu and tap\n"Manage Cards" to add your first flashcard.',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 14,
                height:   1.6,
                color:    cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Quick-add bottom sheet ───────────────────────────────────────
class _QuickAddSheet extends StatelessWidget {
  final TextEditingController qCtrl;
  final TextEditingController aCtrl;
  final FlashcardProvider     provider;

  const _QuickAddSheet({
    required this.qCtrl,
    required this.aCtrl,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color:        cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: cs.outline,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Add New Card',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18, fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: qCtrl,
            decoration: const InputDecoration(labelText: 'Question'),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: aCtrl,
            decoration: const InputDecoration(labelText: 'Answer'),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 20),

          SizedBox(
            width:  double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: () {
                final q = qCtrl.text.trim();
                final a = aCtrl.text.trim();
                if (q.isEmpty || a.isEmpty) return;
                provider.addCard(q, a);
                Navigator.pop(context);
              },
              child: const Text('Add Card'),
            ),
          ),
        ],
      ),
    );
  }
}