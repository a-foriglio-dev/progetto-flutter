import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../config/emotional_dictionary.dart';
import '../utils.dart';

/// Schermata di Scrittura Reattiva con Mix di Colori Dinamico e Persistenza Dati.
class EchoEditorScreen extends StatefulWidget {
  final JournalEntry? entry;

  const EchoEditorScreen({super.key, this.entry});

  @override
  State<EchoEditorScreen> createState() => _EchoEditorScreenState();
}

class _EchoEditorScreenState extends State<EchoEditorScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  
  late EmotionalState _currentState; // Emozione prevalente attuale
  late List<Color> _mixedGradientColors; // Lista dei colori dinamici per lo sfondo

  @override
  void initState() {
    super.initState();
    
    // Se stiamo modificando un diario già esistente
    if (widget.entry != null) {
      _titleController.text = widget.entry!.title;
      _contentController.text = widget.entry!.content;
      _currentState = widget.entry!.emotion;
      
      // Eseguiamo un'analisi iniziale del testo esistente per ricreare il mix cromatico corretto
      final initialResult = analyzeText(widget.entry!.content);
      _mixedGradientColors = initialResult.mixedColors;
    } 
    // Se è un nuovo diario, partiamo dallo stato neutro di default (Calma)
    else {
      _currentState = emotionalDictionary[0];
      _mixedGradientColors = List.from(emotionalDictionary[0].gradientColors);
    }
    
    // Ascolta i cambiamenti del testo in tempo reale
    _contentController.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    _contentController.removeListener(_handleTextChanged);
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// Reagisce alle modifiche del testo aggiornando l'emozione prevalente e il mix cromatico.
  void _handleTextChanged() {
    final text = _contentController.text;

    // Chiediamo a utils.dart l'analisi completa del testo
    final result = analyzeText(text);

    // Controlliamo se i colori o l'emozione dominante sono cambiati per evitare setState inutili
    if (_currentState.name != result.dominantEmotion.name || 
        _mixedGradientColors != result.mixedColors) {
      setState(() {
        _currentState = result.dominantEmotion;
        _mixedGradientColors = result.mixedColors;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calcoliamo il contrasto dinamico basandoci sul colore principale dello sfondo corrente
    final Color currentPrimaryColor = _mixedGradientColors.isNotEmpty 
        ? _mixedGradientColors.first 
        : Colors.grey;

    final bool isDarkBackground = ThemeData.estimateBrightnessForColor(currentPrimaryColor) == Brightness.dark;

    // Colori adattivi per i testi e le etichette dell'interfaccia
    final Color inputTextColor = isDarkBackground ? Colors.white : Colors.black87;
    final Color hintTextColor = isDarkBackground ? Colors.white38 : Colors.black38;
    final Color actionButtonColor = isDarkBackground ? Colors.white70 : Colors.black54;
    final Color saveButtonColor = isDarkBackground ? Colors.white : Colors.black;

    return Scaffold(
      // AnimatedContainer si occupa di mixare i gradienti in modo fluido durante i cambi di stato
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800), // Risposta fluida e reattiva al tocco
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _mixedGradientColors, // Usiamo la lista di colori mixati dinamicamente
          ),
        ),
        
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Annulla',
                        style: TextStyle(color: actionButtonColor, fontSize: 16),
                      ),
                    ),
                    
                    // Badge indicatore dello stato emotivo prevalente
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkBackground ? Colors.white.withOpacity(0.15) : Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _currentState.name.toUpperCase(),
                        style: TextStyle(
                          color: inputTextColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    
                    TextButton(
                      onPressed: () {
                        if (_contentController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Il contenuto del diario non può essere vuoto!'),
                            ),
                          );
                          return;
                        }
                        
                        // Costruiamo l'oggetto preservando tutti i campi, incluso il PIN
                        final savedEntry = JournalEntry(
                          id: widget.entry?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                          title: _titleController.text.trim().isEmpty
                              ? "Diario senza titolo"
                              : _titleController.text.trim(),
                          content: _contentController.text,
                          date: widget.entry?.date ?? DateTime.now(),
                          emotion: _currentState, // Salviamo l'emozione quantitativamente dominante
                          isBookmarked: widget.entry?.isBookmarked ?? false, // Preserva lo stato del segnalibro
                          isPrivate: widget.entry?.isPrivate ?? false,       // Preserva lo stato di privacy
                          pin: widget.entry?.pin, // 🆕 CORREZIONE: Mantiene il PIN specifico del diario nel DB!
                        );
                        Navigator.pop(context, savedEntry);
                      },
                      child: Text(
                        'Salva',
                        style: TextStyle(
                          color: saveButtonColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Divider(color: isDarkBackground ? Colors.white12 : Colors.black12, height: 1),
              
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
                child: TextField(
                  controller: _titleController,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: inputTextColor, // Contrasto dinamico sul titolo
                  ),
                  decoration: InputDecoration(
                    hintText: 'Titolo del giorno...',
                    hintStyle: TextStyle(color: hintTextColor),
                    border: InputBorder.none,
                  ),
                ),
              ),
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.6,
                      color: inputTextColor, // Contrasto dinamico sul testo principale
                    ),
                    decoration: InputDecoration(
                      hintText: 'Inizia a scrivere, l\'interfaccia ti ascolterà...',
                      hintStyle: TextStyle(color: hintTextColor),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}