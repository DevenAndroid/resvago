class UserData {
  final dynamic docid;
  final dynamic restaurantName;
  final dynamic searchName;
  final dynamic email;
  final dynamic category;
  final dynamic mobileNumber;
  final dynamic address;
  final dynamic image;
  final dynamic time;
  bool? deactivate;
  dynamic latitude;
  dynamic longitude;

  UserData(
      {required this.image,
      this.address,
      required this.deactivate,
      required this.docid,
      this.time,
      this.searchName,
      required this.category,
      required this.mobileNumber,
      required this.restaurantName,
        this.latitude,
        this.longitude,
      required this.email});

  Map<String, dynamic> toMap() {
    return {
      'restaurantName': restaurantName,
      'email': email,
      'category': category,
      'mobileNumber': mobileNumber,
      'docid': docid,
      'deactivate': deactivate,
      'address': address,
      'image': image,
      'time': time,
      'longitude': longitude,
      'latitude': latitude,
      'searchName': searchName,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map, String docId) {
    return UserData(
      restaurantName: map['restaurantName'],
      email: map['email'],
      category: map['category'],
      mobileNumber: map['mobileNumber'],
      deactivate: map['deactivate'],
      address: map['address'],
      image: map['image'],
      docid: docId,
      time: map['time'],
      searchName: map['searchName'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
