import 'package:flutter/material.dart';
import 'screen/journal_screen.dart'; // Rimosso lo slash iniziale per uniformità con le importazioni standard di Flutter

void main() {
  // 1. 🆕 Fissa l'inizializzazione dei binding nativi di Flutter.
  // Essenziale quando si usano database locali (SQLite/SharedPreferences) all'avvio dell'app.
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const EchoApp());
}

class EchoApp extends StatelessWidget {
  const EchoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Echo - Diario Emotivo',
      debugShowCheckedModeBanner: false,
      
      // Il tema globale viene ereditato da tutti i widget della UI
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xff134e5e),
        
        // 2. 🆕 Ottimizzazione per i FloatingActionButton
        // Evita che i bottoni inferiori ereditino stili indesiderati o deformazioni del raggio
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 4,
        ),
      ),
      home: const EchoJournalScreen(),
    );
  }
}