import 'package:flutter/material.dart';
import '../models/player.dart';

class PlayerGuessScreen extends StatefulWidget {
  final Player player;
  final int attempts;

  const PlayerGuessScreen({
    super.key,
    required this.player,
    required this.attempts,
  });

  @override
  State<PlayerGuessScreen> createState() => _PlayerGuessScreenState();
}

class _PlayerGuessScreenState extends State<PlayerGuessScreen> {
  String currentGuess = '';
  bool revealed = false;
  List<String> previousGuesses = [];
  
  // Simple keyboard layout
  final List<List<String>> keyboardLayout = [
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
  ];
  
  // Map to track letter statuses (for keyboard coloring)
  Map<String, LetterStatus> letterStatuses = {};

  @override
  void initState() {
    super.initState();
    // Initialize letter statuses for all alphabet
    for (var row in keyboardLayout) {
      for (var letter in row) {
        letterStatuses[letter] = LetterStatus.unused;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E), // Dark purple background
      appBar: AppBar(
        title: const Text('Missing 11'),
        backgroundColor: const Color(0xFF1E1E2E),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                revealed = true;
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
            ),
            child: const Text('Reveal Player*'),
          ),
        ],
      ),
      body: Column(
        children: [
          // "You may see a quick ad" disclaimer
          if (revealed)
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text(
                '*You may see a quick ad',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ),
            
          const SizedBox(height: 10),
          
          // Player info and guess display
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Display the revealed player
                    if (revealed)
                      Text(
                        widget.player.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                    // Show previous guesses
                    if (!revealed && previousGuesses.isNotEmpty)
                      Column(
                        children: [
                          ...previousGuesses.map((guess) => _buildGuessResult(guess)).toList(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    
                    // Current guess interface
                    if (!revealed)
                      Column(
                        children: [
                          // Show current guess
                          if (currentGuess.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text(
                                currentGuess.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          _buildGuessDisplay(),
                        ],
                      ),
                    
                    const SizedBox(height: 20),
                    
                    // Display "Make your first guess" message
                    if (!revealed && currentGuess.isEmpty && previousGuesses.isEmpty)
                      const Text(
                        'Make your first guess!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          // Build keyboard
          Column(
            children: [
              for (var row in keyboardLayout)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var key in row)
                      _buildKeyboardKey(key),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Backspace key
                  _buildSpecialKey(
                    Icons.backspace_outlined,
                    () {
                      if (currentGuess.isNotEmpty) {
                        setState(() {
                          currentGuess = currentGuess.substring(0, currentGuess.length - 1);
                        });
                      }
                    },
                  ),
                  // Space key
                  _buildSpecialKey(
                    null,
                    () {
                      setState(() {
                        currentGuess += ' ';
                      });
                    },
                    text: 'Space',
                    width: 100,
                  ),
                  // Enter key
                  _buildSpecialKey(
                    null,
                    () {
                      _checkGuess();
                    },
                    text: 'Enter',
                    width: 100,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildGuessDisplay() {
    // Create circles for each character in player name
    List<Widget> letterWidgets = [];
    
    String playerName = widget.player.name;
    
    for (int i = 0; i < playerName.length; i++) {
      if (playerName[i] == ' ') {
        // Add space between name parts
        letterWidgets.add(const SizedBox(width: 10));
        continue;
      }
      
      if (playerName[i] == '-') {
        // Show hyphen
        letterWidgets.add(
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: const Text(
              '-',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        continue;
      }
      
      // Normal letter circle
      final bool hasLetter = i < currentGuess.length;
      
      letterWidgets.add(
        Container(
          width: 30,
          height: 30,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hasLetter ? const Color.fromARGB(255, 63, 139, 184) : Colors.transparent,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: hasLetter 
                ? Text(
                    currentGuess[i].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
        ),
      );
    }
    
    return Wrap(
      alignment: WrapAlignment.center,
      children: letterWidgets,
    );
  }

  Widget _buildGuessResult(String guess) {
    List<Widget> letterWidgets = [];
    
    String playerName = widget.player.name.toLowerCase();
    String processedGuess = guess;
    
    // Make sure the guess and player name are aligned for comparison
    // by inserting spaces and hyphens in the same positions
    for (int i = 0; i < playerName.length; i++) {
      if (i >= processedGuess.length) {
        processedGuess += ' '; // Pad with spaces if guess is shorter
      }
      
      // Insert hyphens and spaces in the same positions as in the player name
      if ((playerName[i] == ' ' || playerName[i] == '-') && 
          i < processedGuess.length && 
          processedGuess[i] != playerName[i]) {
        processedGuess = processedGuess.substring(0, i) + 
                        playerName[i] + 
                        processedGuess.substring(i);
      }
    }
    
    // Trim processedGuess to the same length as playerName
    if (processedGuess.length > playerName.length) {
      processedGuess = processedGuess.substring(0, playerName.length);
    }
    
    Map<String, int> letterCounts = {};
    
    // Count occurrences of each letter in the player's name (excluding spaces and hyphens)
    for (int i = 0; i < playerName.length; i++) {
      if (playerName[i] != ' ' && playerName[i] != '-') {
        letterCounts[playerName[i]] = (letterCounts[playerName[i]] ?? 0) + 1;
      }
    }
    
    // First pass: Check for exact matches and reduce letter counts
    List<LetterStatus> statuses = List.filled(processedGuess.length, LetterStatus.incorrect);
    for (int i = 0; i < processedGuess.length; i++) {
      if (playerName[i] == ' ' || playerName[i] == '-') {
        statuses[i] = LetterStatus.special; // Special status for spaces and hyphens
      } else if (processedGuess[i].toLowerCase() == playerName[i]) {
        statuses[i] = LetterStatus.correct;
        letterCounts[playerName[i]] = (letterCounts[playerName[i]] ?? 0) - 1;
      }
    }
    
    // Second pass: Check for misplaced letters
    for (int i = 0; i < processedGuess.length; i++) {
      if (statuses[i] == LetterStatus.incorrect && 
          processedGuess[i] != ' ' && 
          processedGuess[i] != '-') {
        final letter = processedGuess[i].toLowerCase();
        if (playerName.contains(letter) && (letterCounts[letter] ?? 0) > 0) {
          statuses[i] = LetterStatus.misplaced;
          letterCounts[letter] = (letterCounts[letter] ?? 0) - 1;
        }
      }
    }
    
    // Create letter tiles with appropriate colors
    for (int i = 0; i < processedGuess.length; i++) {
      if (playerName[i] == ' ') {
        letterWidgets.add(const SizedBox(width: 10));
        continue;
      }
      
      if (playerName[i] == '-') {
        letterWidgets.add(
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: const Text(
              '-',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        continue;
      }
      
      final color = _getColorForStatus(statuses[i]);
      
      // Update keyboard letter status if this is better than existing
      if (processedGuess[i].isNotEmpty && 
          processedGuess[i] != ' ' && 
          processedGuess[i] != '-' &&
          _isHigherStatus(statuses[i], letterStatuses[processedGuess[i].toUpperCase()] ?? LetterStatus.unused)) {
        letterStatuses[processedGuess[i].toUpperCase()] = statuses[i];
      }
      
      letterWidgets.add(
        Container(
          width: 30,
          height: 30,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              (i < processedGuess.length) ? processedGuess[i].toUpperCase() : '',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: letterWidgets,
      ),
    );
  }

  Widget _buildKeyboardKey(String letter) {
    final status = letterStatuses[letter] ?? LetterStatus.unused;
    final color = _getColorForKeyboard(status);
    
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            currentGuess += letter;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(35, 45),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          letter,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialKey(IconData? icon, VoidCallback onPressed, {String? text, double width = 50}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[700],
          minimumSize: Size(width, 45),
          padding: EdgeInsets.zero,
        ),
        child: icon != null 
            ? Icon(icon, color: Colors.white) 
            : Text(
                text!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Color _getColorForStatus(LetterStatus status) {
    switch (status) {
      case LetterStatus.correct:
        return Colors.green;
      case LetterStatus.misplaced:
        return Colors.orange;
      case LetterStatus.special:
        return Colors.transparent;
      case LetterStatus.incorrect:
        return Colors.grey[700]!;
      case LetterStatus.unused:
        return Colors.grey[400]!;
    }
  }

  Color _getColorForKeyboard(LetterStatus status) {
    switch (status) {
      case LetterStatus.correct:
        return Colors.green;
      case LetterStatus.misplaced:
        return Colors.orange;
      case LetterStatus.special:
        return Colors.transparent;
      case LetterStatus.incorrect:
        return Colors.grey[700]!;
      case LetterStatus.unused:
        return Colors.grey[400]!;
    }
  }

  bool _isHigherStatus(LetterStatus newStatus, LetterStatus oldStatus) {
    final order = {
      LetterStatus.unused: 0,
      LetterStatus.incorrect: 1,
      LetterStatus.misplaced: 2,
      LetterStatus.correct: 3,
    };
    return (order[newStatus] ?? 0) > (order[oldStatus] ?? 0);
  }

  void _checkGuess() {
    if (currentGuess.isEmpty) return;
    
    // Store the current guess
    final guess = currentGuess;
    setState(() {
      previousGuesses.add(guess);
      currentGuess = '';
    });
    
    // Check if guess is correct - ignoring spaces and hyphens
    String playerNameClean = widget.player.name.replaceAll(' ', '').replaceAll('-', '').toLowerCase();
    String guessClean = guess.replaceAll(' ', '').replaceAll('-', '').toLowerCase();
    
    if (guessClean == playerNameClean) {
      // Correct guess
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Correct!'),
          content: Text('You guessed ${widget.player.name} correctly!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context, 'correct'); // Return to field with correct result
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    } else if (previousGuesses.length >= 6) {
      // Maximum attempts reached
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Out of Attempts'),
          content: Text('The correct player was: ${widget.player.name}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context, true); // Return to field
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    }
  }
}

enum LetterStatus {
  unused,
  incorrect,
  misplaced,
  correct,
  special,
} 