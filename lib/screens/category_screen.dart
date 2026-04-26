import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';
import 'setup_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final isMaxed = provider.selectedCategories.length >= 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Categories'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '${provider.selectedCategories.length}/3',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
      body: !provider.isLoaded 
        ? const Center(child: CircularProgressIndicator(color: AppTheme.accentLimeGreen))
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select up to 3 categories to mix into the game!',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: provider.allCategories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, index) {
                    final cat = provider.allCategories[index];
                    final isSelected = provider.selectedCategories.contains(cat);
                    
                    return GestureDetector(
                      onTap: () {
                        if (!isSelected && isMaxed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Maximum 3 categories allowed!')),
                          );
                          return;
                        }
                        provider.toggleCategory(cat);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.accentLimeGreen.withOpacity(0.15) : AppTheme.cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppTheme.accentLimeGreen : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            isSelected 
                              ? BoxShadow(
                                  color: AppTheme.accentLimeGreen.withOpacity(0.4),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                )
                              : const BoxShadow(
                                  color: Colors.transparent,
                                  blurRadius: 0,
                                  spreadRadius: 0,
                                )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              cat.emojiIcon,
                              style: const TextStyle(fontSize: 48),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              cat.name,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? AppTheme.accentLimeGreen : Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ).animate().fade().scale(delay: Duration(milliseconds: 50 * (index % 6))),
                    );
                  },
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.selectedCategories.isEmpty
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const SetupScreen()),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: provider.selectedCategories.isEmpty
                            ? Colors.grey.withOpacity(0.3)
                            : AppTheme.accentLimeGreen,
                      ),
                      child: Text('CONTINUE', style: TextStyle(
                        color: provider.selectedCategories.isEmpty ? Colors.white54 : AppTheme.darkBackground,
                      )),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
