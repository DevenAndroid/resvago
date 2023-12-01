import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:resvago/components/my_button.dart';
import 'package:resvago/components/my_textfield.dart';
import 'package:resvago/firebase_service/firebase_userSerivce.dart';
import '../components/helper.dart';
import '../firebase_service/firebase_service.dart';
import 'controller/logincontroller.dart';
import 'customeruser_list.dart';

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
  static var signupScreen = "/signupScreen";

  @override
  State<AddCustomerUserScreen> createState() => _AddCustomerUserScreenState();
}

class _AddCustomerUserScreenState extends State<AddCustomerUserScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final loginController = Get.put(LoginController());
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late GeoFlutterFire geo;
  String code = "+353";
  String verificationId = "";
  bool value = false;
  bool showValidation = false;
  String? uid;
  FirebaseService firebaseService = FirebaseService();
  FirebaseUserService firebaseUserService = FirebaseUserService();
  Future<void> addUserToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    if (!widget.isEditMode) {
      FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: "123456",
      ).then((UserCredential userCredential) {
         uid = userCredential.user!.uid;
        print("User UID: $uid");
        log(uid.toString());

      }).catchError((e) {
        print("Error creating user: $e");
      });
    }
    if (FirebaseAuth.instance.currentUser != null) {
      if(widget.isEditMode){
        CollectionReference collection = FirebaseFirestore.instance.collection('customer_users');
        var DocumentReference = collection.doc(widget.documentId);
        DocumentReference.update({
          "userName": userNameController.text,
          "email": emailController.text,
          "mobileNumber": phoneNumberController.text,
        }).then((value) {
          Get.to(const CustomeruserListScreen());
          Helper.hideLoader(loader);
        });
      }else{
        CollectionReference collection = FirebaseFirestore.instance.collection('customer_users');
        var DocumentReference = collection.doc(uid);
        DocumentReference.set({
          "userName": userNameController.text,
          "email": emailController.text,
          "docid": uid,
          "mobileNumber": phoneNumberController.text,
          "userID": phoneNumberController.text,
          "profile_image": "",
          "password": "123456",
          "deactivate": false,
        }).then((value) {
          Get.to(const CustomeruserListScreen());
          Helper.hideLoader(loader);
        });
      }

    }
  }

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
        .where('mobileNumber',
            isEqualTo: code + phoneNumberController.text.trim())
        .get();

    if (phoneResult.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Mobile Number already exits');
      return;
    }
    addUserToFirestore();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isEditMode == true) {
      userNameController.text = widget.userName!;
      emailController.text = widget.email!;
      phoneNumberController.text = widget.phonenumber!;
    }
  }

  @override
  Widget build(BuildContext context) {
    log(uid.toString());
    return Scaffold(
        appBar: backAppBar(
            title:
                widget.isEditMode ? 'Edit Customer User' : 'Add Customer User',
            context: context),
        body: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Create Account',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 26,
                          // fontFamily: 'poppins',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Your Name',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          RegisterTextFieldWidget(
                            controller: userNameController,
                            textInputAction: TextInputAction.next,
                            hint: 'Enter Your Name',
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: 'Please enter your name'),
                            ]).call,
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Enter Email',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          RegisterTextFieldWidget(
                              controller: emailController,
                              textInputAction: TextInputAction.next,
                              hint: 'Enter your Email',
                              keyboardType: TextInputType.text,
                              validator: MultiValidator([
                                EmailValidator(
                                    errorText: "Valid Email is required"),
                                RequiredValidator(
                                    errorText: "Email is required")
                              ]).call),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Enter Mobile number',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          widget.isEditMode
                              ? MyTextField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter phone number';
                                    }
                                  },
                                  controller: phoneNumberController,
                                  hintText: 'Enter Phone Number',
                                  keyboardtype: TextInputType.name,
                                  obscureText: false,
                                  realonly: true,
                                  color: Colors.white,
                                )
                              : IntlPhoneField(
                                  flagsButtonPadding: const EdgeInsets.all(8),
                                  dropdownIconPosition: IconPosition.trailing,
                                  cursorColor: Colors.black,
                                  dropdownIcon: const Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Colors.black,
                                  ),
                                  dropdownTextStyle:
                                      const TextStyle(color: Colors.black),
                                  style: const TextStyle(color: Colors.black),
                                  controller: phoneNumberController,
                                  decoration: const InputDecoration(
                                      hintStyle: TextStyle(color: Colors.black),
                                      labelText: 'Phone Number',
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black))),
                                  initialCountryCode: 'IE',
                                  onCountryChanged: (phone) {
                                    setState(() {
                                      code = "+${phone.dialCode}";
                                      log(code.toString());
                                    });
                                  },
                                  onChanged: (phone) {
                                    code = phone.countryCode.toString();
                                  },
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          MyButton(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                if (widget.isEditMode) addUserToFirestore();
                                if (!widget.isEditMode) checkEmailInFirestore();
                              }
                            },
                            text: 'Create Account',
                            color: Colors.white,
                            backgroundcolor: Colors.black,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
          ).appPadding,
        ));
  }
}
