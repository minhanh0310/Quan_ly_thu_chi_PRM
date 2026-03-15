class UserModel {
  final String uid;
  final String name;
  final String email;
  final String createdAt;
  final String? currency;
  final String? photoUrl;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.createdAt,
    this.currency,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'createdAt': createdAt,
      if (currency != null) 'currency': currency,
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromMap(String uid, Map<dynamic, dynamic> map) {
    return UserModel(
      uid: uid,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      createdAt: map['createdAt'] as String? ?? '',
      currency: map['currency'] as String?,
      photoUrl: map['photoUrl'] as String?,
    );
  }
}
