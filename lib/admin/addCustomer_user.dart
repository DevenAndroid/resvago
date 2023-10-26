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
    // TODO: implement initState
    super.initState();
    userNameController.text = widget.userName ?? "";
    emailController.text = widget.email ?? "";
    mobileNumberController.text = widget.phonenumber ?? "";
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
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      MyTextField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter your userName';
                                          }
                                        },
                                        controller: userNameController,
                                        hintText: 'userName',
                                        obscureText: false,
                                        color: Color(0xff3B5998),
                                      ),

                                      const SizedBox(height: 10),

                                      MyTextField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter email';
                                          }
                                        },
                                        controller: emailController,
                                        hintText: 'Email',
                                        obscureText: false,
                                        color: Color(0xff3B5998),
                                      ),
                                      const SizedBox(height: 10),
                                      MyTextField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter your mobile number';
                                          }
                                        },
                                        controller: mobileNumberController,
                                        keyboardtype: TextInputType.number,
                                        hintText: 'Mobile Number',
                                        obscureText: false,
                                        color: Color(0xff3B5998),
                                      ),

                                      const SizedBox(height: 10),

                                      SizedBox(
                                        height: size.height * .35,
                                      ),

                                      // sign in button
                                      MyButton(
                                        color: Colors.white,
                                        backgroundcolor: Color(0xff3B5998),
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
                    ),
                  ),
                ],
              ),
            )));
  }
}
