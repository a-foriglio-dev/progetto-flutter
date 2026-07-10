import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../config/emotional_dictionary.dart';
import 'app_bar_screen.dart';
import 'body_screen.dart';
import 'bottom_layout.dart';
import 'editor_screen.dart';

/// Schermata Principale: Lista dei Diari con Filtri Avanzati.
///
/// Questa classe fa da "coordinatore": gestisce lo stato (diari, filtro
/// attivo) e la navigazione, ma delega la costruzione visiva delle sue
/// tre parti a widget separati: EchoAppBar, EchoBody, EchoBottomActions.
class EchoJournalScreen extends StatefulWidget {
  const EchoJournalScreen({super.key});

  @override
  State<EchoJournalScreen> createState() => _JournalState();
}

class _JournalState extends State<EchoJournalScreen> {
  // Lista simulata dei diari salvati
  final List<JournalEntry> _entries = [
    JournalEntry(
      id: "1",
      title: "Un pomeriggio sereno",
      content: "Oggi mi sento in pace con il mondo, ciao diario.",
      date: DateTime.now().subtract(const Duration(days: 1)),
      emotion: emotionalDictionary[0],
      isBookmarked: true,
    ),
    JournalEntry(
      id: "2",
      title: "Momento difficile",
      content: "Fuori c'è pioggia e mi sento molto triste e stanco.",
      date: DateTime.now(),
      emotion: emotionalDictionary[2],
    ),
  ];

  // Stato del filtro attuale: 'all' (Tutti i diari) o 'bookmarked' (Solo segnalibri)
  String _activeFilter = 'all';

  @override
  Widget build(BuildContext context) {
    // Verifica se esiste almeno un diario tra i segnalibri
    bool hasBookmarkedEntries = _entries.any((entry) => entry.isBookmarked);

    // Se il filtro attuale è impostato su segnalibri ma non ce ne sono più, resetta a 'all'
    if (_activeFilter == 'bookmarked' && !hasBookmarkedEntries) {
      _activeFilter = 'all';
    }

    // Filtra la lista da mostrare in base alla scelta dell'utente
    List<JournalEntry> displayedEntries = _entries.where((entry) {
      if (_activeFilter == 'bookmarked') return entry.isBookmarked;
      return true;
    }).toList();

    return Scaffold(
      appBar: EchoAppBar(
        hasBookmarkedEntries: hasBookmarkedEntries,
        onFilterSelected: (value) {
          setState(() {
            _activeFilter = value;
          });
        },
      ),
      
      
      body: EchoBody(
        displayedEntries: displayedEntries,
        activeFilter: _activeFilter,
        onToggleBookmark: (entry) {
          setState(() {
            entry.isBookmarked = !entry.isBookmarked;
          });
        },
        onDelete: (entry) {
          setState(() {
            _entries.removeWhere((e) => e.id == entry.id);
          });
        },
        onTapEntry: (entry) => _navigateToEditor(context, entry),
      ),
      
      
      // Layout dei pulsanti d'azione posizionati in basso
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: EchoBottomActions(
        onInfoPressed: () => _showInfoDialog(context),
        onAddPressed: () => _navigateToEditor(context, null),
      ),
    );
  }

  void _navigateToEditor(BuildContext context, JournalEntry? entry) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EchoEditorScreen(entry: entry)),
    );

    if (result != null && result is JournalEntry) {
      setState(() {
        if (entry != null) {
          final idx = _entries.indexWhere((e) => e.id == entry.id);
          if (idx != -1) _entries[idx] = result;
        } else {
          _entries.add(result);
        }
      });
    }
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Funzionamento App (Echo)'),
        content: const Text(
          'Echo analizza empaticamente il testo digitato in tempo reale. '
          'A seconda delle parole inserite, lo sfondo cambierà gradualmente colore '
          'per rispecchiare lo stato d\'animo attuale del diario.\n\n'
          'Usa il tasto + per creare un diario.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
