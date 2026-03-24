// ═══════════════════════════════════════════════════════════════════
// main.dart  —  App entry point + full Light & Dark theme system
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/flashcard_provider.dart';
import 'screens/quiz_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Transparent status bar so our gradient background bleeds through
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => FlashcardProvider(),
      child: const FlashcardApp(),
    ),
  );
}

// ── Brand colour tokens ──────────────────────────────────────────
// Keep ALL colours in one place so changing the palette is easy.
class AppColors {
  // Light mode
  static const lBg       = Color(0xFFF6F4F0);  // warm off-white
  static const lSurface  = Color(0xFFFFFFFF);
  static const lCard     = Color(0xFFFFFFFF);
  static const lAccent   = Color(0xFF4F46E5);  // indigo-600
  static const lAccent2  = Color(0xFF7C3AED);  // violet-600
  static const lText     = Color(0xFF1C1917);
  static const lSub      = Color(0xFF78716C);
  static const lBorder   = Color(0xFFE7E5E4);
  static const lChip     = Color(0xFFEEF2FF);  // indigo tint

  // Dark mode
  static const dBg       = Color(0xFF0D0C14);  // near-black navy
  static const dSurface  = Color(0xFF17161F);
  static const dCard     = Color(0xFF1F1E2A);
  static const dAccent   = Color(0xFF818CF8);  // soft indigo
  static const dAccent2  = Color(0xFFA78BFA);  // soft violet
  static const dText     = Color(0xFFF0EEFF);
  static const dSub      = Color(0xFF9CA3AF);
  static const dBorder   = Color(0xFF2A2837);
  static const dChip     = Color(0xFF1E1D2E);
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlashMind',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, // follows phone setting automatically

      // ────────────────────────────────────────────────────────
      // LIGHT THEME
      // ────────────────────────────────────────────────────────
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lBg,
        colorScheme: const ColorScheme.light(
          primary:          AppColors.lAccent,
          secondary:        AppColors.lAccent2,
          surface:          AppColors.lSurface,
          onPrimary:        Colors.white,
          onSurface:        AppColors.lText,
          outline:          AppColors.lBorder,
          surfaceContainerHighest:   AppColors.lChip,
          onSurfaceVariant: AppColors.lSub,
          primaryContainer: Color(0xFFEEF2FF),
          onPrimaryContainer: AppColors.lAccent,
        ),
        // Plus Jakarta Sans for headings, Nunito for body
        textTheme: GoogleFonts.nunitoTextTheme().apply(
          bodyColor: AppColors.lText,
          displayColor: AppColors.lText,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: GoogleFonts.plusJakartaSans(
            fontSize: 22, fontWeight: FontWeight.w800,
            color: AppColors.lText,
          ),
          iconTheme: const IconThemeData(color: AppColors.lText),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: AppColors.lSurface,
          elevation: 0,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.lAccent,
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.nunito(
              fontSize: 15, fontWeight: FontWeight.w700,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.lAccent,
            side: const BorderSide(color: AppColors.lBorder, width: 1.5),
            textStyle: GoogleFonts.nunito(
              fontSize: 15, fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lChip,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.lAccent, width: 2),
          ),
          labelStyle: GoogleFonts.nunito(color: AppColors.lSub),
          hintStyle: GoogleFonts.nunito(color: AppColors.lSub),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),

      // ────────────────────────────────────────────────────────
      // DARK THEME
      // ────────────────────────────────────────────────────────
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.dBg,
        colorScheme: const ColorScheme.dark(
          primary:          AppColors.dAccent,
          secondary:        AppColors.dAccent2,
          surface:          AppColors.dSurface,
          onPrimary:        AppColors.dBg,
          onSurface:        AppColors.dText,
          outline:          AppColors.dBorder,
          surfaceContainerHighest:   AppColors.dChip,
          onSurfaceVariant: AppColors.dSub,
          primaryContainer: AppColors.dChip,
          onPrimaryContainer: AppColors.dAccent,
        ),
        textTheme: GoogleFonts.nunitoTextTheme(
          ThemeData.dark().textTheme,
        ).apply(
          bodyColor: AppColors.dText,
          displayColor: AppColors.dText,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: GoogleFonts.plusJakartaSans(
            fontSize: 22, fontWeight: FontWeight.w800,
            color: AppColors.dText,
          ),
          iconTheme: const IconThemeData(color: AppColors.dText),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: AppColors.dSurface,
          elevation: 0,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.dAccent,
            foregroundColor: AppColors.dBg,
            textStyle: GoogleFonts.nunito(
              fontSize: 15, fontWeight: FontWeight.w700,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.dAccent,
            side: const BorderSide(color: AppColors.dBorder, width: 1.5),
            textStyle: GoogleFonts.nunito(
              fontSize: 15, fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.dChip,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.dAccent, width: 2),
          ),
          labelStyle: GoogleFonts.nunito(color: AppColors.dSub),
          hintStyle: GoogleFonts.nunito(color: AppColors.dSub),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),

      home: const QuizScreen(),
    );
  }
}