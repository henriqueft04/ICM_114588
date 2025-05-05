import 'package:flutter/material.dart';
import '../models/match.dart';
import '../models/player.dart';
import '../models/team.dart';
import '../services/game_data.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Match currentMatch;
  late Team currentTeam;
  List<Player> selectedPlayers = [];
  List<Player> availablePlayers = [];
  bool gameCompleted = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    // Get a random match
    currentMatch = GameData.getRandomMatch();
    currentTeam = GameData.getTeamById(currentMatch.teamId);
    
    // Reset selections
    selectedPlayers = [];
    
    // Get all players from the team
    availablePlayers = GameData.getPlayersForTeam(currentTeam.id);
    
    // Shuffle the players for selection
    availablePlayers.shuffle();
    
    setState(() {
      gameCompleted = false;
    });
  }

  void _selectPlayer(Player player) {
    if (selectedPlayers.length < 11 && !selectedPlayers.contains(player)) {
      setState(() {
        selectedPlayers.add(player);
        availablePlayers.remove(player);
        
        // Check if game is completed (all 11 players selected)
        if (selectedPlayers.length == 11) {
          _checkAnswers();
        }
      });
    }
  }

  void _removePlayer(Player player) {
    setState(() {
      selectedPlayers.remove(player);
      availablePlayers.add(player);
    });
  }

  void _checkAnswers() {
    final correctLineup = GameData.getStartingLineup(currentMatch.id);
    int correctCount = 0;

    for (var player in selectedPlayers) {
      if (correctLineup.contains(player)) {
        correctCount++;
      }
    }

    setState(() {
      score = correctCount;
      gameCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Missing Eleven'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Game info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      currentTeam.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Match vs ${currentMatch.opponent} (${currentMatch.date})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select all 11 starting players:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Selected players section
            Text(
              'Selected Players (${selectedPlayers.length}/11):',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Expanded(
              flex: 3,
              child: Card(
                child: ListView.builder(
                  itemCount: selectedPlayers.length,
                  itemBuilder: (context, index) {
                    final player = selectedPlayers[index];
                    return ListTile(
                      title: Text(player.name),
                      subtitle: Text(player.position),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => _removePlayer(player),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Results section (visible when game is completed)
            if (gameCompleted)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    Text(
                      'Score: $score/11',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _startNewGame(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: const Text('Start New Game'),
                    ),
                  ],
                ),
              ),
            
            // Available players section
            Text(
              'Available Players:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Expanded(
              flex: 3,
              child: Card(
                child: ListView.builder(
                  itemCount: availablePlayers.length,
                  itemBuilder: (context, index) {
                    final player = availablePlayers[index];
                    return ListTile(
                      title: Text(player.name),
                      subtitle: Text(player.position),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: selectedPlayers.length < 11 
                            ? () => _selectPlayer(player) 
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 