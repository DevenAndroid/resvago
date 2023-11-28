import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resvago/admin/model/menuitem_model.dart';
import '../components/appassets.dart';
import '../components/helper.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../firebase_service/firebase_service.dart';

class AddProductScreen extends StatefulWidget {
  final CollectionReference collectionReference;
  final MenuItemData? menuItemData;

  const AddProductScreen({
    super.key,
    required this.collectionReference,
    this.menuItemData,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  FirebaseService firebaseService = FirebaseService();
  MenuItemData? get menuItemData => widget.menuItemData;

  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool showValidation = false;
  bool showValidationImg = false;
  Rx<File> categoryFile = File("").obs;
  Uint8List? pickedFile;
  Future<void> addVendorToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    if(!formKey.currentState!.validate())return;
    // if(categoryFile.path.isEmpty){
    //   showToast("Please select category image");
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
      UploadTask uploadTask = FirebaseStorage.instance
          .ref("profileImage}")
          .child("profile_image")
          .putData(pickedFile!);
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
    } else {
      if(!categoryFile.value.path.contains("http")){
        UploadTask uploadTask = FirebaseStorage.instance
            .ref("categoryImages")
            .child(DateTime.now().millisecondsSinceEpoch.toString())
            .putFile(categoryFile.value);
        TaskSnapshot snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
      }
      else{
        imageUrl = categoryFile.value.path;
      }
    }
    if (menuItemData != null) {
      await firebaseService.manageCategoryProduct(
        documentReference: widget.collectionReference.doc(menuItemData!.docid),
        deactivate: menuItemData!.deactivate,
        description: descriptionController.text.trim(),
        docid: menuItemData!.docid,
        image: imageUrl,
        name: kk,
        searchName: arrangeNumbers,
      );
      showToast("Category Updated");
      Helper.hideLoader(loader);

    }
    else {
      await firebaseService.manageVendorCategory(
          documentReference: widget.collectionReference.doc(DateTime.now().millisecondsSinceEpoch.toString()),
          deactivate: false,
          description: descriptionController.text.trim(),
          docid: DateTime.now().millisecondsSinceEpoch,
          image: imageUrl,
          name: kk,
          searchName: arrangeNumbers,
          time: DateTime.now().millisecondsSinceEpoch
      );
      showToast("Category Added");
      Helper.hideLoader(loader);

    }
    Get.back();
  }

  @override
  void initState() {
    super.initState();
    if (menuItemData != null) {
      nameController.text = menuItemData!.name ?? "";
      descriptionController.text = menuItemData!.description ?? "";
      categoryFile = File(menuItemData!.image ?? "").obs;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: backAppBar(title: 'Add product category', context: context),
        body: Form(
          key: formKey,
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Padding(
              padding: kIsWeb ? const EdgeInsets.only(left: 250,right: 250) : EdgeInsets.zero,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.width * .04, vertical: size.height * .01)
                            .copyWith(bottom: 0),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const SizedBox(height: 10),
                            const Padding(
                              padding: EdgeInsets.only(left: 25),
                              child: Text("Title",style: TextStyle(color: Colors.black),),
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
                              hintText: 'Title',
                              obscureText: false,
                              color: Colors.white,
                            ),

                            const SizedBox(height: 20),
                            const Padding(
                              padding: EdgeInsets.only(left: 25),
                              child: Text("Description",style: TextStyle(color: Colors.black),),
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
                              minLines: 5,
                              maxLines: 5,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            kIsWeb
                                ? DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(20),
                              padding: const EdgeInsets.only(
                                  left: 40, right: 40, bottom: 10),
                              color: showValidationImg == false
                                  ? const Color(0xFFFAAF40)
                                  : Colors.red,
                              dashPattern: const [6],
                              strokeWidth: 1,
                              child: InkWell(
                                onTap: () {
                                  // showActionSheet(context);
                                  Helper.addFilePicker().then((value) {
                                    if (kIsWeb) {
                                      pickedFile = value;
                                      setState(() {});
                                      return;
                                    }
                                    setState(() {});
                                    categoryFile.value = value;
                                    print("Image----${categoryFile.value}");
                                  });
                                },
                                child: pickedFile != null
                                    ? Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      width: double.maxFinite,
                                      height: 180,
                                      alignment: Alignment.center,
                                      child: kIsWeb
                                          ? pickedFile != null
                                          ? Image.memory(pickedFile!)
                                          : Image.asset(
                                        AppAssets.gallery,
                                        height: 60,
                                        width: 50,
                                      )
                                          : Image.memory(pickedFile!,
                                          errorBuilder: (_, __,
                                              ___) =>
                                              Image.network(
                                                  categoryFile
                                                      .value.path,
                                                  errorBuilder: (_,
                                                      __, ___) =>
                                                  const SizedBox())),
                                    ),
                                  ],
                                )
                                    : Container(
                                  padding: const EdgeInsets.only(top: 8),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  width: double.maxFinite,
                                  height: 130,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AppAssets.gallery,
                                        height: 60,
                                        width: 50,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'Accepted file types: JPEG, Doc, PDF, PNG',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54),
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
                              radius: const Radius.circular(20),
                              padding: const EdgeInsets.only(
                                  left: 40, right: 40, bottom: 10),
                              color: showValidationImg == false
                                  ? const Color(0xFFFAAF40)
                                  : Colors.red,
                              dashPattern: const [6],
                              strokeWidth: 1,
                              child: InkWell(
                                onTap: () {
                                  // showActionSheet(context);
                                  Helper.addFilePicker().then((value) {
                                    categoryFile.value = value;
                                    setState(() {});
                                    print("Image----${categoryFile.value}");
                                  });
                                },
                                child: categoryFile.value.path != ""
                                    ? Obx(() {
                                  return Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        margin:
                                        const EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 10),
                                        width: double.maxFinite,
                                        height: 180,
                                        alignment: Alignment.center,
                                        child: Image.file(
                                            categoryFile.value,
                                            errorBuilder: (_, __, ___) =>
                                                Image.network(
                                                    categoryFile
                                                        .value.path,
                                                    errorBuilder: (_, __,
                                                        ___) =>
                                                    const SizedBox())),
                                      ),
                                    ],
                                  );
                                })
                                    : Container(
                                  padding: const EdgeInsets.only(top: 8),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  width: double.maxFinite,
                                  height: 130,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AppAssets.gallery,
                                        height: 60,
                                        width: 50,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'Accepted file types: JPEG, Doc, PDF, PNG',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54),
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

                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: size.height * .1,
                            ),

                            // sign in button
                            MyButton(
                              color: Colors.white,
                              backgroundcolor:  Colors.black,
                              onTap: (){
                                if (formKey.currentState!.validate()) {
                                  addVendorToFirestore();
                                } else {
                                  showToast('Please add data');
                                }
                              },
                              text: menuItemData != null ? 'Update' : 'Add',
                            ),

                            const SizedBox(height: 50),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ));
  }
  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          'Select Picture from',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Helper.addImagePicker(imageSource: ImageSource.camera, imageQuality: 75).then((value) async {

                if (value != null) {
                  categoryFile.value = File(value.path);
                  setState(() {});
                }

                Get.back();
              });
            },
            child: const Text("Camera"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Helper.addImagePicker(imageSource: ImageSource.gallery, imageQuality: 75).then((value) async {

                if (value != null) {
                  categoryFile.value = File(value.path);
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


