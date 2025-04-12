import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/sudoku_generator.dart';
import '../providers/game_settings_provider.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late List<List<int>> puzzle;
  late List<List<int>> solution;
  late List<List<bool>> fixed;

  final generator = SudokuGenerator();
  int selectedValue = 1;

  @override
  void initState() {
    super.initState();
    generateBoard();
  }

  void generateBoard() {
    final gameSettings = ref.read(gameSettingsProvider);
    final result = generator.generatePuzzle(gameSettings.difficulty);
    puzzle = result['puzzle']!;
    solution = result['solution']!;

    int size =
        gameSettings.difficulty == Difficulty.easy
            ? 4
            : gameSettings.difficulty == Difficulty.medium
            ? 9
            : 16;
    fixed = List.generate(
      size,
      (i) => List.generate(size, (j) => puzzle[i][j] != 0),
    );
  }

  void updateCell(int row, int col, int value) {
    if (!fixed[row][col]) {
      setState(() {
        puzzle[row][col] = value;
      });

      if (isBoardCompleteAndCorrect()) {
        Future.delayed(const Duration(milliseconds: 300), () {
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: const Text(
                    "Congratulations!",
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Text(
                    "You completed this Sudoku!",
                    style: TextStyle(color: Colors.teal),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() => generateBoard());
                      },
                      child: const Text("New game"),
                    ),
                  ],
                ),
          );
        });
      }
    }
  }

  bool isCorrect(int row, int col) {
    return puzzle[row][col] == 0 || puzzle[row][col] == solution[row][col];
  }

  bool isBoardCompleteAndCorrect() {
    final gameSettings = ref.read(gameSettingsProvider);
    int size =
        gameSettings.difficulty == Difficulty.easy
            ? 4
            : gameSettings.difficulty == Difficulty.medium
            ? 9
            : 16;
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (puzzle[i][j] != solution[i][j]) return false;
      }
    }
    return true;
  }

  Widget buildCell(int row, int col) {
    final gameSettings = ref.watch(gameSettingsProvider);
    bool isFixed = fixed[row][col];
    int value = puzzle[row][col];

    String display =
        gameSettings.mode == GameMode.numbers
            ? (value != 0 ? value.toString() : '')
            : emojiMap[value] ?? '';

    Color backgroundColor = Colors.white;
    if (isFixed) {
      backgroundColor = Colors.grey.shade300;
    } else if (value != 0 && value != solution[row][col]) {
      backgroundColor = Colors.red.shade100; // errado
    } else if (value != 0 && value == solution[row][col]) {
      backgroundColor = Colors.green.shade100; // certo
    }

    return GestureDetector(
      onTap: () {
        if (!isFixed) {
          updateCell(row, col, selectedValue);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          display,
          style: TextStyle(
            fontSize: gameSettings.difficulty == Difficulty.hard ? 14 : 20,
            fontWeight: FontWeight.bold,
            color: isFixed ? Colors.black : Colors.teal,
          ),
        ),
      ),
    );
  }

  Widget buildBoard() {
    final gameSettings = ref.watch(gameSettingsProvider);
    int size =
        gameSettings.difficulty == Difficulty.easy
            ? 4
            : gameSettings.difficulty == Difficulty.medium
            ? 9
            : 16;
    int subgridSize =
        gameSettings.difficulty == Difficulty.easy
            ? 2
            : gameSettings.difficulty == Difficulty.medium
            ? 3
            : 4;

    return Container(
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: size,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          childAspectRatio: 1.0,
        ),
        itemCount: size * size,
        itemBuilder: (context, index) {
          int row = index ~/ size;
          int col = index % size;

          // Determine if this cell is on a quadrant border
          bool isRightBorder = (col + 1) % subgridSize == 0 || col == size - 1;
          bool isBottomBorder = (row + 1) % subgridSize == 0 || row == size - 1;

          return Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: isRightBorder ? Colors.black : Colors.black26,
                  width: isRightBorder ? 2 : 1,
                ),
                bottom: BorderSide(
                  color: isBottomBorder ? Colors.black : Colors.black26,
                  width: isBottomBorder ? 2 : 1,
                ),
                left: BorderSide(
                  color: col % subgridSize == 0 ? Colors.black : Colors.black26,
                  width: col % subgridSize == 0 ? 2 : 1,
                ),
                top: BorderSide(
                  color: row % subgridSize == 0 ? Colors.black : Colors.black26,
                  width: row % subgridSize == 0 ? 2 : 1,
                ),
              ),
            ),
            child: buildCell(row, col),
          );
        },
      ),
    );
  }

  Widget buildSelector() {
    final gameSettings = ref.watch(gameSettingsProvider);
    List<Widget> options = [];
    int size =
        gameSettings.difficulty == Difficulty.easy
            ? 4
            : gameSettings.difficulty == Difficulty.medium
            ? 9
            : 16;

    for (int i = 1; i <= size; i++) {
      String label =
          gameSettings.mode == GameMode.numbers ? i.toString() : emojiMap[i]!;
      options.add(
        GestureDetector(
          onTap: () {
            setState(() => selectedValue = i);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selectedValue == i ? Colors.teal : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: gameSettings.difficulty == Difficulty.hard ? 14 : 20,
                color: selectedValue == i ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options,
      alignment: WrapAlignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameSettings = ref.watch(gameSettingsProvider);

    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: const Text("SAM-DOKU"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => setState(() => generateBoard()),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              "Mode: ${gameSettings.mode == GameMode.numbers ? 'numbers' : 'emojis'} | Difficulty: ${gameSettings.difficulty.toString().split('.').last}",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.teal),
            ),
            const SizedBox(height: 20),
            buildBoard(),
            const SizedBox(height: 20),
            buildSelector(),
          ],
        ),
      ),
    );
  }
}

Map<int, String> emojiMap = {
  1: '🐶', // dog
  2: '🎈', // balloon
  3: '🧸', // teddy bear
  4: '🚗', // car
  5: '🌟', // star
  6: '🎮', // game controller
  7: '🎪', // circus tent
  8: '🎨', // art palette
  9: '🎭', // theater masks
  10: '🎸', // guitar
  11: '🎪', // circus tent -> 🦁 lion
  12: '🎯', // target
  13: '🎲', // dice
  14: '🎳', // bowling
  15: '🎪', // circus tent -> 🎠 carousel
  16: '🎭', // theater masks -> 🎪 circus tent
};
