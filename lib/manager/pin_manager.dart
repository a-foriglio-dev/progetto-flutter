import 'package:flutter/material.dart';

class PinManager {
  /// Dialog per la creazione del PIN iniziale
  static void showCreationDialog(BuildContext context, Function(String) onSuccess) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Crea il tuo PIN di Sicurezza'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 4,
          decoration: const InputDecoration(hintText: 'Inserisci 4 cifre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.length == 4) {
                Navigator.pop(context);
                onSuccess(controller.text);
              }
            },
            child: const Text('Salva'),
          ),
        ],
      ),
    );
  }

  /// Dialog per la verifica del PIN (per sbloccare o rimuovere la privacy)
  static void showVerificationDialog({
    required BuildContext context,
    required String title,
    required String? currentPin,
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
          decoration: const InputDecoration(hintText: 'PIN'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onResult(false);
            },
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Verifica se il PIN inserito corrisponde a quello salvato
              onResult(controller.text == currentPin);
            },
            child: const Text('Verifica'),
          ),
        ],
      ),
    );
  }
}