import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import 'model/customer_register_model.dart';

class AddCustomerUserScreen extends StatefulWidget {
  final bool isEditMode;
  final String? documentId;
  final String? userName;
  final String? email;
  final String? phonenumber;

  const AddCustomerUserScreen(
      {super.key,
      required this.isEditMode,
      this.documentId,
      this.userName,
      this.email,
      this.phonenumber});

  @override
  State<AddCustomerUserScreen> createState() => _AddCustomerUserScreenState();
}

class _AddCustomerUserScreenState extends State<AddCustomerUserScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void addUserToFirestore() {
    String userName = userNameController.text;
    String email = emailController.text;
    String mobileNumber = mobileNumberController.text;
    Timestamp currenttime = Timestamp.now();

    List<String> arrangeNumbers = [];
    String? userNumber = (userName ?? "");
    arrangeNumbers.clear();
    for (var i = 0; i < userNumber.length; i++) {
      arrangeNumbers.add(userNumber.substring(0, i + 1));
    }
    if (userName.isNotEmpty && email.isNotEmpty) {
      CustomerRegisterData customeruser = CustomerRegisterData(
          userName: userName,
          searchName: arrangeNumbers,
          mobileNumber: mobileNumber,
          email: email,
          deactivate: false,
          time: currenttime);
      if (widget.isEditMode) {
        FirebaseFirestore.instance
            .collection('customer_users')
            .doc(widget.documentId)
            .update(customeruser.toMap());
      } else {
        FirebaseFirestore.instance
            .collection('customer_users')
            .doc("+91$mobileNumber")
            .set(customeruser.toMap());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    userNameController.text = widget.userName ?? "";
    emailController.text = widget.email ?? "";
    mobileNumberController.text = widget.phonenumber ?? "";
    log(widget.phonenumber.toString());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xff3B5998),
        appBar: backAppBar(title: 'Add new Customer', context: context),
        body: Form(
            key: formKey,
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
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 25),
                                child: Text("userName",style: TextStyle(color: Colors.black),),
                              ),
                              const SizedBox(height: 5),
                              MyTextField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your userName';
                                  }
                                },
                                controller: userNameController,
                                hintText: 'userName',
                                obscureText: false,
                                color: Colors.white,
                              ),

                              const SizedBox(height: 10),
                              const Padding(
                                padding: EdgeInsets.only(left: 25),
                                child: Text("Email",style: TextStyle(color: Colors.black),),
                              ),
                              const SizedBox(height: 5),
                              MyTextField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter email';
                                  }
                                },
                                controller: emailController,
                                hintText: 'Email',
                                obscureText: false,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 10),
                              const Padding(
                                padding: EdgeInsets.only(left: 25),
                                child: Text("Mobile Number",style: TextStyle(color: Colors.black),),
                              ),
                              const SizedBox(height: 5),
                              MyTextField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your mobile number';
                                  }
                                },
                                controller: mobileNumberController,
                                keyboardtype: TextInputType.number,
                                length: 10,
                                hintText: 'Mobile Number',
                                obscureText: false,
                                color: Colors.white,
                              ),

                              const SizedBox(height: 10),

                              const SizedBox(
                                height: 30
                              ),

                              // sign in button
                              MyButton(
                                color: Colors.white,
                                backgroundcolor: Colors.black,
                                onTap: () {
                                  if (formKey.currentState!
                                      .validate()) {
                                    addUserToFirestore();
                                    userNameController.clear();
                                    emailController.clear();
                                    Get.back();
                                  }
                                },
                                text: widget.isEditMode
                                    ? 'Update User'
                                    : 'Add User',
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}
