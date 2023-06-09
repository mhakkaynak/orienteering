class PlayerStats {
  final String userId;
  final int score;
  final int secondsPassed;

  PlayerStats({required this.userId, required this.score, required this.secondsPassed});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'score': score,
      'secondsPassed': secondsPassed,
    };
  }

  static PlayerStats fromMap(Map<String, dynamic> map) {
    return PlayerStats(
      userId: map['userId'],
      score: map['score'],
      secondsPassed: map['secondsPassed'],
    );
  }
}
