import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiService {
  late final GenerativeModel _model;
  AiService() {

    // Legge la chiave dal file .env
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey == null) {
      throw Exception('Chiave API non trovata! Controlla il file .env');
    }

    _model = GenerativeModel(
      model: 'models/gemini-flash-lite-latest',
      apiKey: apiKey,
      // Qui istruiamo l'IA su come comportarsi
      systemInstruction: Content.text(
          "Sei un life coach empatico in un'app. Analizza la frase dell'utente. "
              "Se è negativa/triste: sii breve, confortante e dolce. "
              "Se è positiva/energica: sii breve, esaltante e usa emoji festose. "
              "Se è neutra: dai una risposta filosofica breve. "
              "Rispondi sempre in massimo 2 frasi."
      ),
    );
  }

  Future<String> getResponse(String userMessage) async {
    try {
      final content = [Content.text(userMessage)];
      final response = await _model.generateContent(content);
      return response.text ?? "Oggi non so trovare le parole, ma ti sono vicino.";
    } catch (e) {
      //print("Errore $e");
      return "Dammi ancora qualche momento. Nel frattempo guarda da dietro la finestra";
    }
  }
}