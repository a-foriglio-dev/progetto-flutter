import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../config/emotional_dictionary.dart';
import '../utils.dart';

/// Schermata di Scrittura Reattiva
class EchoEditorScreen extends StatefulWidget {
  final JournalEntry? entry;

  const EchoEditorScreen({super.key, this.entry});

  @override
  State<EchoEditorScreen> createState() => _EchoEditorScreenState();
}

class _EchoEditorScreenState extends State<EchoEditorScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late EmotionalState _currentState; // assegnata dopo in initState

  // initState() viene eseguito una sola volta
  @override
  void initState() {
    super.initState();
    // Diario già esistente
    if (widget.entry != null) {
      _titleController.text = widget.entry!.title;
      _contentController.text = widget.entry!.content;
      _currentState = widget.entry!.emotion;
    } 

    // Nuovo diario e parte con lo stato emotivo neutro
    else {
      _currentState = emotionalDictionary[0];
    }
    // Ogni volta che il testo cambia Flutter chiama in automatico _handleTextChanged
    _contentController.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    _contentController.removeListener(_handleTextChanged);
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// Reagisce alle modifiche del testo aggiornando lo stato emotivo.
  /// La logica di riconoscimento delle parole chiave vive in utils.dart.
  void _handleTextChanged() {
    final text = _contentController.text;

    if (text.isEmpty) {
      if (_currentState != emotionalDictionary[0]) {
        setState(() {
          _currentState = emotionalDictionary[0];
        });
      }
      return;
    }

    final detected = analyzeText(text);
    if (detected != null && _currentState.name != detected.name) {
      setState(() {
        _currentState = detected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AnimatedContainer anima automaticamente le transizioni ogni volta che una delle sue proprietà cambia. 
      // In questo caso è il gradiente
      
      body: AnimatedContainer(
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _currentState.gradientColors,
          ),
        ),
        
        // SafeArea evita che il contenuto venga coperto da elementi di sistema
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
                      // Navigator.pop(context) chiude la schermata 
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Annulla',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _currentState.name,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_contentController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            
                            // SnackBar: messaggio temporaneo che appare in basso tramite ScaffoldMessenger.of(context)
                            // .of(context) è comune in Flutter per accedere a un widget antenato nell'albero in questo caso lo Scaffold più vicino
                            const SnackBar(
                              content: Text(
                                'Il contenuto del diario non può essere vuoto!',
                              ),
                            ),
                          );
                          return;
                        }
                        final savedEntry = JournalEntry(
                          id:
                              // ?: null-aware access, ??: se null allora
                              // Se l'id esiste mantiene quello originale altrimenti ne viene generato uno nuovo
                              widget.entry?.id ??
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          title: _titleController.text.trim().isEmpty
                              ? "Diario senza titolo"
                              : _titleController.text.trim(),
                          content: _contentController.text,
                          date: widget.entry?.date ?? DateTime.now(),
                          emotion: _currentState,
                          isBookmarked: widget.entry?.isBookmarked ?? false,
                        );
                        Navigator.pop(context, savedEntry);
                      },
                      child: const Text(
                        'Salva',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Divider è una linea sottile e quasi trasparente 
              
              const Divider(color: Colors.white12, height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
                child: TextField(
                  controller: _titleController,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Titolo del giorno...',
                    hintStyle: TextStyle(color: Colors.white38),
                    border: InputBorder.none,
                  ),
                ),
              ),
              
              // Expanded: occupa tutto lo spazio verticale rimanente nella Column 
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.6,
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      hintText:
                          'Inizia a scrivere, l\'interfaccia ti ascolterà...',
                      hintStyle: TextStyle(color: Colors.white30),
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
