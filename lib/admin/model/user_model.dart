class UserData {
  final dynamic? docid;
  final dynamic name;
  final dynamic searchName;
  final dynamic email;
  final dynamic password;
  final dynamic phoneNumber;
  final dynamic image;
  final dynamic time;
  final bool deactivate;

  UserData( {required this.image,required this.deactivate, this.docid, this.time,this.searchName, required this.password, required this.phoneNumber,required this.name, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'docid': docid,
      'deactivate': deactivate,
      'image': image,
      'time': time,
      'searchName': searchName,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'],
      email: map['email'],
      password: map['password'],
      phoneNumber: map['phoneNumber'],
      deactivate: map['deactivate'],
      image: map['image'],
       docid: map['docid'],
       time: map['time'],
      searchName: map['searchName'],
    );
  }
}
