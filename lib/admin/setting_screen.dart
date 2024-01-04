import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:resvago/components/helper.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';

class settingScreen extends StatefulWidget {
  final bool isEditMode;
  final String? documentId;
  final String? email;

  const settingScreen({
    super.key,
    required this.isEditMode,
    this.documentId,
    this.email,
  });

  @override
  State<settingScreen> createState() => _settingScreenState();
}

class _settingScreenState extends State<settingScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController commissionPercentage = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> addSettingToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      await FirebaseFirestore.instance.collection('admin_login').doc(FirebaseAuth.instance.currentUser!.uid).set({
        'email': emailController.text,
        'Password': passwordController.text,
        "admin_commission": commissionPercentage.text.trim(),
        "UserId": FirebaseAuth.instance.currentUser!.uid
      });
      Helper.hideLoader(loader);
      emailController.clear();
      passwordController.clear();
      commissionPercentage.clear();
      showToast('Setting Updated');
    } catch (error) {
      print('Error updating settings: $error');
      Helper.hideLoader(loader);
      showToast('Failed to update settings');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: backAppBar(title: 'Setting', context: context),
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
                                const Text(
                                  "Email Id",
                                  style: TextStyle(color: Colors.black),
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
                                  hintText: 'Email',
                                  obscureText: false,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Password",
                                  style: TextStyle(color: Colors.black),
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
                                  hintText: 'Password',
                                  obscureText: false,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Admin Commission(%)",
                                  style: TextStyle(color: Colors.black),
                                ),
                                const SizedBox(height: 5),
                                MyTextField(
                                  keyboardtype: TextInputType.number,
                                  validator: (v) {
                                    if (v != null && v.trim().isNotEmpty && (double.tryParse(v.toString()) ?? 0) > 100) {
                                      return "Commission % should be less than or equal to 100";
                                    }
                                    return null;
                                  },
                                  controller: commissionPercentage,
                                  hintText: 'Commission',
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
                                  text: widget.isEditMode ? 'Update setting' : 'Add setting',
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
