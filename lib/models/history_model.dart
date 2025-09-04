import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  final String id;
  final String bookId;
  final String chapterId;
  final int score;
  final DateTime finishedAt;

  HistoryModel({
    required this.id,
    required this.bookId,
    required this.chapterId,
    required this.score,
    required this.finishedAt,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json, String id) {
    return HistoryModel(
      id: id,
      bookId: json['bookId'],
      chapterId: json['chapterId'],
      score: json['score'],
      finishedAt: (json['finishedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "bookId": bookId,
      "chapterId": chapterId,
      "score": score,
      "finishedAt": finishedAt,
    };
  }
}
