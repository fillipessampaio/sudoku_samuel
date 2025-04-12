import 'package:flutter_riverpod/flutter_riverpod.dart';

enum GameMode { numbers, emojis }

enum Difficulty { easy, medium, hard }

class GameSettings {
  final GameMode mode;
  final Difficulty difficulty;

  GameSettings({required this.mode, required this.difficulty});

  GameSettings copyWith({GameMode? mode, Difficulty? difficulty}) {
    return GameSettings(
      mode: mode ?? this.mode,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}

class GameSettingsNotifier extends StateNotifier<GameSettings> {
  GameSettingsNotifier()
    : super(GameSettings(mode: GameMode.numbers, difficulty: Difficulty.easy));

  void setMode(GameMode mode) {
    state = state.copyWith(mode: mode);
  }

  void setDifficulty(Difficulty difficulty) {
    state = state.copyWith(difficulty: difficulty);
  }
}

final gameSettingsProvider =
    StateNotifierProvider<GameSettingsNotifier, GameSettings>((ref) {
      return GameSettingsNotifier();
    });
