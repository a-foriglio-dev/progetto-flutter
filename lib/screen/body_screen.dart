import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../utils.dart'; // Importiamo le utility di analisi

/// Corpo della schermata principale: mostra la lista dei diari filtrata,
/// oppure un messaggio se non ce ne sono da mostrare.
class EchoBody extends StatelessWidget {
  final List<JournalEntry> displayedEntries;
  final String activeFilter;
  
  // Le callback che notificano gli eventi verso il widget padre
  final void Function(JournalEntry entry) onToggleBookmark;
  final void Function(JournalEntry entry) onDelete;
  final void Function(JournalEntry entry) onTapEntry;
  final void Function(JournalEntry entry) onTogglePrivacy;

  const EchoBody({
    super.key,
    required this.displayedEntries,
    required this.activeFilter,
    required this.onToggleBookmark,
    required this.onDelete,
    required this.onTapEntry,
    required this.onTogglePrivacy,
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
        
        /// Ricalcola il mix di colori effettivo basandoci sul testo del diario
        final analysis = analyzeText(entry.content);
        final List<Color> cardColors = analysis.mixedColors;

        /// Recupera il colore principale della card per calcolare il contrasto
        final Color cardPrimaryColor = cardColors.isNotEmpty 
            ? cardColors.first 
            : Colors.grey;

        /// Determina se lo sfondo locale sotto le icone è chiaro o scuro
        final bool isDarkBackground = ThemeData.estimateBrightnessForColor(cardPrimaryColor) == Brightness.dark;

        /// Colore dinamico armonizzato per le icone del segnalibro e del lucchetto
        final Color dynamicIconColor = isDarkBackground 
            ? Colors.white.withOpacity(0.9)  // Bianco morbido su sfondi scuri (Ansia, Tristezza)
            : Colors.black.withOpacity(0.75); // Nero fumo su sfondi chiari (Gioia, Serenità)

        return Card(
          /// EdgeInsets per dare spazio tra le card
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Container(
            // decoration: BoxDecoration applica lo sfondo emotivo
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardColors, // Applichiamo la lista dei colori mixati
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                 
                  color: isDarkBackground ? Colors.white : Colors.black,
                ),
              ),
              
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0), /// Aggiunto 8 pixel sopra il testo
                child: Text(
                  // Nascondiamo l'anteprima del testo se il diario è privato
                  entry.isPrivate 
                      ? 'Contenuto protetto da PIN 🔒' 
                      : entry.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDarkBackground ? Colors.white70 : Colors.black54, // Testo leggibile in base al contrasto della card
                  ),
                ),
              ),

              // Parte destra della card
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Mostra il lucchetto adattato cromaticamente allo sfondo
                  if (entry.isPrivate)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.lock, color: dynamicIconColor, size: 20),
                    ),
                  // Mostra il segnalibro adattato cromaticamente allo sfondo
                  if (entry.isBookmarked)
                    Icon(Icons.bookmark, color: dynamicIconColor, size: 24),
                    
                  PopupMenuButton<String>(
                    iconColor: dynamicIconColor,
                    onSelected: (value) {
                      if (value == 'bookmark') {
                        onToggleBookmark(entry);
                      } else if (value == 'delete') {
                        onDelete(entry);
                      } else if (value == 'privacy') {
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
