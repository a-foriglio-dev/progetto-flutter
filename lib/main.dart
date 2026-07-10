import 'package:flutter/material.dart';
import '/screen/journal_screen.dart';

void main() {
  runApp(const EchoApp());
}

class EchoApp extends StatelessWidget {
  const EchoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Echo - Diario Emotivo',
      debugShowCheckedModeBanner: false,
      // theme: è globale e viene ereditato da tutti i widget Material figli
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xff134e5e),
      ),
      home: const EchoJournalScreen(),
    );
  }
}
