// gemini_service.dart
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/quiz_model.dart';

class GeminiService {
  final GenerativeModel model;

  GeminiService() : model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: 'AIzaSyBcfltVrn6xIKW38wWKbqLyU0B13WpE9JE');

  // Future<List<QuizModel>> generateQuiz(String chapterContent) async {
  //   final response = await model.generateContent([
  //     Content.text("""
  //     Buatkan 5 soal pilihan ganda dari teks berikut dalam format JSON,
  //     Format output HARUS JSON valid tanpa tambahan apapun.:
  //     {
  //       "quiz": [
  //         {"question": "...", "options": ["A","B","C","D"], "answer": "A"},
  //         {"question": "....", "options": ["A", "B", "C", "D"], "answer": "C"}
  //       ]
  //     }
  //     Teks: $chapterContent
  //     """)
  //   ]);

    String cleanJson(response) {
      return response
          .replaceAll("```json", "")
          .replaceAll("```", "")
          .trim();
    }

    Future<List<QuizModel>> generateQuiz(String material) async {
      final prompt = """
  Buatkan 3 soal pilihan ganda tentang materi ini: $material.
  Format output HARUS JSON valid tanpa tambahan apapun.
  """;

      final response = await model.generateContent([Content.text(prompt)]);
      final rawText = response.text ?? '';  // 👉 ambil teks dari response

      try {
        final cleaned = cleanJson(rawText);
        final List<dynamic> jsonList = jsonDecode(cleaned);

        return jsonList.map((e) => QuizModel.fromJson(e)).toList();
      } catch (e) {
        print("❌ Error parsing JSON: $e");
        print("Respons Gemini: $rawText"); // biar keliatan isi aslinya
        rethrow;
      }

    final quizData = jsonDecode(response.text ?? "{}");
    final quizzes = (quizData['quiz'] as List).map((q) => QuizModel.fromJson(q)).toList();
    return quizzes;
  }
}

// import 'dart:convert';

// import 'package:aksara/models/quiz_model.dart';
// // import 'package:aksara/utils/json_cleaner.dart'; // kalau kamu pisahkan helper
//
// class GeminiService {
//   Future<List<QuizModel>> generateQuiz(String material) async {
//     final prompt = """
//     Buatkan 3 soal pilihan ganda tentang materi ini: $material.
//     Format output HARUS JSON valid tanpa tambahan apapun.
//     Contoh:
//     [
//       {"question": "Apa itu ...?", "options": ["A", "B", "C", "D"], "answer": "A"},
//       {"question": "....", "options": ["A", "B", "C", "D"], "answer": "C"}
//     ]
//     """;
//
//     // 👉 di sini kamu panggil API Gemini (aku contohkan dummy dulu)
//     final rawResponse = await fakeGeminiApiCall(prompt);
//
//     String cleanJson(String response) {
//       return response
//           .replaceAll("```json", "")
//           .replaceAll("```", "")
//           .trim();
//     }
//
//     try {
//       final cleaned = cleanJson(rawResponse);
//       final List<dynamic> jsonList = jsonDecode(cleaned);
//
//       return jsonList.map((e) => QuizModel.fromJson(e)).toList();
//     } catch (e) {
//       print("❌ Error parsing JSON: $e");
//       print("Respons Gemini: $rawResponse");
//       rethrow;
//     }
//   }
//
//   /// Dummy buat simulasi (ganti dengan API asli)
//   Future<String> fakeGeminiApiCall(String prompt) async {
//     return """
//     [
//       {"question": "Apa ibu kota Indonesia?", "options": ["Jakarta", "Bandung", "Surabaya", "Medan"], "answer": "Jakarta"},
//       {"question": "2 + 2 = ?", "options": ["3", "4", "5", "6"], "answer": "4"},
//       {"question": "Simbol H2O menunjukkan?", "options": ["Air", "Oksigen", "Hidrogen", "Karbon"], "answer": "Air"}
//     ]
//     """;
//   }
// }


// gemini_service.dart
// import 'dart:convert';
// import 'package:firebase_vertexai/firebase_vertexai.dart'; // 1. Ganti import paket
// import '../models/quiz_model.dart';
//
// class GeminiService {
//   // 2. Inisialisasi model langsung dari FirebaseVertexAI
//   final GenerativeModel model;
//
//   // 3. Constructor tidak lagi memerlukan apiKey
//   GeminiService()
//       : model = FirebaseVertexAI.instance.generativeModel(
//     model: 'gemini-2.5-flash', // Gunakan model yang tersedia di Firebase
//     // Anda bisa menambahkan generationConfig di sini jika perlu
//     // generationConfig: GenerationConfig(temperature: 0.9),
//   );
//
//   Future<List<QuizModel>> generateQuiz(String chapterContent) async {
//     // Logika untuk generate konten tetap sama
//     final response = await model.generateContent([
//       Content.text("""
//       Buatkan 5 soal pilihan ganda dari teks berikut dalam format JSON yang ketat. Pastikan JSON valid.
//       {
//         "quiz": [
//           {"question": "...", "options": ["A","B","C","D"], "answer": "A"}
//         ]
//       }
//       Teks: $chapterContent
//       """)
//     ]);
//
//     // Ambil teks dan bersihkan dari markdown block jika ada
//     final responseText = response.text ?? '{}';
//     final cleanedJson = responseText.replaceAll("```json", "").replaceAll("```", "").trim();
//
//     // Logika parsing JSON tetap sama
//     final quizData = jsonDecode(cleanedJson);
//     final quizzes = (quizData['quiz'] as List).map((q) => QuizModel.fromJson(q)).toList();
//     return quizzes;
//   }
// }
