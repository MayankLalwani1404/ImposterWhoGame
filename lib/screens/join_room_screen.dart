import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/online_game_provider.dart';
import '../theme/app_theme.dart';
import 'lobby_screen.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  void _joinRoom() async {
    final name = _nameController.text.trim();
    final code = _codeController.text.trim();
    if (name.isEmpty || code.isEmpty) return;

    final provider = Provider.of<OnlineGameProvider>(context, listen: false);
    bool success = await provider.joinRoom(code, name);
    
    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LobbyScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Join Room', style: TextStyle(color: AppTheme.accentLimeGreen)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.accentLimeGreen),
      ),
      body: Consumer<OnlineGameProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.accentLimeGreen));
          }
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Your Name', style: TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: AppTheme.darkText),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppTheme.cardColor,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Room Code', style: TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 8),
                TextField(
                  controller: _codeController,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(color: AppTheme.darkText, fontSize: 24, letterSpacing: 5),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppTheme.cardColor,
                    hintText: '5-DIGIT CODE',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  ),
                ),
                const Spacer(),
                if (provider.errorMessage != null)
                  Text(provider.errorMessage!, style: const TextStyle(color: Colors.red)),
                ElevatedButton(
                  onPressed: _joinRoom,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: AppTheme.accentLimeGreen,
                  ),
                  child: const Text('JOIN', style: TextStyle(color: AppTheme.darkBackground, fontSize: 18, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
