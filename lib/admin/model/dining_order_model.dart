class MyDiningOrderModel {
  dynamic date;
  List<MenuList>? menuList;
  dynamic orderId;
  dynamic vendorId;
  dynamic slot;
  dynamic userId;
  RestaurantInfo? restaurantInfo;
  CustomerData? customerData;
  dynamic offer;
  dynamic orderStatus;
  dynamic fcmToken;
  dynamic guest;
  dynamic time;
  dynamic total;
  dynamic docid;
  dynamic orderType;

  MyDiningOrderModel(
      {this.date,
        this.menuList,
        this.orderId,
        this.vendorId,
        this.slot,
        this.userId,
        this.restaurantInfo,
        this.offer,
        this.orderStatus,
        this.fcmToken,
        this.guest,
        this.customerData,
        this.time,
        this.total,
        this.docid,
        this.orderType});

  MyDiningOrderModel.fromJson(Map<String, dynamic> json,docid1) {
    date = json['date'];
    if (json['menuList'] != null) {
      menuList = <MenuList>[];
      json['menuList'].forEach((v) {
        menuList!.add(new MenuList.fromJson(v));
      });
    }
    orderId = json['orderId'];
    vendorId = json['vendorId'];
    slot = json['slot'];
    docid = docid1;
    userId = json['userId'];
    restaurantInfo = json['restaurantInfo'] != null
        ? new RestaurantInfo.fromJson(json['restaurantInfo'])
        : null;
    customerData = json['user_data'] != null ? CustomerData.fromJson(json['user_data']) : null;

    offer = json['offer'];
    orderStatus = json['order_status'];
    fcmToken = json['fcm_token'];
    guest = json['guest'];
    time = json['time'];
    orderType = json['order_type'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = date;
    if (menuList != null) {
      data['menuList'] = menuList!.map((v) => v.toJson()).toList();
    }
    data['orderId'] = orderId;
    data['vendorId'] = vendorId;
    data['slot'] = slot;
    data['userId'] = userId;
    if (restaurantInfo != null) {
      data['restaurantInfo'] = restaurantInfo!.toJson();
    }
    if (customerData != null) {
      data['user_data'] = customerData!.toJson();
    }
    data['offer'] = offer;
    data['order_status'] = orderStatus;
    data['fcm_token'] = fcmToken;
    data['guest'] = guest;
    data['time'] = time;
    data['order_type'] = orderType;
    return data;
  }
}

class MenuList {
  dynamic image;
  dynamic booking;
  dynamic docid;
  dynamic vendorId;
  dynamic discount;
  dynamic description;
  dynamic bookingForDining;
  dynamic price;
  dynamic qty;
  dynamic bookingForDelivery;
  dynamic menuId;
  dynamic dishName;
  dynamic time;
  dynamic category;

  MenuList(
      {this.image,
        this.booking,
        this.docid,
        this.vendorId,
        this.discount,
        this.description,
        this.bookingForDining,
        this.price,
        this.qty,
        this.bookingForDelivery,
        this.menuId,
        this.dishName,
        this.time,
        this.category});

  MenuList.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    booking = json['booking'];
    docid = json['docid'];
    vendorId = json['vendorId'];
    discount = json['discount'];
    description = json['description'];
    bookingForDining = json['bookingForDining'];
    price = json['price'];
    qty = json['qty'];
    bookingForDelivery = json['bookingForDelivery'];
    menuId = json['menuId'];
    dishName = json['dishName'];
    time = json['time'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = image;
    data['booking'] = booking;
    data['docid'] = docid;
    data['vendorId'] = vendorId;
    data['discount'] = discount;
    data['description'] = description;
    data['bookingForDining'] = bookingForDining;
    data['price'] = price;
    data['qty'] = qty;
    data['bookingForDelivery'] = bookingForDelivery;
    data['menuId'] = menuId;
    data['dishName'] = dishName;
    data['time'] = time;
    data['category'] = category;
    return data;
  }
}

class RestaurantInfo {
  dynamic image;
  dynamic aboutUs;
  dynamic address;
  dynamic docid;
  dynamic mobileNumber;
  dynamic latitude;
  dynamic userID;
  dynamic password;
  dynamic restaurantName;
  dynamic confirmPassword;
  List<String>? restaurantImage;
  List<String>? menuImage;
  dynamic category;
  dynamic email;
  dynamic longitude;

  RestaurantInfo(
      {this.image,
        this.aboutUs,
        this.address,
        this.docid,
        this.mobileNumber,
        this.latitude,
        this.userID,
        this.password,
        this.restaurantImage,
        this.restaurantName,
        this.confirmPassword,
        this.menuImage,
        this.category,
        this.email,
        this.longitude});

  RestaurantInfo.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    aboutUs = json['aboutUs'];
    address = json['address'];
    docid = json['docid'];
    mobileNumber = json['mobileNumber'];
    latitude = json['latitude'];
    userID = json['userID'];
    password = json['password'];
    restaurantImage = json['restaurantImage'].cast<String>();
    menuImage = json['menuImage'].cast<String>();
    restaurantName = json['restaurantName'];
    category = json['category'];
    email = json['email'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['aboutUs'] = aboutUs;
    data['address'] = address;
    data['docid'] = docid;
    data['mobileNumber'] = mobileNumber;
    data['latitude'] = latitude;
    data['userID'] = userID;
    data['password'] = password;
    data['restaurantImage'] = restaurantImage;
    data['restaurantName'] = restaurantName;
    data['menuImage'] = menuImage;
    data['category'] = category;
    data['email'] = email;
    data['longitude'] = longitude;
    return data;
  }
}
class CustomerData {
  dynamic userName;
  dynamic userId;
  dynamic docid;
  dynamic mobileNumber;
  dynamic email;


  CustomerData(
      {this.userId,
        this.userName,
        this.email,
        this.mobileNumber,
        this.docid,
      });

  CustomerData.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    docid = json['docid'];
    email = json['email'];
    mobileNumber = json['mobileNumber'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userName'] = userName;
    data['docid'] = docid;
    data['email'] = email;
    return data;
  }
}
