class PagesData {
  final dynamic? docid;
  final dynamic title;
  final dynamic longdescription;
  final bool deactivate;
  final dynamic time;

  PagesData( {required this.deactivate, this.docid,this.time, required this.title, required this.longdescription});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'longdescription': longdescription,
      'docid': docid,
      'deactivate': deactivate,
      'time': time,
    };
  }

  factory PagesData.fromMap(Map<String, dynamic> map) {
    return PagesData(
      title: map['title'],
      longdescription: map['longdescription'],
      deactivate: map['deactivate'],
       docid: map['docid'],
      time: map['time'],
    );
  }
}
