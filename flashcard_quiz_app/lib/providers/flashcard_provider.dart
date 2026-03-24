// ═══════════════════════════════════════════════════════════════════
// flashcard_provider.dart  —  Central state management (Provider)
// ═══════════════════════════════════════════════════════════════════
// All business logic lives here. Screens only read from / call into
// this class. They never modify data directly.
// ═══════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flashcard.dart';

class FlashcardProvider extends ChangeNotifier {

  // ── Private state ────────────────────────────────────────────────
  List<Flashcard> _cards       = [];
  int             _currentIndex = 0;
  bool            _showAnswer   = false;
  bool            _isLoading    = true;  // true while reading from storage

  // ── Public getters ───────────────────────────────────────────────
  List<Flashcard> get cards        => _cards;
  int             get currentIndex => _currentIndex;
  bool            get showAnswer   => _showAnswer;
  bool            get isLoading    => _isLoading;

  // Current card (null-safe — returns null when list is empty)
  Flashcard? get currentCard =>
      _cards.isEmpty ? null : _cards[_currentIndex];

  // ── Constructor ──────────────────────────────────────────────────
  FlashcardProvider() {
    _loadCards(); // load saved data immediately on first use
  }

  // ── Flip between question ↔ answer ───────────────────────────────
  void flipCard() {
    _showAnswer = !_showAnswer;
    notifyListeners();
  }

  // ── Navigate to next card (wraps around) ─────────────────────────
  void nextCard() {
    if (_cards.isEmpty) return;
    _currentIndex = (_currentIndex + 1) % _cards.length;
    _showAnswer   = false; // always start on question side
    notifyListeners();
  }

  // ── Navigate to previous card (wraps around) ─────────────────────
  void previousCard() {
    if (_cards.isEmpty) return;
    _currentIndex = (_currentIndex - 1 + _cards.length) % _cards.length;
    _showAnswer   = false;
    notifyListeners();
  }

  // ── Jump to a specific card index ────────────────────────────────
  void goToCard(int index) {
    if (index < 0 || index >= _cards.length) return;
    _currentIndex = index;
    _showAnswer   = false;
    notifyListeners();
  }

  // ── ADD a new flashcard ──────────────────────────────────────────
  void addCard(String question, String answer) {
    _cards.add(Flashcard(
      id:       DateTime.now().millisecondsSinceEpoch.toString(),
      question: question.trim(),
      answer:   answer.trim(),
    ));
    _saveCards();
    notifyListeners();
  }

  // ── EDIT an existing card ────────────────────────────────────────
  void editCard(String id, String newQuestion, String newAnswer) {
    final i = _cards.indexWhere((c) => c.id == id);
    if (i == -1) return;
    _cards[i].question = newQuestion.trim();
    _cards[i].answer   = newAnswer.trim();
    _saveCards();
    notifyListeners();
  }

  // ── DELETE a card ────────────────────────────────────────────────
  void deleteCard(String id) {
    _cards.removeWhere((c) => c.id == id);
    // Keep index in valid range after deletion
    if (_currentIndex >= _cards.length && _currentIndex > 0) {
      _currentIndex = _cards.length - 1;
    }
    _showAnswer = false;
    _saveCards();
    notifyListeners();
  }

  // ── SAVE all cards to SharedPreferences as JSON ──────────────────
  Future<void> _saveCards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'flashcards',
      jsonEncode(_cards.map((c) => c.toMap()).toList()),
    );
  }

  // ── LOAD cards from SharedPreferences ────────────────────────────
  Future<void> _loadCards() async {
    final prefs   = await SharedPreferences.getInstance();
    final encoded = prefs.getString('flashcards');

    if (encoded != null) {
      final List<dynamic> raw = jsonDecode(encoded);
      _cards = raw.map((m) => Flashcard.fromMap(m)).toList();
    } else {
      // Seed some demo cards on first launch
      _cards = [
        Flashcard(id: '1',
          question: 'What is Flutter?',
          answer:   'A Google UI toolkit for building natively compiled apps from a single codebase.'),
        Flashcard(id: '2',
          question: 'What is a Widget?',
          answer:   'The basic building block of Flutter UI — everything visible on screen is a widget.'),
        Flashcard(id: '3',
          question: 'What does setState() do?',
          answer:   'It marks the widget as dirty and schedules a rebuild on the next frame.'),
        Flashcard(id: '4',
          question: 'What is the Provider package?',
          answer:   'A state management solution that makes shared data accessible across the widget tree.'),
      ];
    }
    _isLoading = false;
    notifyListeners();
  }
}