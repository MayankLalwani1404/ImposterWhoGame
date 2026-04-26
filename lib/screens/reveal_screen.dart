import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import 'game_screen.dart';

class RevealScreen extends StatefulWidget {
  const RevealScreen({Key? key}) : super(key: key);

  @override
  State<RevealScreen> createState() => _RevealScreenState();
}

class _RevealScreenState extends State<RevealScreen> {
  int currentPlayerIndex = 0;
  bool isRevealed = false;
  double _panOffset = 0.0;

  void _nextPlayer() {
    final provider = context.read<GameProvider>();
    if (currentPlayerIndex < provider.players.length - 1) {
      setState(() {
        currentPlayerIndex++;
        isRevealed = false;
        _panOffset = 0.0;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ReadyScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<GameProvider>();
    final player = provider.players[currentPlayerIndex];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Player ${currentPlayerIndex + 1} of ${provider.players.length}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white54),
              ),
              const SizedBox(height: 20),
              
              const Spacer(),
              
              GestureDetector(
                onVerticalDragUpdate: isRevealed ? null : (details) {
                  setState(() {
                    _panOffset += details.delta.dy;
                  });
                },
                onVerticalDragEnd: isRevealed ? null : (details) {
                  if (_panOffset > 100 || _panOffset < -100) {
                    setState(() {
                      isRevealed = true;
                      _panOffset = 0;
                    });
                  } else {
                    setState(() {
                      _panOffset = 0;
                    });
                  }
                },
                child: Transform.translate(
                  offset: Offset(0, _panOffset),
                  child: AnimatedContainer(
                    duration: isRevealed ? const Duration(milliseconds: 300) : const Duration(milliseconds: 0),
                    width: double.infinity,
                    height: 350,
                    decoration: BoxDecoration(
                      color: isRevealed && player.isImposter 
                        ? const Color(0xFF2C2C2C) 
                        : AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: isRevealed
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  player.isImposter ? 'YOU ARE THE IMPOSTER!' : 'YOUR WORD',
                                  style: TextStyle(
                                    color: player.isImposter ? const Color(0xFFFF4040) : AppTheme.darkText,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  '${player.wordOrHint}',
                                  style: TextStyle(
                                    fontSize: player.isImposter && player.wordOrHint!.startsWith('Hint') ? 22 : 36, 
                                    fontWeight: FontWeight.bold, 
                                    color: player.isImposter ? Colors.white70 : AppTheme.darkText
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ).animate().fade().scale()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.person, size: 80, color: AppTheme.darkBackground),
                                const SizedBox(height: 10),
                                Text(
                                  player.name,
                                  style: const TextStyle(fontSize: 32, color: AppTheme.darkBackground, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 40),
                                const Icon(Icons.swap_vert, size: 40, color: Colors.black38)
                                    .animate(onPlay: (c) => c.repeat(reverse: true))
                                    .moveY(begin: -5, end: 5),
                                const SizedBox(height: 10),
                                const Text(
                                  'drag vertically to reveal',
                                  style: TextStyle(fontSize: 18, color: Colors.black54),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
              
              const Spacer(),
              if (isRevealed)
                SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: _nextPlayer,
                    child: const Text('NEXT PLAYER →'),
                  ),
                ).animate().fade().slideY(begin: 0.5),
            ],
          ),
        ),
      ),
    );
  }
}

class ReadyScreen extends StatelessWidget {
  const ReadyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_rounded, size: 120, color: AppTheme.accentLimeGreen)
                  .animate().scale(duration: const Duration(milliseconds: 500), curve: Curves.elasticOut),
              const SizedBox(height: 40),
              Text(
                'Game started!',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 40),
                textAlign: TextAlign.center,
              ).animate().fade(delay: const Duration(milliseconds: 300)),
              const SizedBox(height: 20),
              const Text(
                'Time to talk and catch the imposter.',
                style: TextStyle(fontSize: 20, color: Colors.white70),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                height: 70,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const GameScreen()),
                    );
                  },
                  child: const Text('PROCEED', style: TextStyle(fontSize: 20)),
                ),
              ).animate().fade(delay: const Duration(milliseconds: 600)).slideY(),
            ],
          ),
        ),
      ),
    );
  }
}
