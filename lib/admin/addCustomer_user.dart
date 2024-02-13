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
import '../components/apptheme.dart';
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
  final String? code;
  final String? country;
  const AddCustomerUserScreen(
      {super.key,
      required this.isEditMode,
      this.documentId,
      this.userName,
      this.email,
      this.phonenumber,
      this.code,
      this.country});
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
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool passwordSecure = true;
  bool confirmPasswordSecure = true;
  final _formKey = GlobalKey<FormState>();
  late GeoFlutterFire geo;
  String code = "+353";
  String country = "IE";
  int kk = 0;
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
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      )
          .then((value) {
        uid = value.user!.uid;
        print("User UID: $uid");
        log(uid.toString());
        if (FirebaseAuth.instance.currentUser != null) {
          CollectionReference collection = FirebaseFirestore.instance.collection('customer_users');
          var DocumentReference = collection.doc(uid);
          DocumentReference.set({
            "userName": userNameController.text,
            "email": emailController.text,
            "docid": uid,
            "password": passwordController.text,
            "deactivate": false,
            "time": DateTime.now(),
            "verified":false
          }).then((value) {
            log("fghgfkjhgjfk"+uid.toString());
            Get.back();
            FirebaseFirestore.instance.collection("send_mail").add({
              "to": emailController.text.trim(),
              "message": {
                "subject": "This is a otp email",
                "html": "Your account has been created",
                "text": "asdfgwefddfgwefwn",
              }
            });
            Helper.hideLoader(loader);
          });
        }
      }).catchError((e) {
        print("Error creating user: $e");
      });
    }
  }

  void checkEmailInFirestore() async {
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('customer_users').where('email', isEqualTo: emailController.text).get();

    if (result.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Email already exits');
      return;
    }
    final QuerySnapshot result1 =
    await FirebaseFirestore.instance.collection('vendor_users').where('email', isEqualTo: emailController.text).get();
    if (result1.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Email already used in vendor please use another account');
      return;
    }
    addUserToFirestore();
  }

  getData() {
    if (widget.isEditMode == true) {
      kk++;
      setState(() {
        userNameController.text = widget.userName!;
        emailController.text = widget.email!;
        phoneNumberController.text = widget.phonenumber ?? "";
        code = widget.code ?? "";
        country = widget.country ?? "";
        log(code);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    log(uid.toString());
    return Scaffold(
        appBar: backAppBar(title: widget.isEditMode ? 'Edit Customer' : 'Add Customer'.tr, context: context),
        body: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Create Account'.tr,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 26,
                      // fontFamily: 'poppins',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter Your Name'.tr,
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
                        hint: 'Enter Your Name'.tr,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Please enter your name'),
                        ]).call,
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Enter Email'.tr,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      RegisterTextFieldWidget(
                          controller: emailController,
                          textInputAction: TextInputAction.next,
                          hint: 'Enter your Email'.tr,
                          keyboardType: TextInputType.text,
                          validator: MultiValidator([
                            EmailValidator(errorText: "Valid Email is required"),
                            RequiredValidator(errorText: "Email is required")
                          ]).call),
                      const SizedBox(
                        height: 10,
                      ),
                      if (widget.isEditMode == false)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Password".tr.tr,
                              style: const TextStyle(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            RegisterTextFieldWidget(
                              controller: passwordController,
                              // length: 10,
                              obscureText: passwordSecure,
                              suffix: GestureDetector(
                                  onTap: () {
                                    passwordSecure = !passwordSecure;
                                    setState(() {});
                                  },
                                  child: Icon(
                                    passwordSecure ? Icons.visibility_off : Icons.visibility,
                                    size: 20,
                                    color: Colors.black,
                                  )),
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'Please enter your password'),
                                MinLengthValidator(8,
                                    errorText: 'Password must be at least 8 characters, with 1 special character & 1 numerical'),
                                PatternValidator(r"(?=.*\W)(?=.*?[#?!@$%^&*-])(?=.*[0-9])",
                                    errorText: "Password must be at least with 1 special character & 1 numerical"),
                              ]).call,
                              keyboardType: TextInputType.emailAddress,
                              // textInputAction: TextInputAction.next,
                              hint: 'Password'.tr,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Confirm Password".tr,
                              style: const TextStyle(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            RegisterTextFieldWidget(
                              controller: confirmPasswordController,
                              // length: 10,
                              obscureText: confirmPasswordSecure,
                              suffix: GestureDetector(
                                  onTap: () {
                                    confirmPasswordSecure = !confirmPasswordSecure;
                                    setState(() {});
                                  },
                                  child: Icon(
                                    confirmPasswordSecure ? Icons.visibility_off : Icons.visibility,
                                    size: 20,
                                    color: Colors.black,
                                  )),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your confirm password';
                                }
                                if (value.toString() == passwordController.text) {
                                  return null;
                                }
                                return "Confirm password not matching with password";
                              },
                              keyboardType: TextInputType.emailAddress,
                              // textInputAction: TextInputAction.next,
                              hint: 'Confirm password'.tr,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      if (widget.isEditMode)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Enter Mobile number'.tr,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            IntlPhoneField(
                              key: ValueKey(kk),
                              flagsButtonPadding: const EdgeInsets.all(8),
                              dropdownIconPosition: IconPosition.trailing,
                              cursorColor: Colors.black,
                              dropdownIcon: const Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Colors.black,
                              ),
                              dropdownTextStyle: const TextStyle(color: Colors.black),
                              style: const TextStyle(color: Colors.black),
                              controller: phoneNumberController,
                              decoration:  InputDecoration(
                                  hintStyle: TextStyle(color: Colors.black),
                                  labelText: 'Phone Number'.tr,
                                  labelStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                  ),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))),
                              initialCountryCode: country,
                              onCountryChanged: (phone) {
                                setState(() {
                                  code = "+${phone.dialCode}";
                                  country = phone.code;
                                  log(code.toString());
                                  log(country.toString());
                                });
                              },
                              onChanged: (phone) {
                                code = phone.countryCode.toString();
                              },
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            if (widget.isEditMode) addUserToFirestore();
                            if (!widget.isEditMode) checkEmailInFirestore();
                          }
                        },
                        text: 'Create Account'.tr,
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
          ).appPaddingForScreen,
        ));
  }
}
