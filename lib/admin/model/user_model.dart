class UserData {
  final dynamic docid;
  final dynamic restaurantName;
  final dynamic searchName;
  final dynamic email;
  final dynamic category;
  final dynamic mobileNumber;
  final dynamic address;
  final dynamic image;
  final dynamic time;
  bool? deactivate;
  dynamic latitude;
  dynamic longitude;
  dynamic code;
  dynamic country;

  UserData(
      {required this.image,
      this.address,
      required this.deactivate,
      required this.docid,
      this.time,
      this.searchName,
      required this.category,
      required this.mobileNumber,
      required this.restaurantName,
        this.latitude,
        this.longitude,
      required this.email,this.code,this.country});

  Map<String, dynamic> toMap() {
    return {
      'restaurantName': restaurantName,
      'email': email,
      'category': category,
      'mobileNumber': mobileNumber,
      'docid': docid,
      'deactivate': deactivate,
      'address': address,
      'image': image,
      'time': time,
      'longitude': longitude,
      'latitude': latitude,
      'searchName': searchName,
      'code': code,
      'country': country,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map, String docId) {
    return UserData(
      restaurantName: map['restaurantName'],
      email: map['email'],
      category: map['category'],
      mobileNumber: map['mobileNumber'],
      deactivate: map['deactivate'],
      address: map['address'],
      image: map['image'],
      docid: docId,
      time: map['time'],
      searchName: map['searchName'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      code: map['code'],
      country: map['country'],
    );
  }
}


class ProfileData {
  List<String>? restaurantImage;
  List<String>? menuGalleryImages;
  dynamic password;
  dynamic address;
  dynamic restaurantName;
  dynamic latitude;
  dynamic longitude;
  dynamic docid;
  dynamic mobileNumber;
  dynamic confirmPassword;
  dynamic category;
  dynamic userID;
  dynamic email;
  dynamic aboutUs;
  dynamic image;
  dynamic preparationTime;
  dynamic averageMealForMember;
  dynamic setDelivery;
  dynamic cancellation;
  dynamic menuSelection;
  dynamic deactivate;
  dynamic code;
  dynamic country;
  dynamic order_count = 0;

  ProfileData(
      {
        this.restaurantImage,
        this.menuGalleryImages,
        this.password,
        this.image,
        this.address,
        this.restaurantName,
        this.docid,
        this.mobileNumber,
        this.confirmPassword,
        this.category,
        this.userID,
        this.email,
        this.aboutUs,
        this.preparationTime,
        this.averageMealForMember,
        this.setDelivery,
        this.cancellation,
        this.menuSelection,
        this.latitude,
        this.longitude,
        this.deactivate,
        this.order_count,
        this.country,
        this.code,

      });

  ProfileData.fromJson(Map<String, dynamic> json) {
    restaurantImage = json['restaurantImage'] != null ? json['restaurantImage'].cast<String>() : [];
    menuGalleryImages = json['menuImage'] != null ? json['menuImage'].cast<String>() : [];
    password = json['password'];
    image = json['image'] ?? "";
    address = json['address'];
    restaurantName = json['restaurantName'];
    docid = json['docid'];
    mobileNumber = json['mobileNumber'];
    confirmPassword = json['confirmPassword'];
    category = json['category'];
    userID = json['userID'];
    email = json['email'];
    preparationTime = json['preparationTime'];
    averageMealForMember = json['averageMealForMember'];
    setDelivery = json['setDelivery'];
    cancellation = json['cancellation'];
    menuSelection = json['menuSelection'];
    aboutUs = json['aboutUs'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    deactivate = json['deactivate'];
    order_count = json['order_count'];
    code = json['code'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['restaurantImage'] = restaurantImage;
    data['menuImage'] = menuGalleryImages;
    data['password'] = password;
    data['address'] = address;
    data['restaurantName'] = restaurantName;
    data['docid'] = docid;
    data['mobileNumber'] = mobileNumber;
    data['confirmPassword'] = confirmPassword;
    data['category'] = category;
    data['userID'] = userID;
    data['email'] = email;
    data['aboutUs'] = aboutUs;
    data['preparationTime'] = preparationTime;
    data['averageMealForMember'] = averageMealForMember;
    data['setDelivery'] = setDelivery;
    data['cancellation'] = cancellation;
    data['menuSelection'] = menuSelection;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['deactivate'] = deactivate;
    data['order_count'] = order_count;
    data['code'] = code;
    data['country'] = country;
    return data;
  }
}

