import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'category_screen.dart';
import 'profile_screen.dart';
import 'join_room_screen.dart';
import 'create_room_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _buildMenuButton(BuildContext context, String title, VoidCallback onTap, {bool isPrimary = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isPrimary ? AppTheme.accentLimeGreen : AppTheme.cardColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: isPrimary ? [
              BoxShadow(
                color: AppTheme.accentLimeGreen.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ] : null,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isPrimary ? AppTheme.darkBackground : AppTheme.darkText,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: AppTheme.accentLimeGreen, size: 30),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.search,
                size: 80,
                color: AppTheme.accentLimeGreen,
              ).animate().fade().scale(curve: Curves.easeOutBack, duration: 800.ms),
              const SizedBox(height: 20),
              Text(
                'IMPOSTER\nWHO',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.accentLimeGreen,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  letterSpacing: 2,
                ),
              ).animate().fade(delay: 300.ms).slideY(begin: 0.3, end: 0),
              const SizedBox(height: 60),
              
              _buildMenuButton(context, 'JOIN ROOM', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const JoinRoomScreen()));
              }, isPrimary: true).animate().fade(delay: 500.ms).slideX(begin: 0.2, end: 0),
              
              _buildMenuButton(context, 'CREATE ROOM', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateRoomScreen()));
              }).animate().fade(delay: 600.ms).slideX(begin: -0.2, end: 0),
              
              _buildMenuButton(context, 'QUICKPLAY', () {
                // Future Implementation
              }).animate().fade(delay: 700.ms).slideX(begin: 0.2, end: 0),
              
              const SizedBox(height: 20),
              const Divider(color: AppTheme.cardColor, thickness: 2),
              const SizedBox(height: 20),
              
              _buildMenuButton(context, 'OFFLINE MATCH', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoryScreen()),
                );
              }).animate().fade(delay: 800.ms).slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
