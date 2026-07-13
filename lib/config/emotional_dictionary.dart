import 'package:flutter/material.dart';

/// 🆕 La classe che mancava! Definisce la struttura di un'emozione.
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

/// Configurazioni globali delle Emozioni (Dizionario delle 5 Emozioni)
const List<EmotionalState> emotionalDictionary = [
  EmotionalState(
    name: "CALMA / RELAX",
    keywords: [
      'pace',
      'relax',
      'calma',
      'equilibrio',
      'silenzio',
      'ascolto',
      'diario',
      'ciao',
    ],
    gradientColors: [Color(0xff134e5e), Color(0xff71b280)],
  ),
  EmotionalState(
    name: "ENERGIA / FELICITÀ",
    keywords: [
      'felice',
      'super',
      'bene',
      'sole',
      'bello',
      'vittoria',
      'top',
      'contento',
      'amore',
    ],
    gradientColors: [Color(0xfff2994a), Color(0xfff2c94c)],
  ),
  EmotionalState(
    name: "MALINCONIA / RIFLESSIONE",
    keywords: [
      'triste',
      'pioggia',
      'stanco',
      'vuoto',
      'male',
      'piangere',
      'buio',
      'solitudine',
      'ansia',
    ],
    gradientColors: [Color(0xff1f1a3a), Color(0xff0b0c10)],
  ),
  EmotionalState(
    name: "RABBIA / FRUSTRAZIONE",
    keywords: [
      'rabbia',
      'arrabbiato',
      'odio',
      'nervoso',
      'furioso',
      'basta',
      'urlo',
      'fastidio',
      'furente',
    ],
    gradientColors: [Color(0xffe52d27), Color(0xffb31010)],
  ),
  EmotionalState(
    name: "PAURA / INCERTEZZA",
    keywords: [
      'paura',
      'spaventato',
      'terrore',
      'incubo',
      'tremo',
      'panico',
      'minaccia',
      'orrore',
      'dubbi',
    ],
    gradientColors: [Color(0xff3a3d40), Color(0xff182226)],
  ),
];