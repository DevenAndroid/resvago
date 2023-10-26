class CouponData {
  final dynamic promoCodeName;
  final dynamic code;
  final dynamic discount;
  final dynamic startDate;
  final dynamic endDate;
  final dynamic? docid;
  final bool deactivate;
  final dynamic userID;
  final dynamic userName;
  final dynamic time;
  final dynamic userValue;


  CouponData(
      {required this.promoCodeName,
        this.code,
        this.discount,
        this.userID,
        this.userValue,
        this.startDate,
        required this.deactivate,
         this.userName,
        this.endDate,
        this.time,
        this.docid});

  Map<String, dynamic> toMap() {
    return {
      'promoCodeName': promoCodeName,
      'code': code,
      'discount': discount,
      'startDate': startDate,
      'userID': userID,
      'userName': userName,
      'endDate': endDate,
      'docid': docid,
      'time': time,
      'deactivate': deactivate,
      'userValue': userValue,
    };
  }

  factory CouponData.fromMap(Map<String, dynamic> map) {
    return CouponData(
      promoCodeName: map['promoCodeName'],
      deactivate: map['deactivate'],
      code: map['code'],
      discount: map['discount'],
      userID: map['userID'],
      userName: map['userName'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      docid: map['docid'],
      time: map['time'],
      userValue: map['userValue'],
    );
  }
}
