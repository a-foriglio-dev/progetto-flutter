// Importa i widget Material: AppBar, PopMenuButton, Text, Icon, Size
import 'package:flutter/material.dart';

/// AppBar della schermata principale: titolo centrato e, al posto del
/// leading di default, il menu dei filtri (icona a tre linee).
/// implements PreferredSizeWidget: serve dato che si usa class EchoAppBar al posto di appBar
/// Questo perchè deve sapere quanto spazio verticale dedicare alla barra superiore
class EchoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasBookmarkedEntries;
  // OnFilterSelected è una callback di tipo ValueChanged<String>. 
  // Funzione che riceve una stringa voidFunction(String) che viene passata dal genitore journal_screen.dart
  final ValueChanged<String> onFilterSelected;

  // const: se non cambia Flutter può riusare la stessa istanza senza ricrearla. 
  // super.key passa la chiave opzionale al widget 
  const EchoAppBar({
    super.key,
    required this.hasBookmarkedEntries,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Echo - I miei Diari',
        style: TextStyle(fontWeight: FontWeight.w300),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      // Icona filtro tre linee 
      // PopupMenuButton chiama onfFilterSelected passandogli il valore scelto
      leading: PopupMenuButton<String>(
        icon: const Icon(
          Icons.filter_list,
        ), // Icona con tre linee per il filtro
        
        onSelected: onFilterSelected,

        // ItemBuilder definisce quali voci devono comparire nel menu quando viene aperto
        itemBuilder: (BuildContext context) => [
        
        
          const PopupMenuItem<String>(
            value: 'all',
            child: Text('Tutti i diari'),
          ),
          // Mostra l'opzione dei segnalibri solo se presente almeno un diario contrassegnato
          if (hasBookmarkedEntries)
            const PopupMenuItem<String>(
              value: 'bookmarked',
              child: Text('Con segnalibro'),
            ),
        ],
      ),
    );
  }

  // Richiesto da PreferredSizeWidget: dice a Scaffold quanto deve essere
  // alta questa AppBar (l'altezza standard di una AppBar Material).
  // Ciò che soddisfa il contratto PreferredSizeWidget
  // Size.fromHeight(...): indica larghezza illimitata, alezza fissa pari a KToolHeight: 56 logical pixel
  // In questo modo lo scaffold di journal_screen.dart
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
