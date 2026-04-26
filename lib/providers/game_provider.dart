import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_models.dart';
import '../services/word_service.dart';

class GameProvider extends ChangeNotifier {
  final WordService _wordService = WordService();
  bool isLoaded = false;

  // Global predefined categories (inspired by user request)
  final List<CategoryItem> allCategories = const [
    CategoryItem('everyday_objects', 'Everyday Objects', '🔑'),
    CategoryItem('famous_people', 'Famous People', '⭐'),
    CategoryItem('food_drinks', 'Food & Drinks', '🍔'),
    CategoryItem('animals', 'Animals', '🦁'),
    CategoryItem('brands_logos', 'Brands & Logos', '🏷️'),
    CategoryItem('colors_shapes', 'Colors & Shapes', '🎨'),
    CategoryItem('countries_cities', 'Countries & Cities', '🌍'),
    CategoryItem('emotions_feelings', 'Emotions & Feelings', '😊'),
    CategoryItem('hobbies_activities', 'Hobbies & Activities', '🚲'),
    CategoryItem('internet_culture', 'Internet Culture', '📱'),
    CategoryItem('kitchen_cooking', 'Kitchen & Cooking', '🍳'),
    CategoryItem('movies_tv', 'Movies & TV Shows', '🎬'),
    CategoryItem('music_bands', 'Music & Bands', '🎸'),
    CategoryItem('occupations', 'Occupations', '💼'),
    CategoryItem('school_education', 'School & Education', '📚'),
    CategoryItem('science_technology', 'Science & Tech', '🔬'),
    CategoryItem('sports', 'Sports', '⚽'),
    CategoryItem('superheroes', 'Superheroes', '🦸'),
    CategoryItem('transportation', 'Transportation', '🚗'),
    CategoryItem('video_games', 'Video Games', '🎮'),
    CategoryItem('weather_nature', 'Weather & Nature', '⛈️'),
  ];

  // Game Setup State
  List<CategoryItem> selectedCategories = [];
  int playerCount = 3;
  int imposterCount = 1;
  bool useHints = true;
  List<Player> players = [];

  // Match State
  String currentWord = '';
  String currentHint = '';
  Player? startPlayer;

  GameProvider() {
    _init();
  }

  Future<void> _init() async {
    await _wordService.loadWords();
    isLoaded = true;
    _generateDefaultPlayers();
    notifyListeners();
  }

  void _generateDefaultPlayers() {
    players.clear();
    for (int i = 0; i < playerCount; i++) {
      players.add(Player(id: 'p$i', name: 'Player ${i + 1}'));
    }
  }

  void toggleCategory(CategoryItem cat) {
    if (selectedCategories.contains(cat)) {
      selectedCategories.remove(cat);
    } else {
      if (selectedCategories.length < 3) {
        selectedCategories.add(cat);
      }
    }
    notifyListeners();
  }

  void setPlayerCount(int count) {
    if (count < 3 || count > 20) return;
    playerCount = count;
    
    // Adjust imposter count bounded logic
    int maxImposters = getMaxImposters(playerCount);
    if (imposterCount > maxImposters) {
      imposterCount = maxImposters;
    }
    
    _generateDefaultPlayers();
    notifyListeners();
  }

  void setImposterCount(int count) {
    int maxImposters = getMaxImposters(playerCount);
    if (count < 1 || count > maxImposters) return;
    imposterCount = count;
    notifyListeners();
  }

  void updatePlayerName(int index, String name) {
    if (index >= 0 && index < players.length) {
      players[index].name = name;
      notifyListeners();
    }
  }

  void toggleHints() {
    useHints = !useHints;
    notifyListeners();
  }

  int getMaxImposters(int players) {
    if (players < 4) return 1;
    if (players < 7) return 2;
    if (players < 10) return 3;
    if (players < 14) return 4;
    return 5;
  }

  // --- Core Logic ---
  bool startGame() {
    if (selectedCategories.isEmpty) return false;
    
    final random = Random();
    
    // 1. Pick a random category out of selected ones
    CategoryItem chosenCategory = selectedCategories[random.nextInt(selectedCategories.length)];
    
    // 2. Load word pool
    List<WordData> pool = _wordService.getWordsForCategory(chosenCategory.id);
    if (pool.isEmpty) return false;

    // Pick random word
    WordData chosenData = pool[random.nextInt(pool.length)];
    currentWord = chosenData.word;
    currentHint = chosenData.hint;

    // 3. Assign Roles
    List<int> imposterIndices = [];
    while(imposterIndices.length < imposterCount) {
      int r = random.nextInt(playerCount);
      if (!imposterIndices.contains(r)) {
        imposterIndices.add(r);
      }
    }

    for (int i = 0; i < playerCount; i++) {
      bool isImp = imposterIndices.contains(i);
      players[i].isImposter = isImp;
      players[i].wordOrHint = isImp ? (useHints ? "Hint: $currentHint" : "You are the imposter") : currentWord;
    }

    // 4. Random start player
    startPlayer = players[random.nextInt(playerCount)];
    
    notifyListeners();
    return true;
  }
}
