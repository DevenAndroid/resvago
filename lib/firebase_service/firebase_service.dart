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

      showToast("Category Updated");
    } catch(e){
      throw Exception(e);
    }

  }

}