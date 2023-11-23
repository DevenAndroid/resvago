import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../components/addsize.dart';
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool showValidation = false;
  bool showValidationImg = false;
  Future<void> addresturentToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      if (!formKey.currentState!.validate()) return;
      if (categoryFile.path.isEmpty) {
        showToast("Please select category image");
        Helper.hideLoader(loader);
        return;
      }

      List<String> arrangeNumbers = [];
      String kk = nameController.text.trim();

      arrangeNumbers.clear();
      for (var i = 0; i < kk.length; i++) {
        arrangeNumbers.add(kk.substring(0, i + 1));
      }
      String imageUrlProfile = categoryFile.path;
      if (!categoryFile.path.contains("http")) {
        UploadTask uploadTask = FirebaseStorage.instance
            .ref("categoryImages")
            .child(DateTime.now().millisecondsSinceEpoch.toString())
            .putFile(categoryFile);
        TaskSnapshot snapshot = await uploadTask;
        imageUrlProfile = await snapshot.ref.getDownloadURL();
      }

      if (resturentData != null) {
        await firebaseService.manageCategoryProduct(
          documentReference:
              widget.collectionReference.doc(resturentData!.docid),
          deactivate: resturentData!.deactivate,
          description: descriptionController.text.trim(),
          docid: resturentData!.docid,
          image: imageUrlProfile,
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
            image: imageUrlProfile,
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
      categoryFile = File(resturentData!.image.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: backAppBar(title: 'Add Vendor category', context: context),
        backgroundColor: const Color(0xff3B5998),
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
                              const Padding(
                                padding: EdgeInsets.only(left: 25),
                                child: Text(
                                  "Vendor Category Name",
                                  style: TextStyle(color: Colors.black),
                                ),
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

                              const SizedBox(height: 20),
                              const Padding(
                                padding: EdgeInsets.only(left: 25),
                                child: Text(
                                  "Description",
                                  style: TextStyle(color: Colors.black),
                                ),
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
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white,
                                                    image: DecorationImage(
                                                        image: FileImage(
                                                            categoryFile),
                                                        fit: BoxFit.fill),
                                                  ),
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                                  width: double.maxFinite,
                                                  height: 180,
                                                  alignment: Alignment.center,
                                                  child: categoryFile.path
                                                              .contains(
                                                                  "http") ||
                                                          categoryFile
                                                              .path.isEmpty
                                                      ? Image.network(
                                                          categoryFile.path,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (_, __,
                                                                  ___) =>
                                                              CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            imageUrl:
                                                                categoryFile
                                                                    .path,
                                                            height:
                                                                AddSize.size30,
                                                            width:
                                                                AddSize.size30,
                                                            errorWidget:
                                                                (_, __, ___) =>
                                                                    const Icon(
                                                              Icons.person,
                                                              size: 60,
                                                            ),
                                                            placeholder: (
                                                              _,
                                                              __,
                                                            ) =>
                                                                const SizedBox(),
                                                          ),
                                                        )
                                                      : Image.memory(
                                                          categoryFile
                                                              .readAsBytesSync(),
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (_, __,
                                                                  ___) =>
                                                              CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            imageUrl:
                                                                categoryFile
                                                                    .path,
                                                            height:
                                                                AddSize.size30,
                                                            width:
                                                                AddSize.size30,
                                                            errorWidget:
                                                                (_, __, ___) =>
                                                                    const Icon(
                                                              Icons.person,
                                                              size: 60,
                                                            ),
                                                            placeholder: (
                                                              _,
                                                              __,
                                                            ) =>
                                                                const SizedBox(),
                                                          ),
                                                        )
                                              ),
                                            ],
                                          )
                                        : Container(
                                            padding:
                                                const EdgeInsets.only(top: 8),
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
            ),
          ),
        ));
  }

  void _showActionSheet(BuildContext context) {
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
