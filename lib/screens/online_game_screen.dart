import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/online_game_provider.dart';
import '../theme/app_theme.dart';
import 'vote_screen_online.dart';

class OnlineGameScreen extends StatefulWidget {
  const OnlineGameScreen({super.key});

  @override
  State<OnlineGameScreen> createState() => _OnlineGameScreenState();
}

class _OnlineGameScreenState extends State<OnlineGameScreen> {
  final TextEditingController _chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Online Match', style: TextStyle(color: AppTheme.accentLimeGreen)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Prevent leaving easily
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
            onPressed: () {
              Provider.of<OnlineGameProvider>(context, listen: false).leaveRoom();
              Navigator.pop(context); // Go back to Home
            },
          )
        ],
      ),
      body: Consumer<OnlineGameProvider>(
        builder: (context, provider, child) {
          final room = provider.currentRoom;
          if (room == null) return const Center(child: Text("Connection lost"));

          final currentUser = FirebaseAuth.instance.currentUser;
          final me = provider.players.firstWhere((p) => p.id == currentUser!.uid);

          // Find current active player index based on turn
          final activePlayerIndex = room.currentTurnIdx % provider.players.length;
          final activePlayer = provider.players[activePlayerIndex];
          bool isMyTurn = activePlayer.id == me.id;

          // Constraints
          bool canChat = true;
          if (room.settings.chatMode == 'turn_based' && !isMyTurn) {
            canChat = false;
          }

          bool canVote = true;
          if (room.settings.chatMode == 'turn_based' && room.roundCount < 3) {
            canVote = false;
          }

          int readyVotes = provider.players.where((p) => p.isReadyForVote).length;

          if (room.status == 'voting' || room.status == 'finished') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VoteScreenOnline()));
            });
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Turn Indicator
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppTheme.accentLimeGreen),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.record_voice_over, color: AppTheme.accentLimeGreen),
                      const SizedBox(width: 10),
                      Text("Currently Speaking: \${activePlayer.name}", style: const TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Player Grid
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: provider.players.length,
                    itemBuilder: (context, index) {
                      final player = provider.players[index];
                      bool isSpeaking = activePlayer.id == player.id;

                      return Container(
                        decoration: BoxDecoration(
                          color: isSpeaking ? AppTheme.accentLimeGreen.withOpacity(0.2) : AppTheme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: isSpeaking ? Border.all(color: AppTheme.accentLimeGreen, width: 2) : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: isSpeaking ? AppTheme.accentLimeGreen : Colors.grey[800],
                                  child: Text(player.avatarId, style: const TextStyle(fontSize: 32)),
                                ),
                                if (player.isReadyForVote)
                                  const CircleAvatar(radius: 10, backgroundColor: Colors.redAccent, child: Icon(Icons.warning, size: 12, color: Colors.white)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(player.name, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Actions area
                if (canChat)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _chatController,
                          style: const TextStyle(color: AppTheme.darkText),
                          decoration: InputDecoration(
                            hintText: 'Enter your word...',
                            filled: true,
                            fillColor: AppTheme.cardColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.send, color: AppTheme.accentLimeGreen),
                        onPressed: () {
                          provider.passTurn(_chatController.text.trim());
                          _chatController.clear();
                        },
                      )
                    ],
                  ),
                
                const SizedBox(height: 15),
                
                if (canVote)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: me.isReadyForVote ? Colors.grey : Colors.redAccent),
                      onPressed: me.isReadyForVote ? null : () {
                        provider.flagReadyForVote();
                      },
                      child: Text('BEGIN VOTING (${room.roundCount} Rounds) - ${readyVotes}/${provider.players.length} Ready', style: const TextStyle(color: Colors.white)),
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
