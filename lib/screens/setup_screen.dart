import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import 'reveal_screen.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Setup'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             _buildSectionTitle(context, 'Number of Players'),
             _buildStepper(
               value: provider.playerCount,
               min: 3,
               max: 20,
               onChanged: (val) => context.read<GameProvider>().setPlayerCount(val),
             ),
             const SizedBox(height: 30),
             
             _buildSectionTitle(context, 'Number of Imposters'),
             _buildStepper(
               value: provider.imposterCount,
               min: 1,
               max: provider.getMaxImposters(provider.playerCount),
               onChanged: (val) => context.read<GameProvider>().setImposterCount(val),
             ),
             const SizedBox(height: 10),
             Text(
               '(Max imposters scales with player count)',
               style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white54),
             ),
             const SizedBox(height: 30),

             Container(
               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
               decoration: BoxDecoration(
                 color: AppTheme.cardColor,
                 borderRadius: BorderRadius.circular(16),
               ),
               child: SwitchListTile(
                 title: Text('Give hints to Imposters?', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18, color: AppTheme.darkText)),
                 subtitle: Text('Imposters will see a hint instead of just "You are the imposter".', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.darkText.withOpacity(0.6))),
                 value: provider.useHints,
                 activeColor: AppTheme.accentLimeGreen,
                 onChanged: (val) => context.read<GameProvider>().toggleHints(),
                 contentPadding: EdgeInsets.zero,
               ),
             ).animate().fade().slideY(begin: 0.2),

             const SizedBox(height: 30),
             _buildSectionTitle(context, 'Player Names'),
             Container(
               decoration: BoxDecoration(
                 color: AppTheme.cardColor,
                 borderRadius: BorderRadius.circular(16),
               ),
               child: ListView.separated(
                 shrinkWrap: true,
                 physics: const NeverScrollableScrollPhysics(),
                 itemCount: provider.playerCount,
                 separatorBuilder: (_, __) => const Divider(color: Colors.black12, height: 1),
                 itemBuilder: (context, index) {
                   final player = provider.players[index];
                   return ListTile(
                     leading: CircleAvatar(
                       backgroundColor: AppTheme.accentLimeGreen.withOpacity(0.2),
                       child: Text('${index + 1}', style: const TextStyle(color: AppTheme.darkText, fontWeight: FontWeight.bold)),
                     ),
                     title: TextFormField(
                       initialValue: player.name,
                       style: const TextStyle(color: AppTheme.darkText, fontWeight: FontWeight.bold),
                       decoration: InputDecoration(
                         border: InputBorder.none,
                         hintText: 'Player ${index + 1}',
                         hintStyle: const TextStyle(color: Colors.black38),
                       ),
                       onChanged: (val) {
                         context.read<GameProvider>().updatePlayerName(index, val.trim().isEmpty ? 'Player ${index + 1}' : val);
                       },
                     ),
                   );
                 },
               ),
             ).animate().fade().slideY(begin: 0.2),
             
             const SizedBox(height: 100), // spacing for bottom button
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
           width: double.infinity,
           height: 70,
           child: ElevatedButton(
            onPressed: () {
              bool started = context.read<GameProvider>().startGame();
              if (started) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RevealScreen()),
                );
              }
            },
            child: const Text('START GAME', style: TextStyle(fontSize: 20, letterSpacing: 1.2)),
          ),
        ),
      ).animate().scale(delay: const Duration(milliseconds: 300)),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppTheme.accentLimeGreen,
        ),
      ),
    );
  }

  Widget _buildStepper({required int value, required int min, required int max, required Function(int) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: value > min ? () => onChanged(value - 1) : null,
            icon: Icon(Icons.remove_circle_outline, 
              color: value > min ? AppTheme.darkText : Colors.black26, size: 32),
          ),
          Text('$value', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.darkText)),
          IconButton(
            onPressed: value < max ? () => onChanged(value + 1) : null,
            icon: Icon(Icons.add_circle_outline, 
              color: value < max ? AppTheme.darkText : Colors.black26, size: 32),
          ),
        ],
      ),
    ).animate().fade().slideX();
  }
}
