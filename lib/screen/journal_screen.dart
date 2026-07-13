import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
//import '../config/emotional_dictionary.dart';
import '../services/db.dart' as db_service; // Importiamo il servizio DB
import 'app_bar_screen.dart';
import 'body_screen.dart';
import 'bottom_layout.dart';
import 'editor_screen.dart';
import '../manager/pin_manager.dart';

/// Schermata Principale: Lista dei Diari caricati da SQLite con Filtri Avanzati.
class EchoJournalScreen extends StatefulWidget {
  const EchoJournalScreen({super.key});

  @override
  State<EchoJournalScreen> createState() => _JournalState();
}

class _JournalState extends State<EchoJournalScreen> {
  List<JournalEntry> _entries = [];
  bool _isLoading = true;

  // Stato del filtro attuale: 'all', 'bookmarked' o 'private'
  String _activeFilter = 'all';

  @override
  void initState() {
    super.initState();
    _initAppData();
  }

  /// Carica i diari direttamente dal Database SQLite all'avvio
  Future<void> _initAppData() async {
    setState(() => _isLoading = true);
    try {
      final entries = await db_service.loadEntries();
      setState(() {
        _entries = entries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore nel caricamento dei dati: \$e')),
      );
    }
  }

  /// Ricarica la lista dei diari aggiornata dal database
  Future<void> _refreshEntries() async {
    final entries = await db_service.loadEntries();
    setState(() {
      _entries = entries;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Verifiche di coerenza per i filtri attivi basate sui dati del DB
    bool hasBookmarkedEntries = _entries.any((entry) => entry.isBookmarked);
    bool hasPrivateEntries = _entries.any((entry) => entry.isPrivate);

    // Se il filtro attuale non ha più elementi corrispondenti, resetta a 'all'
    if (_activeFilter == 'bookmarked' && !hasBookmarkedEntries) {
      _activeFilter = 'all';
    } else if (_activeFilter == 'private' && !hasPrivateEntries) {
      _activeFilter = 'all';
    }

    // Filtra la lista da mostrare in base alla scelta dell'utente
    List<JournalEntry> displayedEntries = _entries.where((entry) {
      if (_activeFilter == 'bookmarked') return entry.isBookmarked;
      if (_activeFilter == 'private') return entry.isPrivate; // Filtro per la privacy
      return true;
    }).toList();

    return Scaffold(
      appBar: EchoAppBar(
        hasBookmarkedEntries: hasBookmarkedEntries,
        hasPrivateEntries: hasPrivateEntries, 
        onFilterSelected: (filter) {
          setState(() {
            _activeFilter = filter;
          });
        },
      ),
      
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) 
          : EchoBody(
              displayedEntries: displayedEntries,
              activeFilter: _activeFilter,
              onToggleBookmark: (entry) async {
                final updatedEntry = entry.copyWith(isBookmarked: !entry.isBookmarked);
                await db_service.saveEntry(updatedEntry);
                _refreshEntries();
              },
              onDelete: (entry) async {
                await db_service.deleteEntry(entry.id);
                _refreshEntries();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Diario eliminato con successo.')),
                );
              },
              onTapEntry: (entry) {
                _handleEntryTap(context, entry);
              },
              onTogglePrivacy: (entry) {
                _handleTogglePrivacy(context, entry);
              },
            ),
      
      // Layout dei pulsanti d'azione posizionati in basso
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: EchoBottomActions(
        isFilteringPrivate: _activeFilter == 'private', // Sincronizza lo stato del pulsante "+"
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
      JournalEntry entryToSave = result;
      
      // Se creiamo un diario dalla sezione "Privati", per evitare conflitti o PIN vuoti,
      // la cosa migliore è salvarlo e poi richiedere subito la configurazione del PIN.
      if (entry == null && _activeFilter == 'private') {
        await db_service.saveEntry(entryToSave);
        await _refreshEntries();
        // Cerchiamo il diario appena inserito per passarlo alla funzione del PIN
        final newEntry = _entries.firstWhere((e) => e.id == entryToSave.id, orElse: () => entryToSave);
        if (mounted) _forzaCreazionePinEProteggi(context, newEntry);
        return;
      }

      await db_service.saveEntry(entryToSave);
      _refreshEntries();
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

  /// Gestisce l'apertura del diario: chiede il PIN specifico memorizzato nel diario
  void _handleEntryTap(BuildContext context, JournalEntry entry) {
    if (entry.isPrivate) {
      // Se il diario è segnato privato ma non ha un PIN valido, forziamo la creazione
      if (entry.pin == null || entry.pin!.trim().isEmpty) {
        _forzaCreazionePinEProteggi(context, entry);
        return;
      }

      PinManager.showVerificationDialog(
        context: context,
        title: 'Inserisci il PIN per sbloccare questo diario',
        currentPin: entry.pin!, // Richiede il PIN unico di questa pagina di diario
        onResult: (isCorrect) {
          if (isCorrect) {
            _navigateToEditor(context, entry);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('PIN Errato! Accesso negato.'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
      );
    } else {
      _navigateToEditor(context, entry);
    }
  }

  /// Gestisce l'attivazione/disattivazione dello stato "Privato" usando il PIN del diario
  void _handleTogglePrivacy(BuildContext context, JournalEntry entry) {
    if (entry.isPrivate) {
      // Se è già privato ma non ha un PIN associato per errore, lo sblocchiamo
      if (entry.pin == null || entry.pin!.trim().isEmpty) {
        _rimuoviPrivacy(entry);
        return;
      }

      // Se è già privato, chiede la verifica del suo PIN specifico prima di renderlo pubblico
      PinManager.showVerificationDialog(
        context: context,
        title: 'Inserisci il PIN per rendere pubblico il diario',
        currentPin: entry.pin!,
        onResult: (isCorrect) async {
          if (isCorrect) {
            _rimuoviPrivacy(entry);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('PIN Errato! Cambiamento annullato.'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
      );
    } else {
      // Se il diario era pubblico, avvia la creazione del PIN dedicato per bloccarlo
      _forzaCreazionePinEProteggi(context, entry);
    }
  }

  // --- Funzioni Helper Gestione Privacy Individuale ---

  void _forzaCreazionePinEProteggi(BuildContext context, JournalEntry entry) {
    PinManager.showCreationDialog(context, (nuovoPin) async {
      // Crea la copia inserendo il PIN appena digitato specificatamente per questo diario
      final updatedEntry = entry.copyWith(
        isPrivate: true,
        pin: nuovoPin, 
      );
      await db_service.saveEntry(updatedEntry);
      _refreshEntries();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Diario protetto con il tuo PIN personalizzato! 🔒')),
        );
      }
    });
  }

  void _rimuoviPrivacy(JournalEntry entry) async {
    // Quando torna pubblico, azzera anche la proprietà del PIN impostandola a null
    final updatedEntry = entry.copyWith(
      isPrivate: false,
      pin: null, 
    );
    await db_service.saveEntry(updatedEntry);
    _refreshEntries();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Diario impostato come pubblico. 🔓')),
      );
    }
  }
}