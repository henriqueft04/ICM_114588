class Match {
  final String id;
  final String teamId;
  final String opponent;
  final String date;
  final List<String> startingLineupIds;
  final String formation; // Example: "4-3-3", "3-5-2", etc.

  Match({
    required this.id,
    required this.teamId,
    required this.opponent,
    required this.date,
    required this.startingLineupIds,
    required this.formation,
  });
} 