class Team {
  final String id;
  final String name;
  final String logoUrl;
  final List<String> playerIds; // IDs of players in the starting eleven

  Team({
    required this.id,
    required this.name,
    required this.playerIds,
    this.logoUrl = '',
  });
} 