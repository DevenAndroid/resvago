class UserData {
  final String userId;
  final String name;
  final String email;
  final String password;
  final String phonenumber;

  UserData({required this.phonenumber, required this.userId, required this.name, required this.email, required this.password});

  // Convert User object to a Map for Firebase Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'password': password,
      'phonenumber': phonenumber,
    };
  }
}
