class GameResults {
  final String? id;
  final String? teamId;
  final String? competitionId;
  Map<int, int>? endScores;
  bool? firstHammer;
  String? total;

  GameResults({
    required this.id,
    required this.teamId,
    required this.competitionId,
  });
}
