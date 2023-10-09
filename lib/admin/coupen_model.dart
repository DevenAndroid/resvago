class CouponData {
  final dynamic? docid;
  final dynamic title;
  final dynamic description;
  final dynamic code;
  final dynamic discount;
  final dynamic validtilldate;
  final bool deactivate;

  CouponData({required this.deactivate, this.docid, required this.title, required this.description,required this.code, required this.discount,required this.validtilldate});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'code': code,
      'discount': discount,
      'docid': docid,
      'deactivate': deactivate,
      'validtilldate': validtilldate,
    };
  }

  factory CouponData.fromMap(Map<String, dynamic> map) {
    return CouponData(
      title: map['title'],
      description: map['description'],
      code: map['code'],
      discount: map['discount'],
      deactivate: map['deactivate'],
       docid: map['docid'],
      validtilldate: map['validtilldate'],
    );
  }
}
