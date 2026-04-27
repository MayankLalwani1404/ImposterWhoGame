import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/online_game_provider.dart';
import '../models/online_models.dart';
import '../theme/app_theme.dart';
import 'lobby_screen.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  int _imposterCount = 1;
  int _maxPlayers = 10;
  String _chatMode = 'turn_based';

  void _createRoom() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final provider = Provider.of<OnlineGameProvider>(context, listen: false);
    final settings = RoomSettings(
      maxPlayers: _maxPlayers,
      imposterCount: _imposterCount,
      chatMode: _chatMode,
    );

    bool success = await provider.createRoom(name, settings);
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
        title: const Text('Create Room', style: TextStyle(color: AppTheme.accentLimeGreen)),
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
                const Text('Chat Mode', style: TextStyle(color: Colors.white, fontSize: 16)),
                DropdownButton<String>(
                  value: _chatMode,
                  dropdownColor: AppTheme.darkBackground,
                  style: const TextStyle(color: AppTheme.accentLimeGreen),
                  items: const [
                    DropdownMenuItem(value: 'open', child: Text('Open Chat (Use Discord/Zoom)')),
                    DropdownMenuItem(value: 'turn_based', child: Text('Turn-Based App Feed')),
                  ],
                  onChanged: (val) => setState(() => _chatMode = val!),
                ),
                const Spacer(),
                if (provider.errorMessage != null)
                  Text(provider.errorMessage!, style: const TextStyle(color: Colors.red)),
                ElevatedButton(
                  onPressed: _createRoom,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: AppTheme.accentLimeGreen,
                  ),
                  child: const Text('GENERATE CODE & CREATE', style: TextStyle(color: AppTheme.darkBackground, fontSize: 18, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
