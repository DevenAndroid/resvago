class CustomerCareData {
  dynamic userId;
  dynamic email;
  dynamic docid;
  dynamic searchName;
  dynamic deactivate;
  dynamic time;

  CustomerCareData(
      {
        this.email,
        this.userId,
        this.docid,
        this.searchName,
        this.deactivate,
        this.time,});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'userId': userId,
      'docid': docid,
      'searchName': searchName,
      'deactivate': deactivate,
      'time': time,
    };
  }

  factory CustomerCareData.fromMap(Map<String, dynamic> map) {
    return CustomerCareData(
      email: map['email'],
      userId: map['userId'],
      docid: map['docid'],
      searchName: map['searchName'],
      time: map['time'],
      deactivate: map['deactivate'],
    );
  }
}
