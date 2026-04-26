import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import 'category_screen.dart';
import 'reveal_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _impostersRevealed = false;

  void _newGameSameSettings() {
    final provider = context.read<GameProvider>();
    bool started = provider.startGame();
    if (started) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const CategoryScreen()),
        (route) => false,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const GameScreenRouteController()),
      );
    }
  }

  void _restartCompletely() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const CategoryScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final startPlayer = provider.startPlayer;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppTheme.darkBackground,
                  title: const Text('End Game?'),
                  content: const Text('Return to category selection?'),
                  actions: [
                    TextButton(
                      child: const Text('CANCEL', style: TextStyle(color: Colors.white)),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                    TextButton(
                      child: const Text('YES', style: TextStyle(color: AppTheme.accentLimeGreen)),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _restartCompletely();
                      },
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Spacer(),
            if (!_impostersRevealed) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                decoration: BoxDecoration(
                  color: AppTheme.accentLimeGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  startPlayer?.name ?? 'Someone',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppTheme.darkText,
                    fontSize: 40,
                  ),
                ),
              ).animate().scale(duration: const Duration(seconds: 1), curve: Curves.elasticOut),
              const SizedBox(height: 20),
              Text(
                'starts the conversation!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 60),
              const Spacer(),
              
              GestureDetector(
                onLongPress: () {
                  setState(() => _impostersRevealed = true);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'HOLD TO REVEAL IMPOSTER',
                    style: TextStyle(
                      color: AppTheme.darkText,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ).animate().shimmer(delay: const Duration(seconds: 2)),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _newGameSameSettings,
                child: const Text('New Game', style: TextStyle(color: Colors.white54, fontSize: 18)),
              ),
            ] else ...[
              const Text(
                'The Imposters were:',
                style: TextStyle(fontSize: 24, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              ...provider.players.where((p) => p.isImposter).map((p) => 
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    p.name,
                    style: const TextStyle(fontSize: 36, color: AppTheme.accentLimeGreen, fontWeight: FontWeight.bold),
                  ),
                )
              ).toList(),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text('The word was:', style: TextStyle(color: AppTheme.darkText)),
                    const SizedBox(height: 8),
                    Text(
                      provider.currentWord,
                      style: const TextStyle(fontSize: 32, color: AppTheme.darkText, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ).animate().fade().scale(),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 70,
                child: ElevatedButton(
                  onPressed: _newGameSameSettings,
                  child: const Text('PLAY AGAIN', style: TextStyle(fontSize: 20, letterSpacing: 1.2)),
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class GameScreenRouteController extends StatelessWidget {
  const GameScreenRouteController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RevealScreen();
  }
}
