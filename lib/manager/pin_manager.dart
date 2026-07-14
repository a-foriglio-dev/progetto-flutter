import 'package:flutter/material.dart';

class PinManager {
  
 
  static void showCreationDialog(BuildContext context, Function(String) onSuccess) {
    final controller = TextEditingController(); // controlla il contenuto del testo
    
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => AlertDialog(
        title: const Text('Crea il PIN per questo diario'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 4,
          /// onChanged viene eseguita ogni volta che cambia il testo
          onChanged: (value) {
            if (value.length == 4) {
              Navigator.pop(context); // toglie la finestra dallo schermo
              onSuccess(value);
            }
          },
          decoration: const InputDecoration(
            hintText: 'Inserisci 4 cifre',
            counterText: "", 
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
        ],
      ),
    );
  }

  /// Funzione per la verifica del PIN specifico di un diario.
  static void showVerificationDialog({
    required BuildContext context,
    required String title,
    required String currentPin, 
    required Function(bool) onResult,
  }) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 4,
          onChanged: (value) {
            if (value.length == 4) {
              Navigator.pop(context);
              onResult(value == currentPin);
            }
          },
          // decoration: personalizza l'aspetto del campo di testo
          decoration: const InputDecoration(
            hintText: 'Inserisci il PIN del diario',
            counterText: "", // Nasconde il contatore dei caratteri
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onResult(false);
            },
            child: const Text('Annulla'),
          ),
        ],
      ),
    );
  }
}
