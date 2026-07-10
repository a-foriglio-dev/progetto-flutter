import 'models/journal_entry.dart';
import 'config/emotional_dictionary.dart';

/// Analizza il [text] cercando l'ultima parola chiave riconosciuta
/// partendo dalla fine, e restituisce lo stato emotivo corrispondente.
///
/// Restituisce `null` se non viene trovata nessuna parola chiave
/// (in tal caso il chiamante dovrebbe mantenere lo stato emotivo attuale).
///
/// Nota: la gestione del testo vuoto (reset allo stato neutro) resta
/// a carico del chiamante, perché è una scelta di UI e non di analisi.

EmotionalState? analyzeText(String text) {
  final lowerText = text.toLowerCase();

  // replaceAll: rimuovere i caratteri di punteggiatura per evitare che una parola come triste, non venga riconosciuta per via della virgola
  final words = lowerText
      .replaceAll(RegExp(r'[.,\/#!$%\^&\*;:{}=\-_`~()?]/'), '')
      .split(RegExp(r'\s+'));

  // Priorità alle ultime parole scritte  
  for (int i = words.length - 1; i >= 0; i--) {
    final currentWord = words[i];
    if (currentWord.isEmpty) continue;

    for (final emotion in emotionalDictionary) {
      if (emotion.keywords.contains(currentWord)) {
        return emotion;
      }
    }
  }

  return null;
}



