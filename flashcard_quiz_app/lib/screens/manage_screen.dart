// ═══════════════════════════════════════════════════════════════════
// manage_screen.dart  —  Add / Edit / Delete cards
// ═══════════════════════════════════════════════════════════════════
// Design highlights:
//  • Card tiles with gradient accent left-border
//  • Swipe-to-delete support
//  • FAB with label
//  • Themed dialogs with proper input fields
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import '../models/flashcard.dart';

class ManageScreen extends StatelessWidget {
  const ManageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlashcardProvider>();
    final cs       = Theme.of(context).colorScheme;
    final isDark   = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // ── Gradient AppBar ───────────────────────────────────
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1E1B2E), const Color(0xFF252038)]
                  : [const Color(0xFF4F46E5), const Color(0xFF7C3AED)],
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    'Manage Cards',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20, fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Card count badge
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color:        Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${provider.cards.length}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13, fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ── FAB ─────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCardDialog(context),
        icon:      const Icon(Icons.add_rounded),
        label:     const Text('New Card'),
        elevation: 4,
      ),

      body: provider.cards.isEmpty
          ? _emptyState(context, cs)
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: provider.cards.length,
              itemBuilder: (ctx, i) {
                final card = provider.cards[i];
                return _CardTile(
                  card:     card,
                  index:    i,
                  provider: provider,
                  onEdit:   () => _showCardDialog(context, card: card),
                  onDelete: () => _confirmDelete(context, card, provider),
                );
              },
            ),
    );
  }

  // ── Empty state ──────────────────────────────────────────────
  Widget _emptyState(BuildContext context, ColorScheme cs) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.layers_outlined, size: 64, color: cs.outline),
          const SizedBox(height: 16),
          Text(
            'No cards yet',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18, fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap + New Card to get started.',
            style: GoogleFonts.nunito(fontSize: 14, color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  // ── Add / Edit dialog ────────────────────────────────────────
  void _showCardDialog(BuildContext context, {Flashcard? card}) {
    final provider = context.read<FlashcardProvider>();
    final qCtrl = TextEditingController(text: card?.question ?? '');
    final aCtrl = TextEditingController(text: card?.answer   ?? '');
    final cs    = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog title
              Text(
                card == null ? 'Add Flashcard' : 'Edit Flashcard',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18, fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 20),

              // Question field
              TextField(
                controller:            qCtrl,
                decoration:            const InputDecoration(
                  labelText: 'Question',
                  prefixIcon: Icon(Icons.help_outline_rounded),
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                minLines: 1,
              ),
              const SizedBox(height: 12),

              // Answer field
              TextField(
                controller:         aCtrl,
                decoration:         const InputDecoration(
                  labelText: 'Answer',
                  prefixIcon: Icon(Icons.lightbulb_outline_rounded),
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                minLines: 1,
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child:     const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        final q = qCtrl.text.trim();
                        final a = aCtrl.text.trim();
                        if (q.isEmpty || a.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Both fields are required.'),
                              backgroundColor: cs.error,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                          return;
                        }
                        card == null
                            ? provider.addCard(q, a)
                            : provider.editCard(card.id, q, a);
                        Navigator.pop(ctx);
                      },
                      child: Text(card == null ? 'Add' : 'Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Delete confirmation ───────────────────────────────────────
  void _confirmDelete(
      BuildContext context, Flashcard card, FlashcardProvider provider) {
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Delete Card?',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        content: Text(
          '"${card.question}"',
          style: GoogleFonts.nunito(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: cs.error),
            onPressed: () {
              provider.deleteCard(card.id);
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ── Individual card tile ─────────────────────────────────────────
class _CardTile extends StatelessWidget {
  final Flashcard         card;
  final int               index;
  final FlashcardProvider provider;
  final VoidCallback      onEdit;
  final VoidCallback      onDelete;

  const _CardTile({
    required this.card,
    required this.index,
    required this.provider,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color:        cs.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: cs.outline.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color:       Colors.black.withOpacity(isDark ? 0.3 : 0.04),
              blurRadius:  12,
              offset:      const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [

            // ── Coloured left accent bar ──────────────────────
            Container(
              width:  5,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin:  Alignment.topCenter,
                  end:    Alignment.bottomCenter,
                  colors: [cs.primary, cs.secondary],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft:    Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
            ),

            // ── Card number circle ────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                width:  32,
                height: 32,
                decoration: BoxDecoration(
                  color:  cs.primaryContainer,
                  shape:  BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize:   13,
                      fontWeight: FontWeight.w800,
                      color:      cs.primary,
                    ),
                  ),
                ),
              ),
            ),

            // ── Question & answer text ────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.question,
                      maxLines:  2,
                      overflow:  TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize:   14,
                        fontWeight: FontWeight.w700,
                        color:      cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      card.answer,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        fontSize: 12, color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Edit & Delete buttons ─────────────────────────
            IconButton(
              icon:     Icon(Icons.edit_rounded, size: 18, color: cs.primary),
              onPressed: onEdit,
              tooltip:  'Edit',
            ),
            IconButton(
              icon:     Icon(Icons.delete_rounded, size: 18, color: cs.error),
              onPressed: onDelete,
              tooltip:  'Delete',
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}