class MenuItemData {
  final dynamic docid;
  final dynamic name;
  final dynamic description;
  final dynamic image;
  final bool deactivate;

  MenuItemData({required this.deactivate, this.docid, required this.description,required this.name,required this.image});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'description': description,
      'docid': docid,
      'deactivate': deactivate,
    };
  }

  factory MenuItemData.fromMap(Map<String, dynamic> map) {
    return MenuItemData(
      name: map['name'],
      description: map['description'],
      image: map['image'],
      deactivate: map['deactivate'],
      docid: map['docid'],
    );
  }
}
