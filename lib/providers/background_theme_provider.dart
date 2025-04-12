import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BackgroundTheme { mario, lego, balls }

class BackgroundThemeNotifier extends StateNotifier<BackgroundTheme> {
  BackgroundThemeNotifier() : super(BackgroundTheme.mario);

  void toggleTheme() {
    state =
        BackgroundTheme.values[(state.index + 1) %
            BackgroundTheme.values.length];
  }
}

final backgroundThemeProvider =
    StateNotifierProvider<BackgroundThemeNotifier, BackgroundTheme>((ref) {
      return BackgroundThemeNotifier();
    });
