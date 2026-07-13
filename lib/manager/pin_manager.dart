import 'package:flutter/material.dart';

class PinManager {
  
  /// Dialog per la creazione del PIN dedicato a un singolo diario.
  /// Ritorna semplicemente il valore tramite la callback onSuccess.
  static void showCreationDialog(BuildContext context, Function(String) onSuccess) {
    final controller = TextEditingController();
    
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
          onChanged: (value) {
            if (value.length == 4) {
              Navigator.pop(context);
              // Rimuoviamo il vecchio db_service.savePin(value) globale.
              // Passiamo direttamente il PIN scelto alla schermata principale.
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

  /// Dialog per la verifica del PIN specifico di un diario.
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
          decoration: const InputDecoration(
            hintText: 'Inserisci il PIN del diario',
            counterText: "",
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