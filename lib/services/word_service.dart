import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/game_models.dart';

class WordService {
  Map<String, List<WordData>> _wordDatabase = {};

  Future<void> loadWords() async {
    try {
      final String response = await rootBundle.loadString('assets/data/words.json');
      final Map<String, dynamic> data = json.decode(response);
      
      _wordDatabase.clear();
      data.forEach((key, value) {
        if (value is List) {
          _wordDatabase[key] = value.map((e) => WordData.fromJson(e)).toList();
        }
      });
    } catch (e) {
      print('Error loading word database: $e');
    }
  }

  List<WordData> getWordsForCategory(String categoryId) {
    return _wordDatabase[categoryId] ?? [];
  }
}
