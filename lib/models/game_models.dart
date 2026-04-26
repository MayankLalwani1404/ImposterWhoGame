class Player {
  final String id;
  String name;
  bool isImposter;
  String? wordOrHint;

  Player({
    required this.id,
    required this.name,
    this.isImposter = false,
    this.wordOrHint,
  });

  Player copyWith({
    String? id,
    String? name,
    bool? isImposter,
    String? wordOrHint,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      isImposter: isImposter ?? this.isImposter,
      wordOrHint: wordOrHint ?? this.wordOrHint,
    );
  }
}

class CategoryItem {
  final String id;
  final String name;
  final String emojiIcon;

  const CategoryItem(this.id, this.name, this.emojiIcon);
}

class WordData {
  final String word;
  final String hint;

  factory WordData.fromJson(Map<String, dynamic> json) {
    return WordData(
      word: json['word'] ?? '',
      hint: json['hint'] ?? '',
    );
  }

  const WordData({required this.word, required this.hint});
}
