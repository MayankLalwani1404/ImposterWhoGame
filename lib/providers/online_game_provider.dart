import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:math';
import '../models/online_models.dart';

class OnlineGameProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Room? currentRoom;
  List<RoomPlayer> players = [];
  bool isLoading = false;
  String? errorMessage;

  StreamSubscription<DocumentSnapshot>? _roomSubscription;
  StreamSubscription<QuerySnapshot>? _playersSubscription;
  
  // Clean up streams to prevent memory leaks
  void _cancelStreams() {
    _roomSubscription?.cancel();
    _playersSubscription?.cancel();
  }

  String _generateRoomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        5, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  Future<bool> createRoom(String creatorName, RoomSettings settings) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("Not authenticated");

      // Silently clean up ghost rooms in the background
      _cleanOrphanedRooms();

      String roomCode = _generateRoomCode();
      
      // Check if room code exists (very rare but possible)
      final existing = await _db.collection('rooms').doc(roomCode).get();
      if (existing.exists) roomCode = _generateRoomCode();

      final newRoom = Room(
        id: roomCode,
        hostId: user.uid,
        status: 'lobby',
        settings: settings,
        startTimestamp: DateTime.now().millisecondsSinceEpoch,
      );

      final userDoc = await _db.collection('users').doc(user.uid).get();
      final String avatarId = (userDoc.exists && userDoc.data() != null && userDoc.data()!.containsKey('avatarId')) ? userDoc.get('avatarId') : '👤';

      final creatorPlayer = RoomPlayer(
        id: user.uid,
        name: creatorName,
        avatarId: avatarId,
      );

      // Batch write to create room and add host as player
      WriteBatch batch = _db.batch();
      DocumentReference roomRef = _db.collection('rooms').doc(roomCode);
      DocumentReference playerRef = roomRef.collection('players').doc(user.uid);

      batch.set(roomRef, newRoom.toFirestore());
      batch.set(playerRef, creatorPlayer.toFirestore());

      await batch.commit();

      _listenToRoom(roomCode);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> joinRoom(String roomCode, String playerName) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("Not authenticated");

      // Silently clean up ghost rooms in the background
      _cleanOrphanedRooms();

      roomCode = roomCode.toUpperCase();
      final roomRef = _db.collection('rooms').doc(roomCode);
      final roomDoc = await roomRef.get();

      if (!roomDoc.exists) {
        throw Exception("Room not found");
      }

      Room room = Room.fromFirestore(roomDoc.data()!, roomDoc.id);

      if (room.status != 'lobby') {
        throw Exception("Room is already in progress");
      }

      // Check capacity
      final playersSnapshot = await roomRef.collection('players').get();
      if (playersSnapshot.docs.length >= room.settings.maxPlayers) {
        throw Exception("Room is full");
      }

      final userDoc = await _db.collection('users').doc(user.uid).get();
      final String avatarId = (userDoc.exists && userDoc.data() != null && userDoc.data()!.containsKey('avatarId')) ? userDoc.get('avatarId') : '👤';

      final newPlayer = RoomPlayer(
        id: user.uid,
        name: playerName,
        avatarId: avatarId,
      );

      await roomRef.collection('players').doc(user.uid).set(newPlayer.toFirestore());

      _listenToRoom(roomCode);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void _listenToRoom(String roomId) {
    _cancelStreams();
    _roomSubscription = _db.collection('rooms').doc(roomId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        currentRoom = Room.fromFirestore(snapshot.data()!, snapshot.id);
        isLoading = false;
        notifyListeners();
      } else {
        // Room was deleted
        leaveRoom();
      }
    });

    _playersSubscription = _db.collection('rooms').doc(roomId).collection('players').snapshots().listen((snapshot) {
      players = snapshot.docs.map((doc) => RoomPlayer.fromFirestore(doc.data(), doc.id)).toList();
      
      if (currentRoom != null && currentRoom!.status == 'playing' && currentRoom!.hostId == _auth.currentUser?.uid) {
        int readyCount = players.where((p) => p.isReadyForVote).length;
        if (readyCount > players.length / 2) {
           _db.collection('rooms').doc(roomId).update({'status': 'voting'});
        }
      }
      notifyListeners();
    });
  }

  Future<void> leaveRoom() async {
    if (currentRoom == null) return;
    
    final user = _auth.currentUser;
    if (user != null) {
      if (currentRoom!.hostId == user.uid) {
        // Delete all players in subcollection before deleting room
        final playersSnap = await _db.collection('rooms').doc(currentRoom!.id).collection('players').get();
        for (var doc in playersSnap.docs) {
          await doc.reference.delete();
        }
        await _db.collection('rooms').doc(currentRoom!.id).delete();
      } else {
        await _db.collection('rooms').doc(currentRoom!.id).collection('players').doc(user.uid).delete();
      }
    }
    
    _cancelStreams();
    currentRoom = null;
    players = [];
    errorMessage = null;
    _roomSubscription = null;
    _playersSubscription = null;
    notifyListeners();
  }

  Future<void> updateRoomSettings(RoomSettings newSettings) async {
    if (currentRoom == null) return;
    await _db.collection('rooms').doc(currentRoom!.id).update({
      'settings': newSettings.toMap(),
    });
  }

  Future<void> startGame() async {
    if (currentRoom == null) return;
    if (players.length < 3) {
      errorMessage = "Need at least 3 players";
      notifyListeners();
      return;
    }

    List<String> roles = List.generate(players.length, (i) => i < currentRoom!.settings.imposterCount ? 'Imposter' : 'Citizen');
    roles.shuffle(Random());
    
    // Batch write roles and game start
    WriteBatch batch = _db.batch();
    for (var i = 0; i < players.length; i++) {
      batch.update(
        _db.collection('rooms').doc(currentRoom!.id).collection('players').doc(players[i].id),
        {'role': roles[i], 'isReadyForVote': false, 'votesCastId': null, 'chatWord': null}
      );
    }
    batch.update(_db.collection('rooms').doc(currentRoom!.id), {
      'status': 'playing',
      'currentTurnIdx': Random().nextInt(players.length), // Random first player
      'roundCount': 0,
    });
    await batch.commit();
  }

  Future<void> passTurn(String? typedWord) async {
    if (currentRoom == null) return;
    final int nextTurnCount = currentRoom!.currentTurnIdx + 1;
    final int roundCount = nextTurnCount ~/ players.length;
    
    await _db.collection('rooms').doc(currentRoom!.id).update({
      'currentTurnIdx': nextTurnCount,
      'roundCount': roundCount
    });
    
    if (typedWord != null && typedWord.isNotEmpty) {
      await _db.collection('rooms').doc(currentRoom!.id).collection('players').doc(_auth.currentUser!.uid).update({
        'chatWord': typedWord
      });
    }
  }

  Future<void> flagReadyForVote() async {
    if (currentRoom == null) return;
    await _db.collection('rooms').doc(currentRoom!.id).collection('players').doc(_auth.currentUser!.uid).update({
      'isReadyForVote': true
    });
  }

  Future<void> castVote(String suspectId) async {
    if (currentRoom == null) return;
    await _db.collection('rooms').doc(currentRoom!.id).collection('players').doc(_auth.currentUser!.uid).update({
      'votesCastId': suspectId
    });
    
    // Check if everyone voted
    final votesSnapshot = await _db.collection('rooms').doc(currentRoom!.id).collection('players').get();
    int voteCount = votesSnapshot.docs.where((d) => d.data()['votesCastId'] != null).length;
    
    if (voteCount == players.length && currentRoom!.hostId == _auth.currentUser!.uid) {
       await _db.collection('rooms').doc(currentRoom!.id).update({'status': 'finished'});
    }
  }

  // --- HOUSEKEEPING ---
  Future<void> _cleanOrphanedRooms() async {
    try {
      // 1 hour ago
      final threshold = DateTime.now().millisecondsSinceEpoch - (1000 * 60 * 60);
      final snapshots = await _db.collection('rooms')
          .where('startTimestamp', isLessThan: threshold)
          .get();

      for (var doc in snapshots.docs) {
        // Delete all players recursively first
        final playersSnap = await doc.reference.collection('players').get();
        for (var pDoc in playersSnap.docs) {
          await pDoc.reference.delete();
        }
        // Destroy the dead room
        await doc.reference.delete();
      }
    } catch (e) {
      debugPrint("Cleanup error: \$e");
    }
  }
}
