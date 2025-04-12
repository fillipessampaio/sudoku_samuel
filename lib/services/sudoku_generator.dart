import 'dart:math';
import '../providers/game_settings_provider.dart';

class SudokuGenerator {
  final Random _random = Random();

  // Gera um tabuleiro completo (solução) baseado na dificuldade
  List<List<int>> generateFullBoard(Difficulty difficulty) {
    int size =
        difficulty == Difficulty.easy
            ? 4
            : difficulty == Difficulty.medium
            ? 9
            : 16;
    List<List<int>> board = List.generate(size, (_) => List.filled(size, 0));

    bool solve(int row, int col) {
      if (row == size) return true;
      if (col == size) return solve(row + 1, 0);

      List<int> numbers = List.generate(size, (i) => i + 1)..shuffle(_random);
      for (int num in numbers) {
        if (_isValidPlacement(board, row, col, num, size)) {
          board[row][col] = num;
          if (solve(row, col + 1)) return true;
          board[row][col] = 0;
        }
      }

      return false;
    }

    solve(0, 0);
    return board;
  }

  List<List<int>> _copyBoard(List<List<int>> board) {
    return board.map((row) => List<int>.from(row)).toList();
  }

  // Remove números para criar o desafio com base na dificuldade
  Map<String, List<List<int>>> generatePuzzle(Difficulty difficulty) {
    List<List<int>> fullBoard = generateFullBoard(difficulty);
    List<List<int>> puzzle = _copyBoard(fullBoard);

    int size =
        difficulty == Difficulty.easy
            ? 4
            : difficulty == Difficulty.medium
            ? 9
            : 16;
    int emptyCells =
        difficulty == Difficulty.easy
            ? 4
            : difficulty == Difficulty.medium
            ? 30
            : 80; // Para 9x9

    int removed = 0;
    while (removed < emptyCells) {
      int row = _random.nextInt(size);
      int col = _random.nextInt(size);
      if (puzzle[row][col] != 0) {
        puzzle[row][col] = 0;
        removed++;
      }
    }

    return {'puzzle': puzzle, 'solution': fullBoard};
  }

  // Validação de número no tabuleiro
  bool _isValidPlacement(
    List<List<int>> board,
    int row,
    int col,
    int num,
    int size,
  ) {
    // Verifica linha e coluna
    for (int i = 0; i < size; i++) {
      if (board[row][i] == num || board[i][col] == num) return false;
    }

    // Verifica subgrid
    int subgridSize =
        size == 4
            ? 2
            : size == 9
            ? 3
            : 4;
    int startRow = (row ~/ subgridSize) * subgridSize;
    int startCol = (col ~/ subgridSize) * subgridSize;

    for (int i = 0; i < subgridSize; i++) {
      for (int j = 0; j < subgridSize; j++) {
        if (board[startRow + i][startCol + j] == num) return false;
      }
    }

    return true;
  }
}
