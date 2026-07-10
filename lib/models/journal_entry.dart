import 'package:flutter/material.dart';
//import '../config/emotional_dictionary.dart';

/// Modello per lo Stato Emotivo
class EmotionalState {
  final String name;
  final List<String> keywords;
  final List<Color> gradientColors;

  const EmotionalState({
    required this.name,
    required this.keywords,
    required this.gradientColors,
  });
}

/// Modello per una voce di Diario [cite: 2]
class JournalEntry {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final EmotionalState emotion;
  bool isBookmarked;
  bool isPrivate;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.emotion,
    this.isBookmarked = false,
    this.isPrivate = false,
  });
}
