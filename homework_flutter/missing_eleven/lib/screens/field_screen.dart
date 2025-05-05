import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/player.dart';
import '../models/match.dart';
import '../models/team.dart';
import '../services/game_data.dart';
import 'player_guess_screen.dart';

// Football field widget
class FootballField extends StatelessWidget {
  final List<Widget> children;
  
  const FootballField({
    super.key,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Football field background
        CustomPaint(
          size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
          painter: FootballFieldPainter(),
        ),
        
        // Children positioned on top of the field
        ...children,
      ],
    );
  }
}

class FieldScreen extends StatefulWidget {
  const FieldScreen({super.key});

  @override
  State<FieldScreen> createState() => _FieldScreenState();
}

class _FieldScreenState extends State<FieldScreen> {
  late Match currentMatch;
  late Team currentTeam;
  late List<Player> startingLineup;
  Map<String, int> attemptCounts = {};
  Map<String, bool> correctlyGuessed = {}; // Track correctly guessed players

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    // Get a random match
    currentMatch = GameData.getRandomMatch();
    currentTeam = GameData.getTeamById(currentMatch.teamId);
    
    // Get starting lineup
    startingLineup = GameData.getStartingLineup(currentMatch.id);
    
    // Initialize attempt counts and guessed status
    attemptCounts = {};
    correctlyGuessed = {};
    for (var player in startingLineup) {
      attemptCounts[player.id] = 0;
      correctlyGuessed[player.id] = false;
    }
    
