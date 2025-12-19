import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Per le chiavi segrete
import 'dart:math';
import 'ai_service.dart'; // Importiamo il file che abbiamo appena creato

Future<void> main() async {
  // Carichiamo il file .env prima di avviare l'app
  await dotenv.load(fileName: ".env");
  runApp(const BuongiornoApp());
}

class BuongiornoApp extends StatelessWidget {
  const BuongiornoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buongiorno AI',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --- SERVIZIO AI ---
  final AiService _aiService = AiService(); // Istanza del cervello

  // --- DATI LOCALI (Rimangono per arricchire l'app) ---
  final List<String> citazioni = [
    "Il momento migliore è ora.",
    "Sii il cambiamento che vuoi vedere.",
    "Non smettere mai di sognare.",
    "La fortuna aiuta gli audaci."
  ];

  final List<String> sfide = [
    "Bevi un bicchiere d'acqua.",
    "Fai 10 respiri profondi.",
    "Scrivi un obiettivo per adesso.",
    "Manda un messaggio gentile a qualcuno."
  ];

  // --- STATO ---
  final TextEditingController _controller = TextEditingController();
  String _testoRisposta = "";
  Color _coloreRisposta = Colors.black;
  String _testoSfida = "";
  String _testoCitazione = "";
  bool _cardVisible = false;
  bool _staCaricando = false; // Nuovo stato per il caricamento

  // --- NUOVA LOGICA CON IA ---
  void _azioneBottone() async {
    // 1. Nascondi tastiera
    FocusScope.of(context).unfocus();

    String messaggioUtente = _controller.text;

    // Controllo campo vuoto
    if (messaggioUtente.isEmpty) {
      setState(() {
        _testoRisposta = "Scrivi qualcosa prima!";
        _coloreRisposta = Colors.red;
        _cardVisible = false;
      });
      return;
    }

    _controller.clear();

    // 2. Mostra caricamento
    setState(() {
      _staCaricando = true;
      _testoRisposta = ""; // Pulisce la risposta vecchia
      _cardVisible = false;
    });

    // 3. CHIAMA L'IA (Aspetta la risposta)
    String rispostaIA = await _aiService.getResponse(messaggioUtente);

    // 4. Aggiorna l'interfaccia con la risposta
    setState(() {
      _staCaricando = false; // Stop caricamento
      _testoRisposta = rispostaIA;
      _coloreRisposta = Colors.indigo; // Colore standard per l'IA

      // Genera comunque sfida e citazione casuali
      _testoSfida = "MISSIONE: ${sfide[Random().nextInt(sfide.length)]}";
      _testoCitazione = "\"${citazioni[Random().nextInt(citazioni.length)]}\"";
      _cardVisible = true;
    });
  }

  // --- LAYOUT ---
  @override
  Widget build(BuildContext context) {
    String dataOggi = DateTime.now().toLocal().toString().split(' ')[0];
    int oraAttuale = DateTime.now().hour;

    // Default Sera/Notte
    String titolo = "Buona sera!";
    String domanda = "Com'è andata la giornata?";
    IconData icona = Icons.nights_stay;
    Color coloreIcona = Colors.indigo;

    // Logica Orari
    if (oraAttuale >= 5 && oraAttuale < 8) {
      titolo = "L'alba di un nuovo giorno!";
      domanda = "Pronto a conquistare il mondo?";
      icona = Icons.wb_twilight;
      coloreIcona = Colors.orangeAccent;
    } else if (oraAttuale >= 8 && oraAttuale < 13) {
      titolo = "Buongiorno!";
      domanda = "Come hai dormito stanotte?";
      icona = Icons.wb_sunny;
      coloreIcona = Colors.orange;
    } else if (oraAttuale >= 13 && oraAttuale < 19) {
      titolo = "Buon pomeriggio!";
      domanda = "Come procede il lavoro?";
      icona = Icons.wb_cloudy;
      coloreIcona = Colors.amber;
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icona, size: 70, color: coloreIcona),
                  const SizedBox(height: 10),
                  Text(
                    titolo,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Oggi è $dataOggi",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 25),

                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: domanda,
                      hintText: "Scrivi qui...",
                      prefixIcon: const Icon(Icons.edit),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // BOTTONE
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _staCaricando ? null : _azioneBottone, // Disabilita se carica
                      style: ElevatedButton.styleFrom(
                        backgroundColor: coloreIcona,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: _staCaricando
                          ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                          : const Text(
                        "Dammi la carica",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // RISPOSTA IA
                  Text(
                    _testoRisposta,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _coloreRisposta
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // CARDA SFIDA/CITAZIONE
                  AnimatedOpacity(
                    opacity: _cardVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: _cardVisible
                        ? Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _testoSfida,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Divider(color: Colors.blue),
                          Text(
                            _testoCitazione,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade700,
                                fontStyle: FontStyle.italic
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}