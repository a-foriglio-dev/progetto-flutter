# Echo App 📱

**Echo App** è un'applicazione diario personale sviluppata in Flutter che unisce un design moderno e un'analisi empatica del testo a funzionalità avanzate di privacy e sicurezza. 

L'applicazione analizza le parole digitate in tempo reale per adattare l'interfaccia allo stato d'animo del diario e permette di proteggere i pensieri più intimi attraverso un sistema di blocco tramite PIN.

---
   
## ✨ Funzionalità Principali

* **Analisi Empatica del Testo:** Lo sfondo e i gradienti delle schede cambiano colore dinamicamente in base alle emozioni rilevate nelle parole digitate.
* **Gestione della Privacy ** Possibilità di rendere privati i singoli diari. Un diario privato nasconde l'anteprima del testo nella lista principale e richiede un PIN di 4 cifre per essere aperto o reso nuovamente pubblico.
* **Filtri Avanzati:** Sistema di gestione dei Segnalibri (Bookmarks) per isolare rapidamente i diari preferiti tramite l'interfaccia nell'AppBar.
* **Architettura Pulita:** Separazione netta delle responsabilità (UI, Modelli Dati, Logica di Business e Gestione dei Servizi).
* **Lista Fluida:** Rendering ottimizzato e *lazy* tramite `ListView.builder` per prestazioni eccellenti anche con centinaia di diari.

---

## 🎨 Palette di Colori & Stati Emotivi

L'applicazione utilizza una palette cromatica basata su gradienti sfumati per riflettere visivamente lo stato psicologico associato a ciascun testo. I colori principali associati al dizionario emozionale (`emotionalDictionary`) includono:

| Stato Emotivo | Sfumatura Gradiente (Colori) | Significato Visivo |
| :--- | :--- | :--- |
| **Serenità / Gioia** | `Colors.teal` ➡️ `Colors.greenAccent` | Rappresenta la calma, la pace e la felicità stabile. |
| **Tristezza / Stanchezza** | `Colors.blueGrey` ➡️ `Colors.blue` | Riflette momenti difficili, malinconia o bassa energia. |
| **Rabbia / Frustrazione** | `Colors.redAccent` ➡️ `Colors.orangeAccent` | Identifica picchi di stress, tensione o forte irritazione. |
| **Ansia / Paura** | `Colors.deepPurple` ➡️ `Colors.indigo` | Associa le tonalità scure del viola alla preoccupazione e all'incertezza. |
| **Neutro / Riflessivo** | `Colors.grey` ➡️ `Colors.blueGrey` | Utilizzato quando il testo non presenta picchi emotivi evidenti. |

---

## 🛠️ Architettura e Struttura del Progetto

Il codice è organizzato seguendo le migliori pratiche di sviluppo in Flutter per garantire modularità e manutenibilità:

```text
lib/
│
├── config/
│   └── emotional_dictionary.dart  # Dizionario e logica per l'associazione testo/emozioni
│
├── manager/
│   └── pin_manager.dart           # Gestore dei Dialog e della logica di verifica/creazione PIN
│
├── models/
│   └── journal_entry.dart         # Modelli dati per i Diari (JournalEntry) e Stati Emotivi
│
├── screen/
│   ├── app_bar_screen.dart        # Widget personalizzato per la barra superiore (Filtri)
│   ├── body_screen.dart           # Lista dinamica (EchoBody) con supporto a diari privati e pubblici
│   ├── bottom_layout.dart         # Widget d'azione inferiore (Aggiunta diario, Info)
│   ├── editor_screen.dart         # Schermata di scrittura e analisi in tempo reale
│   └── journal_screen.dart        # Schermata principale (Coordinatore dello Stato dell'app)
│
└── main.dart                      # Punto di ingresso dell'applicazione