    setState(() {});
  }

  // Format player name as asterisks or show name if correctly guessed
  String getPlayerDisplay(Player player) {
    if (correctlyGuessed[player.id] == true) {
      return player.name;
    } else {
      return getPlayerNameMask(player.name);
    }
  }

  // Format player name as asterisks
  String getPlayerNameMask(String name) {
    String masked = '';
    for (int i = 0; i < name.length; i++) {
      if (name[i] == ' ') {
        masked += ' ';
      } else if (name[i] == '-') {
        masked += '-';
      } else {
        masked += '*';
      }
    }
    return masked;
  }

  void _onPlayerTap(Player player) async {
    // Get the saved progress for this player
    final progress = Provider.of<GameState>(context, listen: false)
      .getProgress(player.name);
      
    // Navigate to the player guess screen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerGuessScreen(
          player: player,
          attempts: progress.attempts,
        ),
      ),
    );

    if (result is Map<String, dynamic>) {
      // Handle detailed result with attempts count
      setState(() {
        if (result['correct'] == true) {
          correctlyGuessed[player.id] = true;
        }
        attemptCounts[player.id] = result['attempts'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.secondary,
        title: const Text(
          'Missing 11',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Match info button
          IconButton(
            onPressed: () {
              // Show match info dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(currentTeam.name),
                  content: Text('vs ${currentMatch.opponent}\n${currentMatch.date}\nFormation: ${currentMatch.formation}'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.info_outline),
            tooltip: 'Match Info',
          ),
        ],
      ),
      // Add a floating action button to start a new game
      floatingActionButton: FloatingActionButton(
        onPressed: _startNewGame,
        tooltip: 'New Game',
        child: const Icon(Icons.refresh),
      ),
      body: FootballField(
        children: _buildFormation(),
      ),
    );
  }
  
  List<Widget> _buildFormation() {
    List<Widget> formationWidgets = [];
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Parse formation string (e.g., "4-3-3" -> [4, 3, 3])
    List<int> formationRows = currentMatch.formation
        .split('-')
        .map((e) => int.parse(e))
        .toList();
    
    // Calculate the maximum players in any row to determine card size
    int maxPlayersInRow = formationRows.reduce((a, b) => a > b ? a : b);
    // Card size should be adaptive to screen width and max players in a row
    double cardSize = (screenWidth * 0.8) / (maxPlayersInRow + 1); 
    cardSize = cardSize.clamp(56.0, 72.0); // Min 56, max 72
    
    // goalkeeper estava torto
    formationWidgets.add(_buildPlayerPosition(
      1, startingLineup[0], 0.5, 0.78, cardSize
    ));
    
    int playerIndex = 1; // Start after goalkeeper
    double verticalSpacing = 0.5 / formationRows.length; // Adjust vertical distribution
    
    // Place players for each row in the formation
    for (int rowIndex = 0; rowIndex < formationRows.length; rowIndex++) {
      int playersInRow = formationRows[rowIndex];
      double verticalPosition = 0.65 - (verticalSpacing * rowIndex);
      
      // Position players horizontally in this row, always using full width
      for (int i = 0; i < playersInRow; i++) {
        double horizontalPosition;
        if (playersInRow == 1) {
          horizontalPosition = 0.5; // Center if only one player
        } else {
          horizontalPosition = 0.1 + (0.8 * i / (playersInRow - 1));
        }
        
        if (playerIndex < startingLineup.length) {
          formationWidgets.add(
            _buildPlayerPosition(
              playerIndex + 1, 
              startingLineup[playerIndex],
              horizontalPosition,
              verticalPosition,
              cardSize,
            ),
          );
          playerIndex++;
        }
      }
    }
    
    return formationWidgets;
  }

  Widget _buildPlayerPosition(int number, Player player, double xPosition, double yPosition, double cardSize) {
    final colorScheme = Theme.of(context).colorScheme;
    // Calculate text size based on card size
    final double fontSize = cardSize * 0.2;
    final bool isGoalkeeper = number == 1;
    
    // Calculate width for name container - make sure to account for it in positioning
    final nameContainerWidth = isGoalkeeper ? cardSize * 1.6 : cardSize * 1.2;
    
    // Get the current attempt count from provider
    final progress = Provider.of<GameState>(context, listen: false).getProgress(player.name);
    final int attempts = progress.attempts;
    final bool hasGuessed = attempts > 0;
    final bool isCorrect = correctlyGuessed[player.id] == true;
    
    return Positioned(
      left: MediaQuery.of(context).size.width * xPosition - (nameContainerWidth > cardSize ? nameContainerWidth / 2 : cardSize / 2),
      top: MediaQuery.of(context).size.height * yPosition - (cardSize / 2),
      child: GestureDetector(
        onTap: () => _onPlayerTap(player),
        child: Column(
          // Ensure column items are centered
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Player card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cardSize / 2),
              ),
              color: isCorrect 
                ? colorScheme.primary 
                : hasGuessed 
                  ? colorScheme.secondary.withOpacity(0.8)
                  : colorScheme.tertiary,
              child: SizedBox(
                width: cardSize,
                height: cardSize,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Show different content based on guess status
                      if (hasGuessed || isCorrect)
                        Text(
                          attempts.toString(),
                          style: TextStyle(
                            fontSize: cardSize * 0.35,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        )
                      else
                        Icon(
                          Icons.question_mark,
                          size: cardSize * 0.35,
                          color: Colors.black87,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Player name info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              width: nameContainerWidth, // Use the stored width
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black54,
              ),
              child: Column(
                children: [
                  Text(
                    getPlayerDisplay(player),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Only show letter counts if not correctly guessed
                  if (!isCorrect)
                    Text(
                      getNameLengthDisplay(player.name),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize * 0.7,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Display name length in format like "5-8" for double-barreled names
  String getNameLengthDisplay(String name) {
    List<String> parts = name.split(RegExp(r'[\s-]+')); 
    List<int> lengths = parts.map((part) => part.length).toList();
    
    if (lengths.length <= 1) {
      // Single name
      return lengths.first.toString();
    } else {
      // Join with hyphens for multi-part names
      return lengths.join('-');
    }
  }
}

// Simple football field painter
class FootballFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Field base
    final fieldPaint = Paint()
      ..color = Colors.green[800]!
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      fieldPaint,
    );
    
    // Add lighter stripes
    final stripePaint = Paint()
      ..color = Colors.green[700]!.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    
    const stripesCount = 10;
    final stripeHeight = size.height / stripesCount;
    
    for (int i = 0; i < stripesCount; i += 2) {
      canvas.drawRect(
        Rect.fromLTWH(0, i * stripeHeight, size.width, stripeHeight),
        stripePaint,
      );
    }
    
    // Line markings
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    // Center circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.15,
      linePaint,
    );
    
    // Center dot
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      4,
      Paint()..color = Colors.white.withOpacity(0.6),
    );
    
    // Center line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      linePaint,
    );
    
    // Field border
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      linePaint,
    );
    
    // Goal areas
    final goalAreaWidth = size.width * 0.6;
    final goalAreaHeight = size.height * 0.15;
    
    // Top goal area
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, goalAreaHeight / 2),
        width: goalAreaWidth,
        height: goalAreaHeight,
      ),
      linePaint,
    );
    
    // Bottom goal area
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height - goalAreaHeight / 2),
        width: goalAreaWidth,
        height: goalAreaHeight,
      ),
      linePaint,
    );
    
    // Goal box - top
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, goalAreaHeight / 4),
        width: goalAreaWidth * 0.4,
        height: goalAreaHeight * 0.5,
      ),
      linePaint,
    );
    
    // Goal box - bottom
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height - goalAreaHeight / 4),
        width: goalAreaWidth * 0.4,
        height: goalAreaHeight * 0.5,
      ),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 