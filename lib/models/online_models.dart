class UserProfile {
  final String id;
  final String displayName;
  final String? avatarId;

  UserProfile({required this.id, required this.displayName, this.avatarId});

  factory UserProfile.fromFirestore(Map<String, dynamic> data, String id) {
    return UserProfile(
      id: id,
      displayName: data['displayName'] ?? 'Guest',
      avatarId: data['avatarId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'avatarId': avatarId,
    };
  }
}

class RoomPlayer {
  final String id;
  final String name;
  final String role; // 'Citizen', 'Imposter', or 'Unknown' before start
  final bool isReadyForVote;
  final String? votesCastId;
  final String? chatWord;
  final String avatarId;

  RoomPlayer({
    required this.id,
    required this.name,
    this.role = 'Unknown',
    this.isReadyForVote = false,
    this.votesCastId,
    this.chatWord,
    this.avatarId = '👤',
  });

  factory RoomPlayer.fromFirestore(Map<String, dynamic> data, String id) {
    return RoomPlayer(
      id: id,
      name: data['name'] ?? 'Player',
      role: data['role'] ?? 'Unknown',
      isReadyForVote: data['isReadyForVote'] ?? false,
      votesCastId: data['votesCastId'],
      chatWord: data['chatWord'],
      avatarId: data['avatarId'] ?? '👤',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'role': role,
      'isReadyForVote': isReadyForVote,
      'votesCastId': votesCastId,
      'chatWord': chatWord,
      'avatarId': avatarId,
    };
  }
}

class RoomSettings {
  final int maxPlayers;
  final int imposterCount;
  final String chatMode; // 'open' or 'turn_based'
  final List<String> categories;

  RoomSettings({
    this.maxPlayers = 10,
    this.imposterCount = 2,
    this.chatMode = 'open',
    this.categories = const ['everyday_objects'],
  });

  factory RoomSettings.fromMap(Map<String, dynamic> data) {
    return RoomSettings(
      maxPlayers: data['maxPlayers'] ?? 10,
      imposterCount: data['imposterCount'] ?? 2,
      chatMode: data['chatMode'] ?? 'open',
      categories: List<String>.from(data['categories'] ?? ['everyday_objects']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'maxPlayers': maxPlayers,
      'imposterCount': imposterCount,
      'chatMode': chatMode,
      'categories': categories,
    };
  }
}

class Room {
  final String id;
  final String hostId;
  final String status; // 'lobby', 'playing', 'voting', 'finished'
  final RoomSettings settings;
  final int currentTurnIdx;
  final int roundCount;
  final int startTimestamp;

  Room({
    required this.id,
    required this.hostId,
    required this.status,
    required this.settings,
    this.currentTurnIdx = 0,
    this.roundCount = 0,
    required this.startTimestamp,
  });

  factory Room.fromFirestore(Map<String, dynamic> data, String id) {
    return Room(
      id: id,
      hostId: data['hostId'] ?? '',
      status: data['status'] ?? 'lobby',
      settings: RoomSettings.fromMap(data['settings'] ?? {}),
      currentTurnIdx: data['currentTurnIdx'] ?? 0,
      roundCount: data['roundCount'] ?? 0,
      startTimestamp: data['startTimestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'hostId': hostId,
      'status': status,
      'settings': settings.toMap(),
      'currentTurnIdx': currentTurnIdx,
      'roundCount': roundCount,
      'startTimestamp': startTimestamp,
    };
  }
}
