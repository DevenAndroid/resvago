import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../components/addsize.dart';
import '../components/appassets.dart';
import '../components/helper.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../firebase_service/firebase_service.dart';
import 'model/resturent_model.dart';

class AddVendorScreen extends StatefulWidget {
  final CollectionReference collectionReference;
  final ResturentData? resturentData;

  const AddVendorScreen({
    super.key,
    required this.collectionReference,
    this.resturentData,
  });

  @override
  State<AddVendorScreen> createState() => _AddVendorScreenState();
}

class _AddVendorScreenState extends State<AddVendorScreen> {
  FirebaseService firebaseService = FirebaseService();
  ResturentData? get resturentData => widget.resturentData;

  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  File categoryFile = File("");
  Uint8List? pickedFile;
  String fileUrl = "";
  File profileImage = File("");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool showValidation = false;
  bool showValidationImg = false;
  Future<void> addresturentToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      // if (!formKey.currentState!.validate()) return;
      // if (categoryFile.path.isEmpty) {
      //   showToast("Please select category image");
      //   Helper.hideLoader(loader);
      //   return;
      // }

      List<String> arrangeNumbers = [];
      String kk = nameController.text.trim();

      arrangeNumbers.clear();
      for (var i = 0; i < kk.length; i++) {
        arrangeNumbers.add(kk.substring(0, i + 1));
      }
      String? imageUrl;
      if (kIsWeb) {
        if (pickedFile != null) {
          UploadTask uploadTask = FirebaseStorage.instance.ref("categoryImages}").child("profile_image").putData(pickedFile!);
          TaskSnapshot snapshot = await uploadTask;
          imageUrl = await snapshot.ref.getDownloadURL();
        } else {
          imageUrl = fileUrl;
        }
      }  else {
        if (!categoryFile.path.contains("https")) {
          // Reference gg = FirebaseStorage.instance.refFromURL(resturentData!.image.toString());
          // await gg.delete();

          UploadTask uploadTask = FirebaseStorage.instance
              .ref("categoryImages")
              .child(DateTime.now().millisecondsSinceEpoch.toString())
              .putFile(categoryFile);

          TaskSnapshot snapshot = await uploadTask;
          imageUrl = await snapshot.ref.getDownloadURL();
        }
      }

      if (resturentData != null) {
        await firebaseService.manageCategoryProduct(
          documentReference:
              widget.collectionReference.doc(resturentData!.docid),
          deactivate: resturentData!.deactivate,
          description: descriptionController.text.trim(),
          docid: resturentData!.docid,
          image: imageUrl,
          name: kk,
          searchName: arrangeNumbers,
        );
        showToast("Category Updated");
        Helper.hideLoader(loader);
      } else {
        await firebaseService.manageCategoryProduct(
            documentReference: widget.collectionReference
                .doc(DateTime.now().millisecondsSinceEpoch.toString()),
            deactivate: false,
            description: descriptionController.text.trim(),
            docid: DateTime.now().millisecondsSinceEpoch,
            image: imageUrl,
            name: kk,
            searchName: arrangeNumbers,
            time: DateTime.now().millisecondsSinceEpoch);
        showToast("Category Added");
        Helper.hideLoader(loader);
      }
      Get.back();
      Helper.hideLoader(loader);
    } catch (e) {
      Helper.hideLoader(loader);
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    if (resturentData != null) {
      nameController.text = resturentData!.name ?? "";
      descriptionController.text = resturentData!.description ?? "";
      if (!kIsWeb) {
        categoryFile = File(resturentData!.image ?? "");
      } else {
        fileUrl = resturentData!.image ?? "";
      }     }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: backAppBar(title: 'Add Vendor category', context: context),
        body: Form(
          key: formKey,
          child: SizedBox(
            height: size.height,
            width: size.width,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * .04,
                            vertical: size.height * .01)
                            .copyWith(bottom: 0),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Vendor Category Name",
                                  style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 5),
                                MyTextField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter Restaurant Name';
                                    }
                                    return null;
                                  },
                                  controller: nameController,
                                  hintText: 'Vendor Category Name',
                                  obscureText: false,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Description",
                                  style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 5),
                                MyTextField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter Description';
                                    }
                                    return null;
                                  },
                                  controller: descriptionController,
                                  hintText: 'Description',
                                  obscureText: false,
                                  maxLines: 5,
                                  minLines: 5,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                kIsWeb
                                    ? DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(20),
                                  padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                                  color: showValidationImg == false ? const Color(0xFFFAAF40) : Colors.red,
                                  dashPattern: const [6],
                                  strokeWidth: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      Helper.addFilePicker().then((value) {
                                        pickedFile = value;
                                        setState(() {});
                                      });
                                    },
                                    child: pickedFile != null
                                        ? Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                          width: double.maxFinite,
                                          height: 180,
                                          alignment: Alignment.center,
                                          child: Image.memory(pickedFile!),
                                        ),
                                      ],
                                    )
                                        : Container(
                                      padding: const EdgeInsets.only(top: 8),
                                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                      width: double.maxFinite,
                                      height: 130,
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.network(
                                            fileUrl,
                                            height: 60,
                                            width: 50,
                                            errorBuilder: (_, __, ___) => Image.asset(
                                              AppAssets.gallery,
                                              height: 60,
                                              width: 50,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Accepted file types: JPEG, Doc, PDF, PNG'.tr,
                                            style: const TextStyle(fontSize: 16, color: Colors.black54),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 11,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                    : DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(4),
                                  padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                                  color: showValidationImg == false ? const Color(0xFFFAAF40) : Colors.red,
                                  dashPattern: const [6],
                                  strokeWidth: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      showActionSheet(context);
                                    },
                                    child: categoryFile.path != ""
                                        ? Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                            image: DecorationImage(image: FileImage(profileImage), fit: BoxFit.fill),
                                          ),
                                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                          width: double.maxFinite,
                                          height: 180,
                                          alignment: Alignment.center,
                                          child: Image.file(categoryFile,
                                              errorBuilder: (_, __, ___) => Image.network(categoryFile.path,
                                                  errorBuilder: (_, __, ___) => const SizedBox())),
                                        ),
                                      ],
                                    )
                                        : Container(
                                      padding: const EdgeInsets.only(top: 8),
                                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                      width: double.maxFinite,
                                      height: 130,
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            AppAssets.gallery,
                                            height: 50,
                                            width: 40,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Accepted file types: JPEG, Doc, PDF, PNG'.tr,
                                            style:
                                            const TextStyle(fontSize: 14, color: Color(0xff141C21), fontWeight: FontWeight.w300),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 11,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: size.height * .1,
                                ),

                                // sign in button
                                MyButton(
                                  color: Colors.white,
                                  backgroundcolor: Colors.black,
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {
                                      addresturentToFirestore();
                                    } else {
                                      showToast('Please add data');
                                    }
                                  },
                                  text: resturentData != null ? 'Update' : 'Add',
                                ),

                                const SizedBox(height: 50),
                              ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ).appPaddingForScreen
          ),
        ));
  }

  void showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          'Select Picture from',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Helper.addImagePicker(
                      imageSource: ImageSource.camera, imageQuality: 75)
                  .then((value) async {
                if (value != null) {
                  categoryFile = File(value.path);
                  setState(() {});
                }

                Get.back();
              });
            },
            child: const Text("Camera"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Helper.addImagePicker(
                      imageSource: ImageSource.gallery, imageQuality: 75)
                  .then((value) async {
                if (value != null) {
                  categoryFile = File(value.path);
                  setState(() {});
                }

                Get.back();
              });
            },
            child: const Text('Gallery'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
