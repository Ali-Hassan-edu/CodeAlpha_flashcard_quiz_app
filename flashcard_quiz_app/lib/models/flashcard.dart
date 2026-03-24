// ═══════════════════════════════════════════════════════════════════
// flashcard.dart  —  Plain data model for one flashcard
// ═══════════════════════════════════════════════════════════════════

class Flashcard {
  String id;        // unique identifier (timestamp string)
  String question;  // front of the card
  String answer;    // back of the card

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
  });

  // Convert object → Map  (for JSON encoding before saving)
  Map<String, dynamic> toMap() => {
        'id': id,
        'question': question,
        'answer': answer,
      };

  // Convert Map → object  (when loading from storage)
  factory Flashcard.fromMap(Map<String, dynamic> map) => Flashcard(
        id: map['id'],
        question: map['question'],
        answer: map['answer'],
      );
}