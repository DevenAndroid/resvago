class ResturentData {
  final dynamic docid;
  final dynamic name;
  final dynamic description;
  final dynamic image;
  final bool deactivate;

  ResturentData({required this.deactivate, this.docid, required this.description,required this.name,required this.image});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'description': description,
      'docid': docid,
      'deactivate': deactivate,
    };
  }

  factory ResturentData.fromMap(Map<String, dynamic> map) {
    return ResturentData(
      name: map['name'],
      description: map['description'],
      image: map['image'],
      deactivate: map['deactivate'],
      docid: map['docid'],
    );
  }
}
