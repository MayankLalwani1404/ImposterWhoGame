import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/online_game_provider.dart';
import '../theme/app_theme.dart';
import 'online_game_screen.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        Provider.of<OnlineGameProvider>(context, listen: false).leaveRoom();
      },
      child: Scaffold(
        backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Room Lobby', style: TextStyle(color: AppTheme.accentLimeGreen)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.accentLimeGreen),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Provider.of<OnlineGameProvider>(context, listen: false).leaveRoom();
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<OnlineGameProvider>(
        builder: (context, provider, child) {
          final room = provider.currentRoom;
          if (room == null) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.accentLimeGreen));
          }

          final currentUser = FirebaseAuth.instance.currentUser;
          final isHost = room.hostId == currentUser?.uid;

          // Automatically route if game started
          if (room.status == 'playing') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnlineGameScreen()));
            });
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: AppTheme.accentLimeGreen, width: 2),
                    ),
                    child: Column(
                      children: [
                        const Text('ROOM CODE', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        Text(
                          room.id,
                          style: const TextStyle(color: AppTheme.accentLimeGreen, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 8),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text('Players in Lobby:', style: TextStyle(color: Colors.white, fontSize: 20)),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.players.length,
                    itemBuilder: (context, index) {
                      final player = provider.players[index];
                      return ListTile(
                        leading: CircleAvatar(backgroundColor: AppTheme.accentLimeGreen, child: Text(player.avatarId, style: const TextStyle(fontSize: 20))),
                        title: Text(player.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                        trailing: player.id == room.hostId ? const Icon(Icons.star, color: Colors.yellow) : null,
                      );
                    },
                  ),
                ),
                if (isHost)
                  ElevatedButton(
                    onPressed: provider.players.length >= 3 ? () => provider.startGame() : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: AppTheme.accentLimeGreen,
                      disabledBackgroundColor: AppTheme.cardColor,
                    ),
                    child: const Text('START GAME', style: TextStyle(color: AppTheme.darkBackground, fontSize: 18, fontWeight: FontWeight.bold)),
                  )
                else
                  const Center(child: Text('Waiting for host to start...', style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic))),
              ],
            ),
          );
        },
      ),
    ));
  }
}
