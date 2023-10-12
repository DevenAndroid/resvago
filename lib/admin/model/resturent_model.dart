class ResturentData {
  final dynamic docid;
  final dynamic name;
  final dynamic description;
  final dynamic image;
  final bool deactivate;
  final dynamic time;
  final dynamic searchName;

  ResturentData({required this.deactivate, this.docid,this.searchName, this.time, required this.description,required this.name,required this.image});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'description': description,
      'docid': docid,
      'deactivate': deactivate,
      'time': time,
      'searchName': searchName,
    };
  }

  factory ResturentData.fromMap(Map<String, dynamic> map) {
    return ResturentData(
      name: map['name'],
      description: map['description'],
      image: map['image'],
      deactivate: map['deactivate'],
      docid: map['docid'],
      time: map['time'],
      searchName: map['searchName'],
    );
  }
}
