class PagesData {
  final dynamic? docid;
  final dynamic title;
  final dynamic longdescription;
  final bool deactivate;

  PagesData({required this.deactivate, this.docid, required this.title, required this.longdescription});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'longdescription': longdescription,
      'docid': docid,
      'deactivate': deactivate,
    };
  }

  factory PagesData.fromMap(Map<String, dynamic> map) {
    return PagesData(
      title: map['title'],
      longdescription: map['longdescription'],
      deactivate: map['deactivate'],
       docid: map['docid'],
    );
  }
}
