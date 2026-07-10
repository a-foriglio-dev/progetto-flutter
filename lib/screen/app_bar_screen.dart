import 'package:flutter/material.dart';

/// AppBar della schermata principale di Echo.
/// Disposizione: Logo aziendale a sinistra, titolo centrato, menu filtri a destra.
class EchoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasBookmarkedEntries;
  
  /// Callback per notificare il widget padre (journal_screen) sul filtro selezionato.
  final ValueChanged<String> onFilterSelected;

  const EchoAppBar({
    super.key,
    required this.hasBookmarkedEntries,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // 1. LOGO DA ASSETS A SINISTRA
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.contain, // Mantiene le proporzioni originali del logo senza tagliarlo
          ),
        ),
      ),
      leadingWidth: 56, // Spazio orizzontale riservato al logo

      // 2. TITOLO DELL'APP AL CENTRO
      title: const Text(
        'Echo - I miei Diari',
        style: TextStyle(fontWeight: FontWeight.w300),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,

      // 3. MENU DEI FILTRI (TRE LINEE) A DESTRA
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.filter_list,
          ),
          onSelected: onFilterSelected,
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'all',
              child: Text('Tutti i diari'),
            ),
            // Mostra l'opzione dei segnalibri solo se ce n'è almeno uno attivo
            if (hasBookmarkedEntries)
              const PopupMenuItem<String>(
                value: 'bookmarked',
                child: Text('Con segnalibro'),
              ),
          ],
        ),
        const SizedBox(width: 8.0), // Distanza di sicurezza dal bordo destro dello schermo
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}