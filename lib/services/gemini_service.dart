// gemini_service.dart
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/quiz_model.dart';

class GeminiService {
  final GenerativeModel model;

  GeminiService() : model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: 'AIzaSyBcfltVrn6xIKW38wWKbqLyU0B13WpE9JE');

    String cleanJson(response) {
      return response
          .replaceAll("```json", "")
          .replaceAll("```", "")
          .trim();
    }

  Future<List<QuizModel>> generateQuiz(String material) async {
    final prompt = """
    Buatkan 3 soal pilihan ganda tentang materi ini: $material.
    Format output HARUS JSON valid tanpa tambahan apapun:
    {
      "quiz": [
        {"question": "...", "options": ["A","B","C","D"], "answer": "A"},
        {"question": "....", "options": ["A", "B", "C", "D"], "answer": "C"}
      ]
    }
    """;

    final response = await model.generateContent([Content.text(prompt)]);
    final rawText = response.text ?? '';

    try {
      final cleaned = cleanJson(rawText);
      final quizData = jsonDecode(cleaned);
      final quizzes = (quizData['quiz'] as List)
          .map((q) => QuizModel.fromJson(q))
          .toList();
      return quizzes;
      return quizzes;
    } catch (e) {
      print("❌ Error parsing JSON: $e");
      print("Respons Gemini: $rawText");
      rethrow;
    }
  }

}

