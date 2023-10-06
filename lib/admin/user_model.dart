class UserData {
  final String? docid;
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final bool deactivate;

  UserData({required this.deactivate, this.docid, required this.password, required this.phoneNumber,required this.name, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'docid': docid,
      'deactivate': deactivate,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'],
      email: map['email'],
      password: map['password'],
      phoneNumber: map['phoneNumber'],
      deactivate: map['deactivate'],
      // docid: map['docid'],
    );
  }
}
