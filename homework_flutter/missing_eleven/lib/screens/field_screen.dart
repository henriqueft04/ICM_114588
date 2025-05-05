import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/match.dart';
import '../models/team.dart';
import '../services/game_data.dart';
import 'player_guess_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green[700]!,
              Colors.green[900]!,
            ],
          ),
        ),
        child: Column(
          children: [
            // Header with game info
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.indigo[900],
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
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
                      child: const Text(
                        'Match Info',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const Text(
                      'Missing 11',
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 20, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Field with players
            Expanded(
              child: Stack(
                children: [
                  // Field markings (simplified)
                  CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
                    painter: FootballFieldPainter(),
                  ),
                  
                  // Calendar button
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.calendar_today),
                    ),
                  ),
                  
                  // Display formation with dynamic positioning
                  ..._buildFormation(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  List<Widget> _buildFormation() {
    List<Widget> formationWidgets = [];
    
    // Always position goalkeeper at the bottom center - adjust to keep visible
    formationWidgets.add(_buildPlayerPosition(1, startingLineup[0], 0.5, 0.85));
    
    // Parse formation string (e.g., "4-3-3" -> [4, 3, 3])
    List<int> formationRows = currentMatch.formation
        .split('-')
        .map((e) => int.parse(e))
        .toList();
    
    int playerIndex = 1; // Start after goalkeeper
    double verticalSpacing = 0.6 / formationRows.length; // Adjust vertical distribution
    
    // Place players for each row in the formation
    for (int rowIndex = 0; rowIndex < formationRows.length; rowIndex++) {
      int playersInRow = formationRows[rowIndex];
      double verticalPosition = 0.7 - (verticalSpacing * rowIndex);
      
      // Position players horizontally in this row
      for (int i = 0; i < playersInRow; i++) {
        double horizontalPosition;
        if (playersInRow == 1) {
          horizontalPosition = 0.5; // Center if only one player
        } else {
          // Distribute players evenly across the width
          horizontalPosition = 0.2 + (0.6 * i / (playersInRow - 1));
        }
        
        if (playerIndex < startingLineup.length) {
          formationWidgets.add(
            _buildPlayerPosition(
              playerIndex + 1, // +1 because jersey numbers typically start from 2 for defenders
              startingLineup[playerIndex],
              horizontalPosition,
              verticalPosition,
            ),
          );
          playerIndex++;
        }
      }
    }
    
    return formationWidgets;
  }

  Widget _buildPlayerPosition(int number, Player player, double xPosition, double yPosition) {
    return Positioned(
      left: MediaQuery.of(context).size.width * xPosition - 30,
      top: MediaQuery.of(context).size.height * yPosition - 30,
      child: GestureDetector(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayerGuessScreen(
                player: player,
                attempts: attemptCounts[player.id] ?? 0,
              ),
            ),
          );
          
          if (result == true) {
            setState(() {
              attemptCounts[player.id] = (attemptCounts[player.id] ?? 0) + 1;
            });
          } else if (result == 'correct') {
            setState(() {
              correctlyGuessed[player.id] = true;
            });
          }
        },
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: correctlyGuessed[player.id] == true ? Colors.green[400] : Colors.blue[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      correctlyGuessed[player.id] == true ? '✓' : '?',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              getPlayerDisplay(player),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              getNameLengthDisplay(player.name),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Display name length in format like "5-8" for double-barreled names
  String getNameLengthDisplay(String name) {
    // If the player has already been guessed, just show the guess count
    if (correctlyGuessed[startingLineup.firstWhere((p) => p.name == name).id] == true) {
      return '${attemptCounts[startingLineup.firstWhere((p) => p.name == name).id] ?? 0}';
    }
    
    List<String> parts = name.split(RegExp(r'[\s-]+')); // Split by spaces or hyphens
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
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    // Center circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.15,
      paint,
    );
    
    // Center line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
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
      paint,
    );
    
    // Bottom goal area
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height - goalAreaHeight / 2),
        width: goalAreaWidth,
        height: goalAreaHeight,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 