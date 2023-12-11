import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future manageRegisterUsers({
    dynamic restaurantName,
    dynamic category,
    dynamic email,
    dynamic docid,
    dynamic mobileNumber,
    dynamic address,
    dynamic latitude,
    dynamic longitude,
    dynamic password,
    //dynamic confirmPassword,
    dynamic restaurant_position,
    dynamic image,
    dynamic userID,
    dynamic aboutUs,
    dynamic preparationTime,
    dynamic averageMealForMember,
    dynamic setDelivery,
    dynamic cancellation,
    dynamic menuSelection,
  }) async {
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection('vendor_users');
      var documentReference = collection.doc(FirebaseAuth.instance.currentUser!.uid);
      documentReference.set({
        "restaurantName": restaurantName,
        "category": category,
        "email": email,
        "docid": docid,
        "mobileNumber": mobileNumber,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "password": password,
        //"confirmPassword": confirmPassword,
        "restaurant_position": restaurant_position,
        "image": image,
        "aboutUs": aboutUs,
        "preparationTime": preparationTime,
        "averageMealForMember": averageMealForMember,
        "setDelivery": setDelivery,
        "cancellation": cancellation,
        "menuSelection": menuSelection,
        "time": DateTime.now(),
        "userID": mobileNumber,
        "deactivate":false
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future customerRegisterUsers({
    dynamic userName,
    dynamic email,
    dynamic docid,
    dynamic mobileNumber,
    dynamic password,
    dynamic userID,
  }) async {
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection('customer_users');
      var DocumentReference = collection.doc(FirebaseAuth.instance.currentUser!.uid);
      DocumentReference.set({
        "userName": userName,
        "email": email,
        "docid": docid,
        "mobileNumber": mobileNumber,
        "userID": mobileNumber,
        "profile_image": "",
        "password": "123456",
        "deactivate": false,
      }).then((value) {});
    } catch (e) {
      throw Exception(e);
    }
  }
}
