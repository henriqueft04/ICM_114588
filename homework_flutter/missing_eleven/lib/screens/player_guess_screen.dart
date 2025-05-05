import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
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
  late PlayerProgress progress;
  late String currentGuess;
  late int attempts;
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
    // Read initial progress from the provider
    progress = Provider.of<GameState>(context, listen: false)
      .getProgress(widget.player.name);
    currentGuess = '';
    attempts = widget.attempts; // Initialize with the passed value
    // Initialize letter statuses for all alphabet
    for (var row in keyboardLayout) {
      for (var letter in row) {
        letterStatuses[letter] = LetterStatus.unused;
      }
    }
  }

  void _updateGuess(String letter) {
    // Find where we are in the current guess process
    int currentPos = currentGuess.length;
    String playerName = widget.player.name;
    
    // If we reach a space in the player name, automatically add it
    if (currentPos < playerName.length && playerName[currentPos] == ' ') {
      setState(() {
        currentGuess += ' ' + letter;
      });
    } 
    // If we reach a hyphen in the player name, automatically add it
    else if (currentPos < playerName.length && playerName[currentPos] == '-') {
      setState(() {
        currentGuess += '-' + letter;
      });
    }
    // Otherwise just add the letter
    else {
      setState(() {
        currentGuess += letter;
      });
    }
  }

  void _handleKeyPress(String letter) {
    if (letter == 'ENTER') {
      _checkGuess();
    } else if (letter == 'BACKSPACE') {
      if (currentGuess.isNotEmpty) {
        setState(() {
          currentGuess = currentGuess.substring(0, currentGuess.length - 1);
        });
      }
    } else {
      _updateGuess(letter);
    }
  }

  // Normalize text by removing accents and special characters
  String _normalizeText(String text) {
    // Map of accented characters to their non-accented equivalents
    const Map<String, String> accentMap = {
      'á': 'a', 'à': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a',
      'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
      'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i',
      'ó': 'o', 'ò': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o', 'ø': 'o',
      'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u',
      'ý': 'y', 'ÿ': 'y',
      'ç': 'c', 'ñ': 'n', 'ß': 'ss',
      'Á': 'A', 'À': 'A', 'Â': 'A', 'Ã': 'A', 'Ä': 'A', 'Å': 'A',
      'É': 'E', 'È': 'E', 'Ê': 'E', 'Ë': 'E',
      'Í': 'I', 'Ì': 'I', 'Î': 'I', 'Ï': 'I',
      'Ó': 'O', 'Ò': 'O', 'Ô': 'O', 'Õ': 'O', 'Ö': 'O', 'Ø': 'O',
      'Ú': 'U', 'Ù': 'U', 'Û': 'U', 'Ü': 'U',
      'Ý': 'Y',
      'Ç': 'C', 'Ñ': 'N',
    };

    String normalized = text;
    accentMap.forEach((accented, nonAccented) {
      normalized = normalized.replaceAll(accented, nonAccented);
    });
    
    return normalized;
  }

  void _checkGuess() {
    if (currentGuess.isEmpty) return;
    
    // Store the current guess
    final guess = currentGuess;
    setState(() {
      progress.previousGuesses.add(guess);
      currentGuess = '';
    });
    
    progress.attempts++;
    // Update the progress in the provider
    Provider.of<GameState>(context, listen: false)
      .updateProgress(widget.player.name, progress);
    
    // Normalize and clean both the player name and guess to ignore special characters
    String playerNameClean = _normalizeText(widget.player.name)
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .toLowerCase();
    
    String guessClean = _normalizeText(guess)
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .toLowerCase();
    
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
                Navigator.pop(context, {'correct': true, 'attempts': progress.attempts}); // Return to field with correct result
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    } else if (progress.attempts >= 6) {
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
                Navigator.pop(context, {'correct': false, 'attempts': progress.attempts}); // Return to field
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      appBar: AppBar(
        title: const Text('Missing 11'),
        backgroundColor: colorScheme.secondary,
        actions: [
          FilledButton(
            onPressed: () {
              // Return a Map with 'correct' and 'attempts'
              Navigator.pop(context, {'correct': true, 'attempts': progress.attempts});
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reveal Player*'),
          ),
          const SizedBox(width: 8),
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
                      Card(
                        color: colorScheme.primaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            widget.player.name,
                            style: TextStyle(
                              color: colorScheme.onPrimaryContainer,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      
                    // Show previous guesses
                    if (!revealed && progress.previousGuesses.isNotEmpty)
                      Card(
                        color: colorScheme.surfaceVariant.withOpacity(0.7),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              ...progress.previousGuesses.map((guess) => _buildGuessResult(guess)).toList(),
                            ],
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 16),
                    
                    // Current guess interface
                    if (!revealed)
                      Card(
                        color: colorScheme.surfaceVariant.withOpacity(0.7),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              // Show current guess
                              if (currentGuess.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    currentGuess.toUpperCase(),
                                    style: TextStyle(
                                      color: colorScheme.onSurfaceVariant,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              _buildGuessDisplay(),
                              
                              const SizedBox(height: 20),
                              
                              // Display "Make your first guess" message
                              if (currentGuess.isEmpty && progress.previousGuesses.isEmpty)
                                Text(
                                  'Make your first guess!',
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 18,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          // Build keyboard
          Container(
            padding: const EdgeInsets.only(bottom: 12.0),
            color: Colors.black26,
            child: Column(
              children: [
                for (var row in keyboardLayout)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var key in row)
                          _buildKeyboardKey(key),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Backspace key
                      _buildSpecialKey(
                        Icons.backspace_outlined,
                        () {
                          if (currentGuess.isNotEmpty) {
                            setState(() {
                              // If the last character is a space or hyphen, remove the character before it too
                              if (currentGuess.length > 1 && 
                                  (currentGuess[currentGuess.length - 2] == ' ' || 
                                   currentGuess[currentGuess.length - 2] == '-')) {
                                currentGuess = currentGuess.substring(0, currentGuess.length - 2);
                              } else {
                                currentGuess = currentGuess.substring(0, currentGuess.length - 1);
                              }
                            });
                          }
                        },
                        width: 70,
                      ),
                      // Enter key
                      _buildSpecialKey(
                        null,
                        () {
                          _handleKeyPress('ENTER');
                        },
                        text: 'Enter',
                        width: 120,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
      padding: const EdgeInsets.all(3.0),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(8),
        color: color,
        child: InkWell(
          onTap: () {
            _handleKeyPress(letter);
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 32,
            height: 42,
            alignment: Alignment.center,
            child: Text(
              letter,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialKey(IconData? icon, VoidCallback onPressed, {String? text, double width = 45}) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[700],
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: width,
            height: 42,
            alignment: Alignment.center,
            child: icon != null 
                ? Icon(icon, color: Colors.white, size: 20) 
                : Text(
                    text!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
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
}

enum LetterStatus {
  unused,
  incorrect,
  misplaced,
  correct,
  special,
} 