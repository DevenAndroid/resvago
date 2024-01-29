import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resvago/admin/model/faq_model.dart';
import 'package:resvago/admin/model/menuitem_model.dart';
import '../components/appassets.dart';
import '../components/helper.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../firebase_service/firebase_service.dart';

class AddFAQScreen extends StatefulWidget {
  final CollectionReference collectionReference;
  final FAQModel? menuItemData;

  const AddFAQScreen({
    super.key,
    required this.collectionReference,
    this.menuItemData,
  });

  @override
  State<AddFAQScreen> createState() => _AddFAQScreenState();
}

class _AddFAQScreenState extends State<AddFAQScreen> {
  FirebaseService firebaseService = FirebaseService();
  FAQModel? get menuItemData => widget.menuItemData;

  TextEditingController descriptionController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future<void> addVendorToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    if (!formKey.currentState!.validate()) return;
    if (menuItemData != null) {
      await firebaseService.manageFaq(
        documentReference: widget.collectionReference.doc(menuItemData!.docid),
        deactivate: menuItemData!.deactivate,
        question: descriptionController.text.trim(),
        docid: menuItemData!.docid,
        answer: answerController.text.trim(),
      );
      showToast("FAQ Updated");
      Helper.hideLoader(loader);
      Get.back();
    } else {
      await firebaseService.manageFaq(
          documentReference: widget.collectionReference.doc(DateTime.now().millisecondsSinceEpoch.toString()),
          deactivate: false,
          question: descriptionController.text.trim(),
          docid: DateTime.now().millisecondsSinceEpoch,
          answer: answerController.text.trim(),
          time: DateTime.now().millisecondsSinceEpoch);
      showToast("FAQ Added");
      Helper.hideLoader(loader);
      Get.back();
    }
  }

  @override
  void initState() {
    super.initState();
    if (menuItemData != null) {
      answerController.text = menuItemData!.answer ?? "";
      descriptionController.text = menuItemData!.question ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: backAppBar(title: 'Add FAQ'.tr, context: context),
        body: Form(
            key: formKey,
            child: SizedBox(
                height: size.height,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: size.width * .04, vertical: size.height * .01).copyWith(bottom: 0),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const SizedBox(height: 10),
                               Text(
                                "Question".tr,
                                style: TextStyle(color: Colors.black),
                              ),
                              const SizedBox(height: 5),
                              MyTextField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter question';
                                  }
                                  return null;
                                },
                                controller: descriptionController,
                                hintText: 'Question'.tr,
                                obscureText: false,
                                color: Colors.white,
                              ),

                              const SizedBox(height: 20),
                               Text(
                                "Answer".tr,
                                style: TextStyle(color: Colors.black),
                              ),
                              const SizedBox(height: 5),
                              MyTextField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter answer';
                                  }
                                  return null;
                                },
                                controller: answerController,
                                hintText: 'Answer'.tr,
                                obscureText: false,
                                minLines: 5,
                                maxLines: 5,
                                color: Colors.white,
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
                                backgroundcolor: Colors.black,
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    addVendorToFirestore();
                                  } else {
                                    showToast('Please add data');
                                  }
                                },
                                text: menuItemData != null ? 'Update'.tr : 'Add'.tr,
                              ),

                              const SizedBox(height: 50),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ).appPaddingForScreen)));
  }
}
