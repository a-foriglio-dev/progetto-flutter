import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
//import '../config/emotional_dictionary.dart';
import '../services/db.dart' as db_service; 
import 'app_bar_screen.dart';
import 'body_screen.dart';
import 'bottom_layout.dart';
import 'editor_screen.dart';
import '../manager/pin_manager.dart';

/// Schermata Principale: Lista dei Diari caricati da SQLite con Filtri Avanzati.
/// StatefulWidget: mantiene uno stato che cambia nel tempo
class EchoJournalScreen extends StatefulWidget {
  const EchoJournalScreen({super.key});

  // Collegamento della schermata al suo stato
  @override
  State<EchoJournalScreen> createState() => _JournalState();
}

class _JournalState extends State<EchoJournalScreen> {
  List<JournalEntry> _entries = [];
  bool _isLoading = true;

  // Stato del filtro attuale: 'all', 'bookmarked' o 'private'
  String _activeFilter = 'all';

  /// initState() viene eseguito quando la pagina viene creata
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

  // Ogni volta che lo stato cambia Flutter richiama build()
  @override
  Widget build(BuildContext context) {
    
    bool hasBookmarkedEntries = _entries.any((entry) => entry.isBookmarked);
    bool hasPrivateEntries = _entries.any((entry) => entry.isPrivate);


    if (_activeFilter == 'bookmarked' && !hasBookmarkedEntries) {
      _activeFilter = 'all';
    } else if (_activeFilter == 'private' && !hasPrivateEntries) {
      _activeFilter = 'all';
    }

    // Filtra la lista da mostrare in base alla scelta dell'utente
    List<JournalEntry> displayedEntries = _entries.where((entry) {
      if (_activeFilter == 'bookmarked') return entry.isBookmarked;
      if (_activeFilter == 'private') return entry.isPrivate; 
      return true;
    }).toList();

    return Scaffold(
      appBar: EchoAppBar(
        hasBookmarkedEntries: hasBookmarkedEntries,
        hasPrivateEntries: hasPrivateEntries, 
        onFilterSelected: (filter) {
          // setState() cambia la lista
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
              /// Apertura Diario
              onTapEntry: (entry) {
                _handleEntryTap(context, entry);
              },
              /// Privacy Diario
              onTogglePrivacy: (entry) {
                _handleTogglePrivacy(context, entry);
              },
            ),
      
      // Layout dei pulsanti d'azione posizionati in basso
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: EchoBottomActions(
        isFilteringPrivate: _activeFilter == 'private', 
        onInfoPressed: () => _showInfoDialog(context),
        onAddPressed: () => _navigateToEditor(context, null),
      ),
    );
  }

  void _navigateToEditor(BuildContext context, JournalEntry? entry) async {
    /// Navigator.push apre una nuova pagina
    final result = await Navigator.push(
      context,
      // MaterialPageRoute crea la nuova pagina
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
        /// Mounted serve per sapere se la schermata esiste ancora
        if (mounted) createPin(context, newEntry);
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
      
      if (entry.pin == null || entry.pin!.trim().isEmpty) {
        createPin(context, entry);
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

  void _handleTogglePrivacy(BuildContext context, JournalEntry entry) {
    if (entry.isPrivate) {
      
      if (entry.pin == null || entry.pin!.trim().isEmpty) {
        _removePrivacy(entry);
        return;
      }

      // Se è già privato, chiede la verifica del suo PIN specifico prima di renderlo pubblico
      PinManager.showVerificationDialog(
        context: context,
        title: 'Inserisci il PIN per rendere pubblico il diario',
        /// ! certezza che non sia null
        currentPin: entry.pin!,
        
        onResult: (isCorrect) async {
          if (isCorrect) {
            _removePrivacy(entry);
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
      createPin(context, entry);
    }
  }



  void createPin(BuildContext context, JournalEntry entry) {
    /// context serve per aprire il dialog PIN, mostrare SnackBar e interagire con la UI
    PinManager.showCreationDialog(context, (nuovoPin) async {
      /// Crea la copia inserendo il PIN appena digitato specificatamente per questo diario
      /// copyWith crea un nuovo oggetto ed è più sicuro
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

  void _removePrivacy(JournalEntry entry) async {
    
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
