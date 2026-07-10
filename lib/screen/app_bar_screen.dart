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
        padding: const EdgeInsets.only(left: 12.0, top: 2.0, bottom: 2.0), // Margini ridotti al minimo
        child: Center(
          child: SizedBox(
            width: 56,  // Si forza la larghezza reale del logo
            height: 56, // Si forza l'altezza reale del logo (l'altezza standard dell'AppBar è 56)
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/logo.png',
                //  fit: BoxFit.cover dice al logo di riempire tutto lo spazio del SizedBox
                // senza deformarsi o lasciare spazi vuoti che causano lo spostamento laterale.
                fit: BoxFit.cover, 
              ),
            ),
          ),
        ),
      ),
      // 🆕 Teniamo il leadingWidth proporzionato al SizedBox + il padding sinistro.
      // 56 o 60 è il valore ideale per evitare che il logo si sposti troppo a destra o rimanga bloccato.
      leadingWidth: 60,

      // 2. TITOLO DELL'APP AL CENTRO
      title: const Text(
        'I miei Diari',
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