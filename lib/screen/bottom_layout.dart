import 'package:flutter/material.dart';

/// Layout dei pulsanti d'azione posizionati in basso: il tasto info
/// (piccolo, a sinistra) e il tasto per aggiungere un nuovo diario
/// (grande, a destra).
class EchoBottomActions extends StatelessWidget {
  final VoidCallback onInfoPressed;
  final VoidCallback onAddPressed;

  const EchoBottomActions({
    super.key,
    required this.onInfoPressed,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
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
            child: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: onInfoPressed,
          ),
        ),
        // Pulsante per aggiungere un nuovo diario (In basso a destra di default)
        FloatingActionButton(
          heroTag: 'addBtn',
          backgroundColor: Colors.white,
          child: const Icon(Icons.add, color: Color(0xff134e5e)),
          onPressed: onAddPressed,
        ),
      ],
    );
  }
}
