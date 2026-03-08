import 'package:firebase_database/firebase_database.dart';
import 'package:Quan_ly_thu_chi_PRM/models/user_model.dart';

class UserDatabaseService {
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');

  Future<void> createUser(UserModel user) async {
    await _usersRef.child(user.uid).set(user.toMap());
  }

  Future<void> updateUserCurrency(String uid, String currency) async {
    await _usersRef.child(uid).update({'currency': currency});
  }
}
