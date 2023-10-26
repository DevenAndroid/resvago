class RegisterData {
  final dynamic restaurantName;
  final dynamic category;
  final dynamic email;
  final dynamic mobileNumber;
  final dynamic address;
  final dynamic password;
  final dynamic confirmPassword;
  final dynamic image;
  final dynamic? docid;
  final dynamic userID;

  RegisterData(
      {required this.restaurantName,
        this.category,
        this.email,
        this.userID,
        this.mobileNumber,
        required this.address,
        required this.password,
        required this.confirmPassword,
        required this.image,  this.docid});

  Map<String, dynamic> toMap() {
    return {
      'restaurantName': restaurantName,
      'category': category,
      'email': email,
      'mobileNumber': mobileNumber,
      'userID': userID,
      'address': address,
      'password': password,
      'confirmPassword': confirmPassword,
      'image': image,
      'docid': docid,
    };
  }

  factory RegisterData.fromMap(Map<String, dynamic> map) {
    return RegisterData(
      restaurantName: map['restaurantName'],
      category: map['category'],
      email: map['email'],
      mobileNumber: map['mobileNumber'],
      userID: map['userID'],
      address: map['address'],
      password: map['password'],
      confirmPassword: map['confirmPassword'],
      image: map['image'],
      docid: map['docid'],
    );
  }
}
