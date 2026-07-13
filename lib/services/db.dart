import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/journal_entry.dart';

<<<<<<< HEAD

Future<Database> openEchoDatabase() async {
  return openDatabase(
    join(await getDatabasesPath(), 'echo.db'),
    version: 2, 
    // Se l'utente usa l'app per la prima volta viene eseguito onCreate
    onCreate: (db, version) async {
      
      await db.execute(
        'CREATE TABLE entries(id TEXT PRIMARY KEY, title TEXT, content TEXT, date TEXT, emotion_name TEXT, is_bookmarked INTEGER, is_private INTEGER, pin TEXT)',
      );
      // App-settings salva coppie di valori tipo chiave-valore
=======
// Inizializza e apre il database con gestione delle versioni
Future<Database> openEchoDatabase() async {
  return openDatabase(
    join(await getDatabasesPath(), 'echo.db'),
    version: 2, // 🆕 Aggiornato da 1 a 2 per forzare l'aggiornamento della struttura
    onCreate: (db, version) async {
      // Creazione della tabella per i diari (ORA INCLUDE LA COLONNA PIN)
      await db.execute(
        'CREATE TABLE entries(id TEXT PRIMARY KEY, title TEXT, content TEXT, date TEXT, emotion_name TEXT, is_bookmarked INTEGER, is_private INTEGER, pin TEXT)',
      );
      // Creazione della tabella per le impostazioni dell'app (come il PIN)
>>>>>>> 049b488 (suono aggiunto)
      await db.execute(
        'CREATE TABLE app_settings(key TEXT PRIMARY KEY, value TEXT)',
      );
    },
<<<<<<< HEAD
    //  Gestisce il passaggio dei vecchi utenti dalla versione 1 alla versione 2 senza perdere i diari precedenti
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {

=======
    // 🆕 Gestisce il passaggio dei vecchi utenti dalla versione 1 alla versione 2 senza perdere i diari precedenti
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        // Aggiunge la colonna pin alla tabella entries esistente
>>>>>>> 049b488 (suono aggiunto)
        await db.execute('ALTER TABLE entries ADD COLUMN pin TEXT');
      }
    },
  );
}

// Salva o aggiorna un diario
Future<void> saveEntry(JournalEntry entry) async {
  final db = await openEchoDatabase();
<<<<<<< HEAD
  // ConflictAlgorithm.replace: se esiste già un diario con lo stesso id, lo sovrascrive 
  await db.insert('entries', entry.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
}


=======
  await db.insert('entries', entry.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
}

// Carica tutti i diari dal più recente
>>>>>>> 049b488 (suono aggiunto)
Future<List<JournalEntry>> loadEntries() async {
  final db = await openEchoDatabase();
  final List<Map<String, dynamic>> maps = await db.query('entries', orderBy: 'date DESC');
  return maps.map((map) => JournalEntry.fromMap(map)).toList();
}

// Elimina un diario
Future<void> deleteEntry(String id) async {
  final db = await openEchoDatabase();
<<<<<<< HEAD
  // si usa whereArgs per evitare SQL injection
=======
>>>>>>> 049b488 (suono aggiunto)
  await db.delete('entries', where: 'id = ?', whereArgs: [id]);
}

// Salva o aggiorna il PIN in SQLite
Future<void> savePin(String pin) async {
  final db = await openEchoDatabase();
  await db.execute('CREATE TABLE IF NOT EXISTS app_settings(key TEXT PRIMARY KEY, value TEXT)');
  
  await db.insert(
    'app_settings', 
    {'key': 'app_pin', 'value': pin}, 
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// Recupera il PIN memorizzato in SQLite (ritorna null se non esiste)
Future<String?> loadPin() async {
  final db = await openEchoDatabase();
  await db.execute('CREATE TABLE IF NOT EXISTS app_settings(key TEXT PRIMARY KEY, value TEXT)');
  
  final List<Map<String, dynamic>> maps = await db.query(
    'app_settings', 
    where: 'key = ?', 
    whereArgs: ['app_pin'],
  );
  
  if (maps.isNotEmpty) {
    return maps.first['value'] as String?;
  }
  return null;
}

// ALIAS DI SICUREZZA: Mappa la richiesta di getPin() direttamente su loadPin()
Future<String?> getPin() async {
  return await loadPin();
}