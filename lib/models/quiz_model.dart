class QuizModel {
  final String question;
  final List<String> options;
  final int answerIndex;


  QuizModel({
    required this.question,
    required this.options,
    required this.answerIndex,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    int index;
    if (json['answer'] is String) {
      final answer = json['answer'] as String;
      if (['A', 'B', 'C', 'D'].contains(answer.toUpperCase())) {
        index = answer.toUpperCase().codeUnitAt(0) - 'A'.codeUnitAt(0);
      } else {
        // fallback: kalau ternyata sudah berupa teks
        index = (json['options'] as List).indexOf(answer);
      }
    } else {
      index = json['answer'] as int;
    }

    return QuizModel(
      question: json['question'] ?? '',
      options: List<String>.from(json['options']),
      answerIndex: index,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "question": question,
      "options": options,
      "answerIndex": answerIndex,
    };
  }
}
