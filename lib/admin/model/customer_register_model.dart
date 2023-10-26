class CustomerRegisterData {
  final dynamic userName;
  final dynamic userId;
  final dynamic email;
  final dynamic mobileNumber;
  final dynamic docid;
  final dynamic searchName;
  final dynamic deactivate;
  final dynamic time;


  CustomerRegisterData({required this.userName, this.email,
    this.userId, this.mobileNumber, this.docid,this.searchName
  ,this.deactivate,this.time});

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'email': email,
      'userId': userId,
      'mobileNumber': mobileNumber,
      'docid': docid,
      'searchName': searchName,
      'deactivate': deactivate,
      'time': time,
    };
  }

  factory CustomerRegisterData.fromMap(Map<String, dynamic> map) {
    return CustomerRegisterData(
      userName: map['userName'],
      email: map['email'],
      userId: map['userId'],
      mobileNumber: map['mobileNumber'],
      docid: map['docid'],
      searchName: map['searchName'],
      time: map['time'],
      deactivate: map['deactivate'],
    );
  }
}