import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'screens/category_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: const ImposterWhoApp(),
    ),
  );
}

class ImposterWhoApp extends StatelessWidget {
  const ImposterWhoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imposter Who',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const CategoryScreen(),
    );
  }
}
