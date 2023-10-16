import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resvago/admin/model/user_model.dart';
import '../components/helper.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';


class AddUsersScreen extends StatefulWidget {
  final UserData? userData;
  final bool isEditMode;
  final String? documentId;
  final String? name;
  final String? email;
  final String? password;
  final String? phoneNumber;
  final String? image;

  const AddUsersScreen({
    super.key,
    required this.isEditMode,
    this.documentId,
    this.name,
    this.phoneNumber,
    this.image,
    this.email,
    this.password,  this.userData,
  });

  @override
  State<AddUsersScreen> createState() => _AddUsersScreenState();
}

class _AddUsersScreenState extends State<AddUsersScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  File categoryFile = File("");
  UserData? get userData => widget.userData;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String result = "Email not found";
  bool isPasswordVisible = false;

  void checkEmailInFirestore() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: emailController.text)
        .get();

    if (result.docs.isNotEmpty) {
      showToast('Email already exits');
    } else if (phoneNumberController.text.toString().length < 4 ||
        phoneNumberController.text.toString().length > 16) {
      showToast('Enter Correct phone-number');
    } else {
      addusersToFirestore();
    }
  }

  Future<void> addusersToFirestore() async {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String phoneNumber = phoneNumberController.text;
    String? imageUrl;
    Timestamp currentTime = Timestamp.now();

    List<String> arrangeNumbers = [];
    String? userNumber = (name ?? "");
    arrangeNumbers.clear();
    for (var i = 0; i < userNumber.length; i++) {
      arrangeNumbers.add(userNumber.substring(0, i + 1));
    }
    if (!categoryFile.path.startsWith("gs://") && !categoryFile.path.startsWith("http://")) {
      if (userData != null) {
        Reference gg = FirebaseStorage.instance.refFromURL(categoryFile.path);
        await gg.delete();
      }
      UploadTask uploadTask = FirebaseStorage.instance
          .ref("categoryImages")
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(categoryFile);

      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
    } else {
      if (userData != null) {
        Reference gg = FirebaseStorage.instance.refFromURL(categoryFile.path);
        await gg.delete();
      }
      UploadTask uploadTask = FirebaseStorage.instance
          .ref("categoryImages")
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(categoryFile);

      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
    }
    if (name.isNotEmpty && email.isNotEmpty && imageUrl != null) {
      UserData users = UserData(
          name: name,
          searchName: arrangeNumbers,
          email: email,
          deactivate: false,
          image: imageUrl,
          password: password,
          phoneNumber: phoneNumber,
          time: currentTime);
      if (widget.isEditMode) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.documentId)
            .update(users.toMap());
      } else {
        FirebaseFirestore.instance.collection('users').add(users.toMap());
        Get.back();
        nameController.clear();
        emailController.clear();
        passwordController.clear();
        phoneNumberController.clear();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.name ?? "";
    emailController.text = widget.email ?? "";
    passwordController.text = widget.password ?? "";
    phoneNumberController.text = widget.phoneNumber ?? "";
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
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * .06,
                        vertical: size.height * .06),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10)
                              .copyWith(right: 15),
                          child: GestureDetector(
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
                          "Add Users",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
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
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(25),
                                    topLeft: Radius.circular(25))),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                      horizontal: size.width * .04,
                                      vertical: size.height * .01)
                                  .copyWith(bottom: 0),
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(1000),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.orange,
                                                  ),
                                                  width: 100,
                                                  height: 100,
                                                  child: Image.file(
                                                      categoryFile,
                                                      errorBuilder: (_, __,
                                                              ___) =>
                                                          Image.network(
                                                              categoryFile.path,
                                                              errorBuilder: (_,
                                                                      __,
                                                                      ___) =>
                                                                  SizedBox())),
                                                ),
                                              ),
                                              Positioned(
                                                top: 0,
                                                bottom: 0,
                                                right: 0,
                                                child: InkWell(
                                                  onTap: () {
                                                    _showActionSheet(context);
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape
                                                                .circle),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Color(
                                                                  0xff3B5998)),
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                        size:
                                                            size.height * .015,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const Text(
                                            "",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      MyTextField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter your name';
                                          }
                                        },
                                        controller: nameController,
                                        hintText: 'Enter User Name',
                                        keyboardtype: TextInputType.name,
                                        obscureText: false,
                                        color: Color(0xff3B5998),
                                      ),

                                      const SizedBox(height: 10),

                                      MyTextField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                        },
                                        controller: emailController,
                                        hintText: 'Enter Email',
                                        obscureText: false,
                                        keyboardtype:
                                            TextInputType.emailAddress,
                                        color: Color(0xff3B5998),
                                      ),
                                      const SizedBox(height: 10),
                                      MyTextField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter your password';
                                          }
                                        },
                                        controller: passwordController,
                                        hintText: 'Enter Password',
                                        obscureText: !isPasswordVisible,
                                        keyboardtype:
                                            TextInputType.visiblePassword,
                                        color: Color(0xff3B5998),
                                      ),

                                      const SizedBox(height: 10),

                                      MyTextField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter your phone number';
                                          }
                                        },
                                        controller: phoneNumberController,
                                        hintText: 'Enter Phone Number',
                                        obscureText: false,
                                        keyboardtype: TextInputType.phone,
                                        color: Color(0xff3B5998),
                                      ),
                                      // sign in button
                                      SizedBox(
                                        height: size.height * .2,
                                      ),
                                      MyButton(
                                        color: Colors.white,
                                        backgroundcolor: Color(0xff3B5998),
                                        onTap: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            checkEmailInFirestore();
                                            //addusersToFirestore();
                                            //Get.back();
                                          }
                                        },
                                        text: widget.isEditMode
                                            ? 'Update User'
                                            : 'Add User',
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
            )));
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
              Helper.addImagePicker(
                      imageSource: ImageSource.gallery, imageQuality: 75)
                  .then((value) async {
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
