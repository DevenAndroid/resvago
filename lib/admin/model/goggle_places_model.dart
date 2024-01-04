import 'dart:convert';
GooglePlacesModel googlePlacesModelFromJson(String str) => GooglePlacesModel.fromJson(json.decode(str));
String googlePlacesModelToJson(GooglePlacesModel data) => json.encode(data.toJson());
class GooglePlacesModel {
  GooglePlacesModel({
    this.places,});

  GooglePlacesModel.fromJson(dynamic json) {
    if (json['places'] != null) {
      places = [];
      json['places'].forEach((v) {
        places?.add(Places.fromJson(v));
      });
    }
    places ??= [];
  }
  List<Places>? places = [];
  GooglePlacesModel copyWith({  List<Places>? places,
  }) => GooglePlacesModel(  places: places ?? this.places,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (places != null) {
      map['places'] = places?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

Places placesFromJson(String str) => Places.fromJson(json.decode(str));
String placesToJson(Places data) => json.encode(data.toJson());
class Places {
  Places({
    this.businessStatus,
    this.formattedAddress,
    this.geometry,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    this.name,
    this.openingHours,
    this.photos,
    this.placeId,
    this.plusCode,
    this.rating,
    this.reference,
    this.types,
    this.userRatingsTotal,});

  Places.fromJson(dynamic json) {
    businessStatus = json['business_status'];
    formattedAddress = json['formatted_address'];
    geometry = json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    icon = json['icon'];
    iconBackgroundColor = json['icon_background_color'];
    iconMaskBaseUri = json['icon_mask_base_uri'];
    name = json['name'];
    openingHours = json['opening_hours'] != null ? OpeningHours.fromJson(json['opening_hours']) : null;
    if (json['photos'] != null) {
      photos = [];
      json['photos'].forEach((v) {
        photos?.add(Photos.fromJson(v));
      });
    }
    placeId = json['place_id'];
    plusCode = json['plus_code'] != null ? PlusCode.fromJson(json['plus_code']) : null;
    rating = json['rating'];
    reference = json['reference'];
    types = json['types'] != null ? json['types'].cast<String>() : [];
    userRatingsTotal = json['user_ratings_total'];
  }
  String? businessStatus;
  String? formattedAddress;
  Geometry? geometry;
  String? icon;
  String? iconBackgroundColor;
  String? iconMaskBaseUri;
  String? name;
  OpeningHours? openingHours;
  List<Photos>? photos;
  String? placeId;
  PlusCode? plusCode;
  num? rating;
  String? reference;
  List<String>? types;
  num? userRatingsTotal;
  Places copyWith({  String? businessStatus,
    String? formattedAddress,
    Geometry? geometry,
    String? icon,
    String? iconBackgroundColor,
    String? iconMaskBaseUri,
    String? name,
    OpeningHours? openingHours,
    List<Photos>? photos,
    String? placeId,
    PlusCode? plusCode,
    num? rating,
    String? reference,
    List<String>? types,
    num? userRatingsTotal,
  }) => Places(  businessStatus: businessStatus ?? this.businessStatus,
    formattedAddress: formattedAddress ?? this.formattedAddress,
    geometry: geometry ?? this.geometry,
    icon: icon ?? this.icon,
    iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
    iconMaskBaseUri: iconMaskBaseUri ?? this.iconMaskBaseUri,
    name: name ?? this.name,
    openingHours: openingHours ?? this.openingHours,
    photos: photos ?? this.photos,
    placeId: placeId ?? this.placeId,
    plusCode: plusCode ?? this.plusCode,
    rating: rating ?? this.rating,
    reference: reference ?? this.reference,
    types: types ?? this.types,
    userRatingsTotal: userRatingsTotal ?? this.userRatingsTotal,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['business_status'] = businessStatus;
    map['formatted_address'] = formattedAddress;
    if (geometry != null) {
      map['geometry'] = geometry?.toJson();
    }
    map['icon'] = icon;
    map['icon_background_color'] = iconBackgroundColor;
    map['icon_mask_base_uri'] = iconMaskBaseUri;
    map['name'] = name;
    if (openingHours != null) {
      map['opening_hours'] = openingHours?.toJson();
    }
    if (photos != null) {
      map['photos'] = photos?.map((v) => v.toJson()).toList();
    }
    map['place_id'] = placeId;
    if (plusCode != null) {
      map['plus_code'] = plusCode?.toJson();
    }
    map['rating'] = rating;
    map['reference'] = reference;
    map['types'] = types;
    map['user_ratings_total'] = userRatingsTotal;
    return map;
  }

}

PlusCode plusCodeFromJson(String str) => PlusCode.fromJson(json.decode(str));
String plusCodeToJson(PlusCode data) => json.encode(data.toJson());
class PlusCode {
  PlusCode({
    this.compoundCode,
    this.globalCode,});

  PlusCode.fromJson(dynamic json) {
    compoundCode = json['compound_code'];
    globalCode = json['global_code'];
  }
  String? compoundCode;
  String? globalCode;
  PlusCode copyWith({  String? compoundCode,
    String? globalCode,
  }) => PlusCode(  compoundCode: compoundCode ?? this.compoundCode,
    globalCode: globalCode ?? this.globalCode,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['compound_code'] = compoundCode;
    map['global_code'] = globalCode;
    return map;
  }

}

Photos photosFromJson(String str) => Photos.fromJson(json.decode(str));
String photosToJson(Photos data) => json.encode(data.toJson());
class Photos {
  Photos({
    this.height,
    this.htmlAttributions,
    this.photoReference,
    this.width,});

  Photos.fromJson(dynamic json) {
    height = json['height'];
    htmlAttributions = json['html_attributions'] != null ? json['html_attributions'].cast<String>() : [];
    photoReference = json['photo_reference'];
    width = json['width'];
  }
  num? height;
  List<String>? htmlAttributions;
  String? photoReference;
  num? width;
  Photos copyWith({  num? height,
    List<String>? htmlAttributions,
    String? photoReference,
    num? width,
  }) => Photos(  height: height ?? this.height,
    htmlAttributions: htmlAttributions ?? this.htmlAttributions,
    photoReference: photoReference ?? this.photoReference,
    width: width ?? this.width,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['height'] = height;
    map['html_attributions'] = htmlAttributions;
    map['photo_reference'] = photoReference;
    map['width'] = width;
    return map;
  }

}

OpeningHours openingHoursFromJson(String str) => OpeningHours.fromJson(json.decode(str));
String openingHoursToJson(OpeningHours data) => json.encode(data.toJson());
class OpeningHours {
  OpeningHours({
    this.openNow,});

  OpeningHours.fromJson(dynamic json) {
    openNow = json['open_now'];
  }
  bool? openNow;
  OpeningHours copyWith({  bool? openNow,
  }) => OpeningHours(  openNow: openNow ?? this.openNow,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['open_now'] = openNow;
    return map;
  }

}

Geometry geometryFromJson(String str) => Geometry.fromJson(json.decode(str));
String geometryToJson(Geometry data) => json.encode(data.toJson());
class Geometry {
  Geometry({
    this.location,
    this.viewport,});

  Geometry.fromJson(dynamic json) {
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    viewport = json['viewport'] != null ? Viewport.fromJson(json['viewport']) : null;
  }
  Location? location;
  Viewport? viewport;
  Geometry copyWith({  Location? location,
    Viewport? viewport,
  }) => Geometry(  location: location ?? this.location,
    viewport: viewport ?? this.viewport,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (location != null) {
      map['location'] = location?.toJson();
    }
    if (viewport != null) {
      map['viewport'] = viewport?.toJson();
    }
    return map;
  }

}

Viewport viewportFromJson(String str) => Viewport.fromJson(json.decode(str));
String viewportToJson(Viewport data) => json.encode(data.toJson());
class Viewport {
  Viewport({
    this.northeast,
    this.southwest,});

  Viewport.fromJson(dynamic json) {
    northeast = json['northeast'] != null ? Northeast.fromJson(json['northeast']) : null;
    southwest = json['southwest'] != null ? Southwest.fromJson(json['southwest']) : null;
  }
  Northeast? northeast;
  Southwest? southwest;
  Viewport copyWith({  Northeast? northeast,
    Southwest? southwest,
  }) => Viewport(  northeast: northeast ?? this.northeast,
    southwest: southwest ?? this.southwest,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (northeast != null) {
      map['northeast'] = northeast?.toJson();
    }
    if (southwest != null) {
      map['southwest'] = southwest?.toJson();
    }
    return map;
  }

}

Southwest southwestFromJson(String str) => Southwest.fromJson(json.decode(str));
String southwestToJson(Southwest data) => json.encode(data.toJson());
class Southwest {
  Southwest({
    this.lat,
    this.lng,});

  Southwest.fromJson(dynamic json) {
    lat = json['lat'];
    lng = json['lng'];
  }
  num? lat;
  num? lng;
  Southwest copyWith({  num? lat,
    num? lng,
  }) => Southwest(  lat: lat ?? this.lat,
    lng: lng ?? this.lng,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = lat;
    map['lng'] = lng;
    return map;
  }

}

Northeast northeastFromJson(String str) => Northeast.fromJson(json.decode(str));
String northeastToJson(Northeast data) => json.encode(data.toJson());
class Northeast {
  Northeast({
    this.lat,
    this.lng,});

  Northeast.fromJson(dynamic json) {
    lat = json['lat'];
    lng = json['lng'];
  }
  num? lat;
  num? lng;
  Northeast copyWith({  num? lat,
    num? lng,
  }) => Northeast(  lat: lat ?? this.lat,
    lng: lng ?? this.lng,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = lat;
    map['lng'] = lng;
    return map;
  }

}

Location locationFromJson(String str) => Location.fromJson(json.decode(str));
String locationToJson(Location data) => json.encode(data.toJson());
class Location {
  Location({
    this.lat,
    this.lng,});

  Location.fromJson(dynamic json) {
    lat = json['lat'];
    lng = json['lng'];
  }
  num? lat;
  num? lng;
  Location copyWith({  num? lat,
    num? lng,
  }) => Location(  lat: lat ?? this.lat,
    lng: lng ?? this.lng,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = lat;
    map['lng'] = lng;
    return map;
  }

}