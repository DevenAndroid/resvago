import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resvago/components/helper.dart';

class FirebaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
          "deactivate": null,
          "time": time,
          "searchName": searchName,
        }).then((value) => (){
          showToast('Category Added');
        });
      } else {
        await documentReference.update({
          "name": name,
          "image": image,
          "description": description,
          "docid": docid,
          "searchName": searchName,
        }).then((value) => (){
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
          "deactivate": null,
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
}
