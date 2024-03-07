import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:resvago/admin/customeruser_list.dart';
import 'package:resvago/components/my_button.dart';
import 'model/customer_care_list_screen.dart';
import 'model/customer_model.dart';
import '../components/addsize.dart';
import '../components/apptheme.dart';
import '../components/helper.dart';
import '../components/my_textfield.dart';

class EditCustomerCare extends StatefulWidget {
  EditCustomerCare({super.key, required this.uid});
  String uid;
  @override
  State<EditCustomerCare> createState() => _EditCustomerCareState();
}

class _EditCustomerCareState extends State<EditCustomerCare> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController mobileController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  CustomerCareData profileData = CustomerCareData();
  String code = "+353";
  String country = "IE";
  int kk = 0;
  File categoryFile = File("");
  Uint8List? pickedFile;
  String fileUrl = "";
  bool twoStepVerification = false;

  void fetchData() {
    FirebaseFirestore.instance.collection("customer_care").doc(widget.uid).get().then((value) {
      if (value.exists) {
        if (value.data() == null) return;
        profileData = CustomerCareData.fromMap(value.data()!);
        log("profile data${profileData.email}");
        emailController.text = (profileData.email ?? "").toString();
        kk++;
        setState(() {});
      }
    });
  }

  Future<void> updateProfileToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      await FirebaseFirestore.instance.collection("customer_care").doc(widget.uid).update({
        "email": emailController.text.trim(),
        "mobileNumber": mobileController.text.trim(),
        "docid": widget.uid,
      }).then((value) => Fluttertoast.showToast(msg: "Profile Updated"));
      Helper.hideLoader(loader);
      fetchData();
    } catch (e) {
      Helper.hideLoader(loader);
      throw Exception(e);
    } finally {
      Helper.hideLoader(loader);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  bool apiLoaded = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        appBar: backAppBar(title: "Edit Customer Care", context: context),
        body: SingleChildScrollView(
          // physics: BouncingScrollPhysics(),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.black),
                ),
                Container(
                  width: size.width,
                  height: size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   'Name'.tr,
                              //   style:
                              //   GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // RegisterTextFieldWidget(
                              //     controller: firstNameController,
                              //     validator: RequiredValidator(errorText: 'Please enter your name').call,
                              //     hint: "Name".tr),
                              // const SizedBox(
                              //   height: 20,
                              // ),
                              Text(
                                "Email".tr,
                                style:
                                GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              RegisterTextFieldWidget(
                                readOnly: true,
                                controller: emailController,
                                validator: MultiValidator([
                                  RequiredValidator(errorText: 'Please enter your email'),
                                  EmailValidator(errorText: 'Enter a valid email address'),
                                ]).call,
                                keyboardType: TextInputType.emailAddress,
                                // textInputAction: TextInputAction.next,
                                hint: "Email".tr,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              MyButton(
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    updateProfileToFirestore();
                                  }
                                },
                                text: 'Save'.tr,
                                color: Colors.white,
                                backgroundcolor: Colors.black,
                              ),
                            ],
                          ).appPaddingForScreen,
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                    ]
                  ),
                )
                )
              ],
            ),
          ),
        ));
  }

  void showActionSheet(BuildContext context) {
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
              Helper.addImagePicker(imageSource: ImageSource.camera, imageQuality: 50).then((value) async {
                // CroppedFile? croppedFile = await ImageCropper().cropImage(
                //   sourcePath: value.path,
                //   aspectRatioPresets: [
                //     CropAspectRatioPreset.square,
                //     CropAspectRatioPreset.ratio3x2,
                //     CropAspectRatioPreset.original,
                //     CropAspectRatioPreset.ratio4x3,
                //     CropAspectRatioPreset.ratio16x9
                //   ],
                //   uiSettings: [
                //     AndroidUiSettings(
                //         toolbarTitle: 'Cropper',
                //         toolbarColor: Colors.deepOrange,
                //         toolbarWidgetColor: Colors.white,
                //         initAspectRatio: CropAspectRatioPreset.ratio4x3,
                //         lockAspectRatio: false),
                //     IOSUiSettings(
                //       title: 'Cropper',
                //     ),
                //     WebUiSettings(
                //       context: context,
                //     ),
                //   ],
                // );
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
              Helper.addImagePicker(imageSource: ImageSource.gallery, imageQuality: 50).then((value) async {
                // CroppedFile? croppedFile = await ImageCropper().cropImage(
                //   sourcePath: value.path,
                //   aspectRatioPresets: [
                //     CropAspectRatioPreset.square,
                //     CropAspectRatioPreset.ratio3x2,
                //     CropAspectRatioPreset.original,
                //     CropAspectRatioPreset.ratio4x3,
                //     CropAspectRatioPreset.ratio16x9
                //   ],
                //   uiSettings: [
                //     AndroidUiSettings(
                //         toolbarTitle: 'Cropper',
                //         toolbarColor: Colors.deepOrange,
                //         toolbarWidgetColor: Colors.white,
                //         initAspectRatio: CropAspectRatioPreset.ratio4x3,
                //         lockAspectRatio: false),
                //     IOSUiSettings(
                //       title: 'Cropper',
                //     ),
                //     WebUiSettings(
                //       context: context,
                //     ),
                //   ],
                // );
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
