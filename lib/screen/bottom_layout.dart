import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:audioplayers/audioplayers.dart';
>>>>>>> 049b488 (suono aggiunto)

/// Layout dei pulsanti d'azione posizionati in basso: il tasto info
/// (piccolo, a sinistra) e il tasto per aggiungere un nuovo diario
/// (grande, a destra).
class EchoBottomActions extends StatelessWidget {
  final VoidCallback onInfoPressed;
  final VoidCallback onAddPressed;
<<<<<<< HEAD
=======

  static final AudioPlayer _audioPlayer = AudioPlayer();
>>>>>>> 049b488 (suono aggiunto)
  
  /// 🆕 Cambiato da isFilterPrivate a isFilteringPrivate per combaciare perfettamente
  /// con la chiamata effettuata in journal_screen.dart ed evitare errori di compilazione.
  final bool isFilteringPrivate;

  const EchoBottomActions({
    super.key,
    required this.onInfoPressed,
    required this.onAddPressed,
    this.isFilteringPrivate = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determiniamo il colore del tasto "+" in base allo stato del filtro di privacy
    final Color addBtnBgColor = isFilteringPrivate ? Colors.amber.shade700 : Colors.white;
    final Color addBtnIconColor = isFilteringPrivate ? Colors.white : const Color(0xff134e5e);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Icona dell'info riposizionata in basso a sinistra
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: FloatingActionButton(
            heroTag: 'infoBtn',
            mini: true, // Più piccolo per differenziarlo dal tasto di aggiunta
            backgroundColor: Colors.white.withOpacity(0.2),
            elevation: 0,
            onPressed: onInfoPressed,
            child: const Icon(Icons.info_outline, color: Colors.white),
          ),
        ),
        
        // Pulsante per aggiungere un nuovo diario (In basso a destra di default)
        // 🆕 Ora utilizza correttamente addBtnBgColor, addBtnIconColor e cambia icona 
        // in un lucchetto aperto se l'utente si trova già nella sezione sicura.
        Padding(
          padding: const EdgeInsets.only(right: 15.0), // Aggiunto padding destro per simmetria con il sinistro
          child: FloatingActionButton(
            heroTag: 'addBtn',
            backgroundColor: addBtnBgColor,
            elevation: 4,
<<<<<<< HEAD
            onPressed: onAddPressed,
=======
            onPressed: () {
              _audioPlayer.play(AssetSource('sounds/matthewvakaliuk73627-mouse-click-290204.mp3'));
              onAddPressed();
            },
>>>>>>> 049b488 (suono aggiunto)
            child: Icon(
              isFilteringPrivate ? Icons.lock_open_rounded : Icons.add, 
              color: addBtnIconColor,
            ),
          ),
        ),
      ],
    );
  }
}