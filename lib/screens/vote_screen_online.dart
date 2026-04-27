import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/online_game_provider.dart';
import '../theme/app_theme.dart';

class VoteScreenOnline extends StatefulWidget {
  const VoteScreenOnline({super.key});

  @override
  State<VoteScreenOnline> createState() => _VoteScreenOnlineState();
}

class _VoteScreenOnlineState extends State<VoteScreenOnline> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Voting Phase', style: TextStyle(color: AppTheme.accentLimeGreen)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<OnlineGameProvider>(
        builder: (context, provider, child) {
          final room = provider.currentRoom;
          if (room == null) return const Center(child: Text("Connection lost"));

          final currentUser = FirebaseAuth.instance.currentUser;
          final me = provider.players.firstWhere((p) => p.id == currentUser!.uid);
          
          bool hasVoted = me.votesCastId != null;
          bool isFinished = room.status == 'finished';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  isFinished ? "RESULTS REVEALED" : (hasVoted ? "Waiting for others to vote..." : "WHO IS THE IMPOSTER?"), 
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: provider.players.length,
                    itemBuilder: (context, index) {
                      final player = provider.players[index];
                      int votesReceived = provider.players.where((p) => p.votesCastId == player.id).length;
                      bool isVotedFor = me.votesCastId == player.id;
                      
                      return GestureDetector(
                        onTap: (hasVoted || isFinished) ? null : () {
                          provider.castVote(player.id);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: isFinished && player.role == 'Imposter' ? Colors.red.withOpacity(0.3) : AppTheme.cardColor,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isFinished && player.role == 'Imposter' 
                                  ? Colors.red 
                                  : (isVotedFor ? AppTheme.accentLimeGreen : Colors.transparent),
                              width: 3,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(player.avatarId, style: const TextStyle(fontSize: 48)),
                              const SizedBox(height: 10),
                              Text(player.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              if (isFinished) ...[
                                const SizedBox(height: 5),
                                Text(player.role.toUpperCase(), style: TextStyle(color: player.role == 'Imposter' ? Colors.red : AppTheme.accentLimeGreen, fontSize: 12, fontWeight: FontWeight.w900)),
                                Text('${votesReceived} Votes', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                              ] else if (hasVoted) ...[
                                const SizedBox(height: 10),
                                if (player.votesCastId != null)
                                  const Icon(Icons.check_circle, color: AppTheme.accentLimeGreen)
                              ]
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                if (isFinished)
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentLimeGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        provider.leaveRoom();
                        Navigator.pop(context);
                      },
                      child: const Text('BACK TO LOBBY', style: TextStyle(color: AppTheme.darkBackground, fontSize: 18, fontWeight: FontWeight.bold)),
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
