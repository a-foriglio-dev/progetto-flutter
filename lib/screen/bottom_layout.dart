import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // importa il pacchetto per riprodurre audio


class EchoBottomActions extends StatelessWidget {
  /// VoidCallback: funzione senza parametri e senza valore di ritorno
  final VoidCallback onInfoPressed;
  final VoidCallback onAddPressed;

  static final AudioPlayer _audioPlayer = AudioPlayer();
  
  
  final bool isFilteringPrivate;

  const EchoBottomActions({
    super.key,
    required this.onInfoPressed,
    required this.onAddPressed,
    this.isFilteringPrivate = false,
  });

  @override
  Widget build(BuildContext context) {
    
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
      
        Padding(
          padding: const EdgeInsets.only(right: 15.0), // Aggiunto padding destro per simmetria con il sinistro
          child: FloatingActionButton(
            heroTag: 'addBtn',
            backgroundColor: addBtnBgColor,
            elevation: 4,
            onPressed: () {
              _audioPlayer.play(AssetSource('sounds/matthewvakaliuk73627-mouse-click-290204.mp3'));
              onAddPressed();
            },
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
