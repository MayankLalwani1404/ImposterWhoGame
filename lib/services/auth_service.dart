import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream of the current user
  Stream<User?> get user => _auth.authStateChanges();

  // Sign in anonymously
  Future<User?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      
      if (user != null) {
        // Automatically create or update the user profile in Firestore
        final docRef = _db.collection('users').doc(user.uid);
        final doc = await docRef.get();
        if (!doc.exists) {
          await docRef.set({
            'displayName': 'Guest ${user.uid.substring(0, 4)}',
            'avatarId': null,
          });
        }
      }
      return user;
    } catch (e) {
      print("Auth Error: \$e");
      return null;
    }
  }

  Future<void> updateDisplayName(String uid, String newName) async {
    await _db.collection('users').doc(uid).update({'displayName': newName});
  }
}
