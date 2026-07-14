import '../config/emotional_dictionary.dart';


class JournalEntry {
  String id;
  String title;
  String content;
  DateTime date;
  EmotionalState emotion;
  bool isBookmarked;
  bool isPrivate;
  String? pin;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.emotion,
    this.isBookmarked = false,
    this.isPrivate = false,
    this.pin,
  });

  ///  Crea una copia del diario modificando solo i campi passati come argomento.
  /// Fondamentale per aggiornare lo stato con SQLite senza perdere i dati esistenti.
  JournalEntry copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? date,
    EmotionalState? emotion,
    bool? isBookmarked,
    bool? isPrivate,
    String? pin,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      emotion: emotion ?? this.emotion,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isPrivate: isPrivate ?? this.isPrivate,
      pin: pin ?? this.pin,
    );
  }

  // Converte l'oggetto in una mappa compatibile con SQLite
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'content': content,
    'date': date.toIso8601String(),
    'emotion_name': emotion.name,
    'is_bookmarked': isBookmarked ? 1 : 0,
    'is_private': isPrivate ? 1 : 0,
    'pin': pin,
  };

  // Rigenera l'oggetto partendo dai dati salvati in SQLite
  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      emotion: emotionalDictionary.firstWhere(
        (e) => e.name == map['emotion_name'], 
        orElse: () => emotionalDictionary[0],
      ),
      isBookmarked: map['is_bookmarked'] == 1,
      isPrivate: map['is_private'] == 1,
      pin: map['pin'],
    );
  }
}