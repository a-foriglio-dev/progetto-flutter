import 'package:flutter/material.dart';
import '../models/journal_entry.dart';

/// Corpo della schermata principale: mostra la lista dei diari filtrata,
/// oppure un messaggio se non ce ne sono da mostrare.
/// E' StatelessWidget dato che non gestisce nessuno stato internamente, riceve tutto dall'esterno e si limita a disegnare e notificare eventi verso l'alto
class EchoBody extends StatelessWidget {
  final List<JournalEntry> displayedEntries;
  final String activeFilter;
  // Le tre callback che vengono da journal_screen.dart
  final void Function(JournalEntry entry) onToggleBookmark;
  final void Function(JournalEntry entry) onDelete;
  final void Function(JournalEntry entry) onTapEntry;

  const EchoBody({
    super.key,
    required this.displayedEntries,
    required this.activeFilter,
    required this.onToggleBookmark,
    required this.onDelete,
    required this.onTapEntry,
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

    // ListView.builder costruisce una lista scorrevole in modo lazy
    // Modo lazy: chiama itemBuilder solo per gli elementi effettivamente a schermo

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: displayedEntries.length,
      itemBuilder: (context, index) {
        final entry = displayedEntries[index];
        
        // Card è un contenitore Material con ombra e bordi
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
            
            // ListTile è un widget pensato per righe di lista con titolo, sottotitolo e widget accessori a sinistra/destra
            
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
                  entry.content,
                  // maxLines: limita il contenuto del testo a una sola riga
                  maxLines: 1,
                  // overflow: TextOverflow.ellipsis fa sì che se il testo è più lungo di quanto ci sta in una riga, venga tagliato e sostituito con ...
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
              ),
              
              // Trailing è lo spazio a destra del ListTile. 

              trailing: Row(
                // mainAxisSize: MainAxisSize.min dice di occupare solo lo spazio necessario ai suoi figli invece di espandersi al massimo disponibile
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (entry.isBookmarked)
                    const Icon(Icons.bookmark, color: Colors.amber),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'bookmark') {
                        onToggleBookmark(entry);
                      } else if (value == 'delete') {
                        onDelete(entry);
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
