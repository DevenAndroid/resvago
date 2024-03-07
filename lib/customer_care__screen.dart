import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago/components/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import 'admin/model/admin_model.dart';

class CustomerCareScreen extends StatefulWidget {
  final bool isEditMode;
  final String? documentId;
  final String? email;

  const CustomerCareScreen({
    super.key,
    required this.isEditMode,
    this.documentId,
    this.email,
  });

  @override
  State<CustomerCareScreen> createState() => _settingScreenState();
}

class _settingScreenState extends State<CustomerCareScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController commissionPercentage = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> addSettingToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      User? user = userCredential.user;
      await user!.updatePassword(passwordController.text.trim()).then((value) async {
        FirebaseFirestore.instance.collection('customer_care_login').doc(user.uid).update({
          'email': emailController.text,
          'Password': passwordController.text,
          "admin_commission": commissionPercentage.text.trim(),
          "UserId": FirebaseAuth.instance.currentUser!.uid
        });
        Helper.hideLoader(loader);
        showToast('Customer Care Updated');
      });
    } catch (error) {
      print('Error updating settings: $error');
      Helper.hideLoader(loader);
      showToast('Failed to update settings');
    }
  }

  AdminModel? adminModel;
  void getAdminData() {
    FirebaseFirestore.instance.collection("customer_care_login").get().then((value) {
      adminModel = AdminModel.fromJson(value.docs.first.data());
      log(jsonEncode(value.docs.first.data()).toString());
      if (adminModel != null) {
        emailController.text = adminModel!.email ?? "";
        commissionPercentage.text = adminModel!.adminCommission ?? "";
        passwordController.text = adminModel!.password ?? "";

      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getAdminData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: backAppBar(title: 'Customer Care'.tr, context: context),
        body: SingleChildScrollView(
          child: Form(
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
                            padding: EdgeInsets.symmetric(horizontal: size.width * .04, vertical: size.height * .01)
                                .copyWith(bottom: 0),
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Email".tr,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                const SizedBox(height: 5),
                                MyTextField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your Email';
                                    }
                                    return null;
                                  },
                                  controller: emailController,
                                  hintText: 'Email'.tr,
                                  obscureText: false,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Password".tr,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                const SizedBox(height: 5),
                                MyTextField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your Password';
                                    }
                                    return null;
                                  },
                                  controller: passwordController,
                                  hintText: 'Password'.tr,
                                  obscureText: false,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 30),
                                MyButton(
                                  color: Colors.white,
                                  backgroundcolor: Colors.black,
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {
                                      addSettingToFirestore();
                                    }
                                  },
                                  text: widget.isEditMode ? 'Update Customer Care'.tr : 'Add Customer Care'.tr,
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).appPaddingForScreen)),
        ));
  }
}
