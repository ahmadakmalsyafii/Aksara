class ReadingProgress {
  final String chapterId;
  final int lastPage;
  final DateTime updatedAt;

  ReadingProgress({
    required this.chapterId,
    required this.lastPage,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "chapterId": chapterId,
      "lastPage": lastPage,
      "updatedAt": updatedAt.toIso8601String(),
    };
  }

  factory ReadingProgress.fromJson(Map<String, dynamic> json) {
    return ReadingProgress(
      chapterId: json["chapterId"],
      lastPage: json["lastPage"] ?? 0,
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
    );
  }
}
