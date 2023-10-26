class UserData {
  final dynamic? docid;
  final dynamic name;
  final dynamic searchName;
  final dynamic email;
  final dynamic category;
  final dynamic phoneNumber;
  final dynamic address;
  final dynamic image;
  final dynamic time;
  final bool deactivate;

  UserData( {required this.image,this.address, required this.deactivate, this.docid, this.time,this.searchName, required this.category, required this.phoneNumber,required this.name, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'category': category,
      'phoneNumber': phoneNumber,
      'docid': docid,
      'deactivate': deactivate,
      'address': address,
      'image': image,
      'time': time,
      'searchName': searchName,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'],
      email: map['email'],
      category: map['category'],
      phoneNumber: map['phoneNumber'],
      deactivate: map['deactivate'],
      address: map['address'],
      image: map['image'],
       docid: map['docid'],
       time: map['time'],
      searchName: map['searchName'],
    );
  }
}
