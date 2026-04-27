import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = true;
  String _uid = '';
  String? _selectedAvatar;
  
  final List<String> _avatars = [
    '👤', '🐱', '🐶', '🦊', '🐻', '🐼', '🐨', '🐯', 
    '🐸', '🐵', '🦄', '🐙', '👾', '👽', '👻', '🤖'
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _uid = currentUser.uid;
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (doc.exists) {
        setState(() {
          _nameController.text = doc.get('displayName') ?? '';
          _selectedAvatar = doc.data().toString().contains('avatarId') ? doc.get('avatarId') : '👤';
        });
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    await _authService.updateDisplayName(_uid, _nameController.text.trim());
    if (_selectedAvatar != null) {
      await FirebaseFirestore.instance.collection('users').doc(_uid).update({'avatarId': _selectedAvatar});
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(color: AppTheme.accentLimeGreen)),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppTheme.accentLimeGreen),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.accentLimeGreen))
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Default Name',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: AppTheme.darkText),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppTheme.cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Enter your nickname...',
                      hintStyle: TextStyle(color: AppTheme.darkText.withValues(alpha: 0.5)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text('Select Avatar', style: TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: _avatars.length,
                      itemBuilder: (context, index) {
                        final avatar = _avatars[index];
                        final isSelected = _selectedAvatar == avatar;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedAvatar = avatar),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.accentLimeGreen : AppTheme.cardColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: isSelected ? AppTheme.accentLimeGreen : Colors.transparent, width: 3),
                            ),
                            child: Center(
                              child: Text(avatar, style: const TextStyle(fontSize: 32)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentLimeGreen,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text(
                        'SAVE PROFILE',
                        style: TextStyle(
                            color: AppTheme.darkBackground,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
