import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resvago/admin/resturent_model.dart';

import '../components/helper.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';

class AddResturentScreen extends StatefulWidget {
  final bool isEditMode;
  final String? documentId;
  final String? name;
  final String? description;
  final String? image;

  const AddResturentScreen({
    super.key,
    required this.isEditMode,
    this.documentId,
    this.name,
    this.description, this.image,
  });

  @override
  State<AddResturentScreen> createState() => _AddResturentScreenState();
}

final _formKey = GlobalKey<FormState>();
Rx<File> file = File("").obs;
String imagePath = "";

class _AddResturentScreenState extends State<AddResturentScreen> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  Future<void> addresturentToFirestore() async {
    String name = nameController.text;
    String description = descriptionController.text;
    String? imageUrl;
    if (imagePath.isNotEmpty) {
      UploadTask uploadTask =
      FirebaseStorage.instance.ref("profilePictures").child(widget.name.toString()).putFile(file.value);

      TaskSnapshot snapshot = await uploadTask;

      imageUrl = await snapshot.ref.getDownloadURL();
    }
    if (name.isNotEmpty && description.isNotEmpty && imageUrl != null) {
      ResturentData resturent = ResturentData(name: name, description: description, deactivate: false,image: imageUrl);
      if (widget.isEditMode) {
        FirebaseFirestore.instance.collection('resturent').doc(widget.documentId).update(resturent.toMap());
      } else {
        FirebaseFirestore.instance.collection('resturent').add(resturent.toMap());
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.name ?? "";
    descriptionController.text = widget.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
        body: Obx(() {
      return SizedBox(
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
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                  const Text(
                    "Add Restaurant",
                    style:
                    TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w700),
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
                          borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * .04, vertical: size.height * .01)
                              .copyWith(bottom: 0),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(
                                children: [
                                  Stack(
                                    children: [
                                      file.value.path == ""
                                          ? Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              margin: EdgeInsets.only(right: size.width * .04, left: size.width * .015),
                                              child: CircleAvatar(
                                                radius: size.height * .05,
                                                backgroundImage: NetworkImage(''),
                                              ))
                                          : Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              margin: EdgeInsets.only(right: size.width * .04, left: size.width * .015),
                                              child: CircleAvatar(
                                                radius: size.height * .05,
                                                backgroundImage: FileImage(file.value),
                                              ),
                                            ),
                                      Positioned(
                                        top: 03,
                                        right: 06,
                                        child: InkWell(
                                          onTap: () {
                                            _showActionSheet(context);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration:
                                                const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: const BoxDecoration(shape: BoxShape.circle,color: Colors.redAccent),
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.black,
                                                size: size.height * .015,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const Text(
                                    "",
                                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              MyTextField(
                                controller: nameController,
                                hintText: 'Restaurant Name',
                                obscureText: false,
                              ),

                              const SizedBox(height: 10),

                              MyTextField(
                                controller: descriptionController,
                                hintText: 'Description',
                                obscureText: false,
                              ),
                              const SizedBox(height: 10),

                              // sign in button
                              MyButton(
                                onTap: () {
                                  if (nameController.text.isEmpty && descriptionController.text.isEmpty) {
                                    Fluttertoast.showToast(msg: 'Please enter Fields');
                                  } else {
                                    addresturentToFirestore();
                                    nameController.clear();
                                    descriptionController.clear();
                                    Get.back();
                                  }
                                },
                                text: widget.isEditMode ? 'Update Restaurant' : 'Add Restaurant',
                              ),

                              const SizedBox(height: 50),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }));
  }
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
                imagePath = croppedFile.path;
                file.value = File(croppedFile.path);
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
                imagePath = croppedFile.path;
                file.value = File(croppedFile.path);
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