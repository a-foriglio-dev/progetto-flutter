import 'package:flutter/material.dart';
import 'screen/journal_screen.dart'; 

void main() {
  // Fissa l'inizializzazione dei binding nativi di Flutter.
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
      debugShowCheckedModeBanner: false, // Nasconde il nastro rosso con la scritta debug
      
      // Il tema globale viene ereditato da tutti i widget della UI
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xff134e5e),
        
        //  Ottimizzazione per i FloatingActionButton
        // Evita che i bottoni inferiori ereditino stili indesiderati o deformazioni del raggio
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 4,
        ),
      ),
      home: const EchoJournalScreen(),
    );
  }
}
