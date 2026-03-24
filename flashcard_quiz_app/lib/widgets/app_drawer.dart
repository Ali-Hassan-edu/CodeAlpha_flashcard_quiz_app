// ═══════════════════════════════════════════════════════════════════
// app_drawer.dart  —  Polished side drawer replacing the ugly ≡ icon
// ═══════════════════════════════════════════════════════════════════
// Features:
//  • Gradient header with app logo + card count
//  • Navigation tiles with icons and subtle active highlight
//  • Theme-aware (auto light/dark)
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import '../screens/manage_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlashcardProvider>();
    final cs       = Theme.of(context).colorScheme;
    final isDark   = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      width: 290,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Gradient header ───────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin:  Alignment.topLeft,
                  end:    Alignment.bottomRight,
                  colors: isDark
                      ? [const Color(0xFF312E81), const Color(0xFF4C1D95)]
                      : [const Color(0xFF4F46E5), const Color(0xFF7C3AED)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App icon
                  Container(
                    width:  52,
                    height: 52,
                    decoration: BoxDecoration(
                      color:        Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.bolt_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // App name
                  Text(
                    'FlashMind',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize:   24,
                      fontWeight: FontWeight.w800,
                      color:      Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Card count badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color:        Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${provider.cards.length} cards',
                          style: GoogleFonts.nunito(
                            fontSize:   13,
                            fontWeight: FontWeight.w700,
                            color:      Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Navigation section label ──────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 0, 6),
              child: Text(
                'NAVIGATION',
                style: GoogleFonts.nunito(
                  fontSize:      10,
                  fontWeight:    FontWeight.w800,
                  letterSpacing: 1.8,
                  color:         cs.onSurfaceVariant,
                ),
              ),
            ),

            // ── Study (current screen) ────────────────────────
            _DrawerTile(
              icon:     Icons.school_rounded,
              label:    'Study',
              sublabel: 'Quiz yourself',
              isActive: true,
              onTap: () => Navigator.pop(context), // already here
            ),

            // ── Manage Cards ──────────────────────────────────
            _DrawerTile(
              icon:     Icons.layers_rounded,
              label:    'Manage Cards',
              sublabel: 'Add, edit, delete',
              isActive: false,
              onTap: () {
                Navigator.pop(context); // close drawer first
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManageScreen()),
                );
              },
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Divider(height: 1),
            ),

            // ── Stats summary ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
              child: Text(
                'STATS',
                style: GoogleFonts.nunito(
                  fontSize:      10,
                  fontWeight:    FontWeight.w800,
                  letterSpacing: 1.8,
                  color:         cs.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Card count stat tile
            _StatRow(
              icon:  Icons.style_rounded,
              label: 'Total Cards',
              value: '${provider.cards.length}',
            ),

            // Current position stat tile
            _StatRow(
              icon:  Icons.my_location_rounded,
              label: 'Current Card',
              value: provider.cards.isEmpty
                  ? '—'
                  : '${provider.currentIndex + 1} / ${provider.cards.length}',
            ),

            const Spacer(),

            // ── Version footer ────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'FlashMind v1.0  •  CodeAlpha',
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  color:    cs.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable drawer navigation tile ─────────────────────────────
class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   sublabel;
  final bool     isActive;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? cs.primary.withOpacity(isDark ? 0.18 : 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              // Icon box
              Container(
                width:  38,
                height: 38,
                decoration: BoxDecoration(
                  color: isActive
                      ? cs.primary.withOpacity(0.15)
                      : cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size:  19,
                  color: isActive ? cs.primary : cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 14),

              // Label + sublabel
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize:   14,
                        fontWeight: FontWeight.w700,
                        color:      isActive ? cs.primary : cs.onSurface,
                      ),
                    ),
                    Text(
                      sublabel,
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        color:    cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Active dot indicator
              if (isActive)
                Container(
                  width:  6,
                  height: 6,
                  decoration: BoxDecoration(
                    color:  cs.primary,
                    shape:  BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Small stat row ───────────────────────────────────────────────
class _StatRow extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   value;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: cs.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 13, color: cs.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize:   13,
              fontWeight: FontWeight.w700,
              color:      cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}