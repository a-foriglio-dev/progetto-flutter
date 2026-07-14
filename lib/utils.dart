import 'package:flutter/material.dart';
//import 'models/journal_entry.dart';
import 'config/emotional_dictionary.dart';

/// Risultato completo dell'analisi emotiva da applicare alla UI
class EmotionalAnalysisResult {
  final EmotionalState dominantEmotion;
  final List<Color> mixedColors;

  EmotionalAnalysisResult({
    required this.dominantEmotion,
    required this.mixedColors,
  });
}

/// Analizza il testo per estrarre l'emozione prevalente e il mix cromatico di sfondo.
/// Gestisce internamente anche il caso di testo vuoto (ritornando lo stato neutro).
EmotionalAnalysisResult analyzeText(String text) {
  // Gestione del testo vuoto (Reset allo stato di Calma)
  if (text.trim().isEmpty) {
    return EmotionalAnalysisResult(
      dominantEmotion: emotionalDictionary[0],
      mixedColors: List.from(emotionalDictionary[0].gradientColors),
    );
  }

  final lowerText = text.toLowerCase();

  // Rimuove la punteggiatura per evitare che parole con virgole/punti non vengano riconosciute
  final words = lowerText
      .replaceAll(RegExp(r'[.,\/#!$%\^&\*;:{}=\-_`~()?«»“”"’]'), ' ')
      .split(RegExp(r'\s+'));

  Map<String, int> emotionCounts = {
    for (var e in emotionalDictionary) e.name: 0
  };

  int totalEmotionalWords = 0;
  String dominantEmotionName = emotionalDictionary[0].name;
  int maxCount = 0;

  
  for (final word in words) {
    if (word.isEmpty) continue;

    for (final emotion in emotionalDictionary) {
      if (emotion.keywords.contains(word)) {
        emotionCounts[emotion.name] = (emotionCounts[emotion.name] ?? 0) + 1;
        totalEmotionalWords++;

        // Determina qual è l'emozione quantitativamente dominante
        if (emotionCounts[emotion.name]! > maxCount) {
          maxCount = emotionCounts[emotion.name]!;
          dominantEmotionName = emotion.name;
        }
      }
    }
  }

  // Se sono state digitate parole emotive, viene creato il mix di colori
  if (totalEmotionalWords > 0) {
    List<Color> newMix = [];

    // Estraiamo il primo colore della palette di ogni emozione che compare ALMENO una volta
    for (final emotion in emotionalDictionary) {
      if ((emotionCounts[emotion.name] ?? 0) > 0) {
        newMix.add(emotion.gradientColors[0]);
      }
    }

    // Un LinearGradient ha bisogno di almeno 2 colori per non crashare.
    // Se c'è una sola emozione attiva, riprendiamo la sua palette nativa originale.
    if (newMix.length == 1) {
      final activeEmotion = emotionalDictionary.firstWhere((e) => e.name == dominantEmotionName);
      newMix = List.from(activeEmotion.gradientColors);
    }

    return EmotionalAnalysisResult(
      dominantEmotion: emotionalDictionary.firstWhere((e) => e.name == dominantEmotionName),
      mixedColors: newMix,
    );
  }

  // Se l'utente scrive parole neutre (non presenti nel dizionario), 
  // ritorna comunque la calma come base (o lo stato di default)
  return EmotionalAnalysisResult(
    dominantEmotion: emotionalDictionary[0],
    mixedColors: List.from(emotionalDictionary[0].gradientColors),
  );
}
