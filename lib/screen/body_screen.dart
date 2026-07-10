import 'package:flutter/material.dart';
import '../models/journal_entry.dart';

/// Corpo della schermata principale: mostra la lista dei diari filtrata,
/// oppure un messaggio se non ce ne sono da mostrare.
class EchoBody extends StatelessWidget {
  final List<JournalEntry> displayedEntries;
  final String activeFilter;
  
  // Le callback che notificano gli eventi verso il widget padre
  final void Function(JournalEntry entry) onToggleBookmark;
  final void Function(JournalEntry entry) onDelete;
  final void Function(JournalEntry entry) onTapEntry;
  // 🆕 AGGIUNTA QUESTA RIGA: serve a ricevere la funzione per la privacy
  final void Function(JournalEntry entry) onTogglePrivacy;

  const EchoBody({
    super.key,
    required this.displayedEntries,
    required this.activeFilter,
    required this.onToggleBookmark,
    required this.onDelete,
    required this.onTapEntry,
    required this.onTogglePrivacy, // 🆕 AGGIUNTA QUESTA RIGA
  });

  @override
  Widget build(BuildContext context) {
    if (displayedEntries.isEmpty) {
      return Center(
        child: Text(
          activeFilter == 'bookmarked'
              ? 'Nessun diario tra i segnalibri.'
              : 'Nessun diario presente. Inizia a scrivere!',
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: displayedEntries.length,
      itemBuilder: (context, index) {
        final entry = displayedEntries[index];
        
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: entry.emotion.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              title: Text(
                entry.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  // 🆕 Nascondiamo l'anteprima del testo se il diario è privato
                  entry.isPrivate 
                      ? 'Contenuto protetto da PIN 🔒' 
                      : entry.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
              ),
              
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🆕 Mostra un lucchetto se il diario è privato
                  if (entry.isPrivate)
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.lock, color: Colors.white, size: 20),
                    ),
                  if (entry.isBookmarked)
                    const Icon(Icons.bookmark, color: Colors.black),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'bookmark') {
                        onToggleBookmark(entry);
                      } else if (value == 'delete') {
                        onDelete(entry);
                      } else if (value == 'privacy') {
                        //  Attiva la callback quando l'utente preme sul menu
                        onTogglePrivacy(entry);
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        value: 'bookmark',
                        child: Text(
                          entry.isBookmarked
                              ? 'Rimuovi dai segnalibri'
                              : 'Aggiungi ai segnalibri',
                        ),
                      ),
                      //  Nuova opzione nel menu a tendina
                      PopupMenuItem(
                        value: 'privacy',
                        child: Text(
                          entry.isPrivate
                              ? 'Rendi pubblico'
                              : 'Rendi privato',
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Elimina',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () => onTapEntry(entry),
            ),
          ),
        );
      },
    );
  }
}