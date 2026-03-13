import 'package:firebase_database/firebase_database.dart';
import 'package:Quan_ly_thu_chi_PRM/models/user_model.dart';

class UserDatabaseService {
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');

  Future<void> createUser(UserModel user) async {
    await _usersRef.child(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUserById(String uid) async {
    final snapshot = await _usersRef.child(uid).get();
    if (snapshot.exists) {
      return UserModel.fromMap(uid, snapshot.value as Map<dynamic, dynamic>);
    }
    return null;
  }

  Future<void> updateUserCurrency(String uid, String currency) async {
    try {
      // Get existing user data to preserve all fields
      final existingUser = await getUserById(uid);
      if (existingUser != null) {
        if (existingUser.currency != null && existingUser.currency!.isNotEmpty) {
          return;
        }
        // Update existing user while preserving all fields
        final updatedUser = UserModel(
          uid: existingUser.uid,
          name: existingUser.name,
          email: existingUser.email,
          createdAt: existingUser.createdAt,
          currency: currency,
        );
        await _usersRef.child(uid).set(updatedUser.toMap());
      } else {
        // If user doesn't exist, just update with set (not update)
        await _usersRef.child(uid).update({'currency': currency});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserName(String uid, String name) async {
    try {
      // Get existing user data to preserve all fields
      final existingUser = await getUserById(uid);
      if (existingUser != null) {
        // Update existing user while preserving all fields
        final updatedUser = UserModel(
          uid: existingUser.uid,
          name: name,
          email: existingUser.email,
          createdAt: existingUser.createdAt,
          currency: existingUser.currency,
        );
        await _usersRef.child(uid).set(updatedUser.toMap());
      } else {
        // If user doesn't exist, create a new record (shouldn't happen in normal flow)
        throw Exception('User record not found for uid: $uid');
      }
    } catch (e) {
      rethrow;
    }
  }
}
