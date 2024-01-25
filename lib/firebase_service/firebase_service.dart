import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resvago/components/helper.dart';

class FirebaseService {
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
        "deactivate": false
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future manageCategoryProduct({
    required DocumentReference documentReference,
    dynamic name,
    dynamic image,
    dynamic description,
    dynamic docid,
    dynamic deactivate,
    dynamic time,
    dynamic searchName,
  }) async {
    try {
      if (time != null) {
        await documentReference.set({
          "name": name,
          "image": image,
          "description": description,
          "docid": docid,
          "deactivate": deactivate,
          "time": time,
          "searchName": searchName,
        }).then((value) => () {
              showToast('Category Added');
            });
      } else {
        await documentReference.update({
          "name": name,
          "image": image,
          "description": description,
          "docid": docid,
          "searchName": searchName,
        }).then((value) => () {
              showToast('Category updated');
            });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future manageVendorCategory({
    required DocumentReference documentReference,
    dynamic name,
    dynamic image,
    dynamic description,
    dynamic docid,
    dynamic deactivate,
    dynamic time,
    dynamic searchName,
  }) async {
    try {
      if (time != null) {
        await documentReference.set({
          "name": name,
          "image": image,
          "description": description,
          "docid": docid,
          "deactivate": deactivate,
          "time": time,
          "searchName": searchName,
        });
      } else {
        await documentReference.update({
          "name": name,
          "image": image,
          "description": description,
          "docid": docid,
          "searchName": searchName,
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future manageFaq({
    required DocumentReference documentReference,
    dynamic question,
    dynamic answer,
    dynamic docid,
    dynamic deactivate,
    dynamic time,
  }) async {
    try {
      if (time != null) {
        await documentReference.set({
          "question": question,
          "answer": answer,
          "docid": docid,
          "deactivate": deactivate,
          "time": time,
        }).then((value) => showToast("FAQ added successfully"));
      } else {
        await documentReference.update({
          "question": question,
          "answer": answer,
          "docid": docid,
        }).then((value) => showToast("FAQ updated successfully"));
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
