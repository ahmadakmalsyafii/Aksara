class UserStats {
  final int points;
  final int streak;
  final DateTime? lastReadDate; 

  UserStats({
    required this.points,
    required this.streak,
    required this.lastReadDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'points': points,
      'streak': streak,
      'lastReadDate': lastReadDate?.toIso8601String(),
    };
  }

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      points: (json['points'] ?? 0) as int,
      streak: (json['streak'] ?? 0) as int,
      lastReadDate: json['lastReadDate'] != null
          ? DateTime.tryParse(json['lastReadDate'])?.toUtc()
          : null,
    );
  }
}
