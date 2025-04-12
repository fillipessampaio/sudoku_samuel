import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/choice_chips.dart';
import '../widgets/white_container.dart';
import '../providers/game_settings_provider.dart';
import '../providers/background_theme_provider.dart';
import 'game_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getBackgroundImage(BackgroundTheme theme) {
    switch (theme) {
      case BackgroundTheme.mario:
        return 'assets/images/cenario_super_mario_background.png';
      case BackgroundTheme.lego:
        return 'assets/images/lego_background.jpeg';
      case BackgroundTheme.balls:
        return 'assets/images/balls_background.jpeg';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameSettings = ref.watch(gameSettingsProvider);
    final backgroundTheme = ref.watch(backgroundThemeProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              _getBackgroundImage(backgroundTheme),
              fit: BoxFit.cover,
            ),
          ),
          // Theme Toggle Button
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.palette, color: Colors.teal),
                onPressed: () {
                  ref.read(backgroundThemeProvider.notifier).toggleTheme();
                },
                tooltip: 'Change Theme',
              ),
            ),
          ),
          // Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title Container
                    const Text(
                      "SAM-DOKU",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                        fontFamily: 'Brastika',
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Difficulty Container
                    WhiteContainer(
                      child: Column(
                        children: [
                          const Text(
                            "Choose your difficulty:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomChoiceChips(
                            options: ['Easy', 'Medium', 'Hard'],
                            onSelected: (option) {
                              final difficulty = Difficulty.values.firstWhere(
                                (d) =>
                                    d
                                        .toString()
                                        .split('.')
                                        .last
                                        .toLowerCase() ==
                                    option.toLowerCase(),
                              );
                              ref
                                  .read(gameSettingsProvider.notifier)
                                  .setDifficulty(difficulty);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Mode Container
                    WhiteContainer(
                      child: Column(
                        children: [
                          const Text(
                            "Choose your mode:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomChoiceChips(
                            options: ['Numbers', 'Emojis'],
                            onSelected: (option) {
                              final mode =
                                  option == 'Numbers'
                                      ? GameMode.numbers
                                      : GameMode.emojis;
                              ref
                                  .read(gameSettingsProvider.notifier)
                                  .setMode(mode);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Play Button
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GameScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Play",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
