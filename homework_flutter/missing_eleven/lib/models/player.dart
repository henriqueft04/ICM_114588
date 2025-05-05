class Player {
  final String id;
  final String name;
  final String position;
  final String imageUrl;

  Player({
    required this.id,
    required this.name,
    required this.position,
    this.imageUrl = '',
  });
} 