import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../components/helper.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import 'customeruser_list.dart';
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
  void checkEmailInFirestore() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('customer_users')
        .where('email', isEqualTo: emailController.text)
        .get();
    if (result.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Email already exits');
      return;
    }
    final QuerySnapshot phoneResult = await FirebaseFirestore.instance
        .collection('customer_users')
        .where('mobileNumber', isEqualTo: code + mobileNumberController.text)
        .get();
    if (phoneResult.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Mobile Number already exits');
      return;
    }
    addUserToFirestore();
  }

  void addUserToFirestore() {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
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
            .update(customeruser.toMap()).then((value) {
          Helper.hideLoader(loader);
          Get.to(const CustomeruserListScreen());
        });

      } else {
        FirebaseFirestore.instance
            .collection('customer_users')
            .doc(code + mobileNumber)
            .set(customeruser.toMap()).then((value) {
          Helper.hideLoader(loader);
          userNameController.clear();
          emailController.clear();
          Get.to(const CustomeruserListScreen());

        });

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
  String code = "+91";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: backAppBar(
            title: widget.isEditMode ? 'Edit Customer' : 'Add new Customer',
            context: context),
        body: Form(
            key: formKey,
            child: Padding(
              padding: kIsWeb ? const EdgeInsets.only(left: 250,right: 250) : EdgeInsets.zero,
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
                                    "userName",
                                    style: TextStyle(color: Colors.black),
                                  ),
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
                                  child: Text(
                                    "Email",
                                    style: TextStyle(color: Colors.black),
                                  ),
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
                                  child: Text(
                                    "Mobile Number",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                widget.isEditMode ?
                                MyTextField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter phone number';
                                    }
                                  },
                                  controller: mobileNumberController,
                                  hintText: 'Enter Phone Number',
                                  keyboardtype: TextInputType.name,
                                  obscureText: false,
                                  realonly: true,
                                  color: Colors.white,
                                ) : Padding(
                                  padding: const EdgeInsets.only(left: 17,right: 17),
                                  child: IntlPhoneField(
                                    cursorColor: Colors.black,
                                    dropdownIcon: const Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: Colors.black,
                                    ),
                                    dropdownTextStyle: const TextStyle(color: Colors.black),
                                    style: const TextStyle(color: Colors.black),
                                    flagsButtonPadding: const EdgeInsets.all(8),
                                    readOnly: widget.isEditMode ? true : false,
                                    dropdownIconPosition: IconPosition.trailing,
                                    controller: mobileNumberController,
                                    decoration: InputDecoration(
                                        hintStyle: GoogleFonts.poppins(
                                          color: const Color(0xFF384953),
                                          textStyle: GoogleFonts.poppins(
                                            color: const Color(0xFF384953),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          fontSize: 14,
                                          // fontFamily: 'poppins',
                                          fontWeight: FontWeight.w300,
                                        ),
                                        hintText: 'Phone Number',
                                        // labelStyle: TextStyle(color: Colors.black),
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(),
                                        ),
                                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF384953))),
                                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF384953)))),
                                    initialCountryCode: 'IN',
                                    keyboardType: TextInputType.number,
                                    onCountryChanged: (phone){
                                      setState(() {
                                        code = "+${phone.dialCode}";
                                        log(code.toString());
                                      });
                                    },
                                    onChanged: (phone) {
                                      // log("fhdfhdf");
                                      // setState(() {
                                      //   code = phone.countryCode.toString();
                                      //   log(code.toString());
                                      // });
                                    },
                                  ),
                                ),


                                const SizedBox(height: 10),

                                const SizedBox(height: 30),

                                // sign in button
                                MyButton(
                                  color: Colors.white,
                                  backgroundcolor: Colors.black,
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {
                                      if(widget.isEditMode)
                                        addUserToFirestore();
                                        if(!widget.isEditMode)
                                      checkEmailInFirestore();
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
              ),
            )));
  }
}
