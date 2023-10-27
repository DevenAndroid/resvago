import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resvago/admin/model/menuitem_model.dart';
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
  File categoryFile = File("");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool showValidation = false;
  bool showValidationImg = false;
  Future<void> addVendorToFirestore() async {
    if(!formKey.currentState!.validate())return;
    if(categoryFile.path.isEmpty){
      showToast("Please select category image");
      return;
    }

    List<String> arrangeNumbers = [];
    String kk = nameController.text.trim();

    arrangeNumbers.clear();
    for (var i = 0; i < kk.length; i++) {
      arrangeNumbers.add(kk.substring(0, i + 1));
    }
    String imageUrl = categoryFile.path;
    print("manish${categoryFile.path}");
    if (!categoryFile.path.contains("https")) {
      // if (menuItemData != null && menuItemData!.image != null) {
      //   Reference gg = FirebaseStorage.instance.refFromURL(menuItemData!.image);
      //   await gg.delete();
      // }
      UploadTask uploadTask = FirebaseStorage.instance
          .ref("categoryImages")
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(categoryFile);

      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
    } else {
      // if (menuItemData != null) {
      //   Reference gg = FirebaseStorage.instance.refFromURL(categoryFile.path);
      //   await gg.delete();
      // }
      // UploadTask uploadTask = FirebaseStorage.instance
      //     .ref("categoryImages")
      //     .child(DateTime.now().millisecondsSinceEpoch.toString())
      //     .putFile(categoryFile);

      // TaskSnapshot snapshot = await uploadTask;
      // imageUrl = await snapshot.ref.getDownloadURL();
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
    }
    else {
      await firebaseService.manageVendorCategory(
          documentReference: widget.collectionReference.doc(DateTime.now().millisecondsSinceEpoch.toString()),
          deactivate: null,
          description: descriptionController.text.trim(),
          docid: DateTime.now().millisecondsSinceEpoch,
          image: imageUrl,
          name: kk,
          searchName: arrangeNumbers,
          time: DateTime.now().millisecondsSinceEpoch
      );
      showToast("Category Added");
    }
    Get.back();
  }

  @override
  void initState() {
    super.initState();
    if (menuItemData != null) {
      nameController.text = menuItemData!.name ?? "";
      descriptionController.text = menuItemData!.description ?? "";
      categoryFile = File(menuItemData!.image.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xff3B5998),
        body: Form(
          key: formKey,
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * .06, vertical: size.height * .06),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(right: 15),
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const Text(
                        "Add Product Category",
                        style:
                        TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: size.height * .135,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: size.width * .04, vertical: size.height * .01)
                                .copyWith(bottom: 0),
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const SizedBox(height: 20),
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
                                  color: const Color(0xff3B5998),
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
                                  color: const Color(0xff3B5998),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: DottedBorder(
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
                                        _showActionSheet(context);
                                      },
                                      child: categoryFile.path != ""
                                          ? Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.white,
                                              image: DecorationImage(
                                                  image: FileImage(categoryFile),
                                                  fit: BoxFit.fill),
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            width: double.maxFinite,
                                            height: 180,
                                            alignment: Alignment.center,
                                            child: Image.file(categoryFile,
                                                errorBuilder: (_, __, ___) =>
                                                    Image.network(categoryFile.path,
                                                        errorBuilder: (_, __, ___) =>
                                                            SizedBox())),
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
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/gallery.png',
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
                                  backgroundcolor: const Color(0xff3B5998),
                                  onTap: addVendorToFirestore,
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
              ],
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
                CroppedFile? croppedFile = await ImageCropper().cropImage(
                  sourcePath: value.path,
                  aspectRatioPresets: [
                    CropAspectRatioPreset.square,
                    CropAspectRatioPreset.ratio3x2,
                    CropAspectRatioPreset.original,
                    CropAspectRatioPreset.ratio4x3,
                    CropAspectRatioPreset.ratio16x9
                  ],
                  uiSettings: [
                    AndroidUiSettings(
                        toolbarTitle: 'Cropper',
                        toolbarColor: Colors.deepOrange,
                        toolbarWidgetColor: Colors.white,
                        initAspectRatio: CropAspectRatioPreset.original,
                        lockAspectRatio: false),
                    IOSUiSettings(
                      title: 'Cropper',
                    ),
                    WebUiSettings(
                      context: context,
                    ),
                  ],
                );
                if (croppedFile != null) {
                  categoryFile = File(croppedFile.path);
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
                CroppedFile? croppedFile = await ImageCropper().cropImage(
                  sourcePath: value.path,
                  aspectRatioPresets: [
                    CropAspectRatioPreset.square,
                    CropAspectRatioPreset.ratio3x2,
                    CropAspectRatioPreset.original,
                    CropAspectRatioPreset.ratio4x3,
                    CropAspectRatioPreset.ratio16x9
                  ],
                  uiSettings: [
                    AndroidUiSettings(
                        toolbarTitle: 'Cropper',
                        toolbarColor: Colors.deepOrange,
                        toolbarWidgetColor: Colors.white,
                        initAspectRatio: CropAspectRatioPreset.original,
                        lockAspectRatio: false),
                    IOSUiSettings(
                      title: 'Cropper',
                    ),
                    WebUiSettings(
                      context: context,
                    ),
                  ],
                );
                if (croppedFile != null) {
                  categoryFile = File(croppedFile.path);
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


