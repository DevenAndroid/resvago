import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> addSettingToFirestore() async {
    FirebaseFirestore.instance
        .collection('admin_login')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'email': emailController.text}).then((value) => () {
              emailController.clear();
              showToast('Setting Updated');
            });
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
        backgroundColor: Color(0xff3B5998),
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
                                    "Email Id",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                MyTextField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your Email';
                                    }
                                  },
                                  controller: emailController,
                                  hintText: 'Email',
                                  obscureText: false,
                                  color: Colors.white,
                                ),

                                const SizedBox(
                                  height: 30,
                                ),

                                // sign in button
                                MyButton(
                                  color: Colors.white,
                                  backgroundcolor: Colors.black,
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {
                                      addSettingToFirestore();
                                    }
                                  },
                                  text: widget.isEditMode
                                      ? 'Update setting'
                                      : 'Add setting',
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
