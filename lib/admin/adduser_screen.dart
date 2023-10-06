import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:resvago/admin/user_model.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class AddUserScreen extends StatefulWidget {
  final bool isEditMode;
  final String? documentId;
  final String? name;
  final String? email;
  final String? password;
  final String? phonenumber;

  const AddUserScreen(
      {super.key,
      required this.isEditMode,
      this.documentId,
      this.name,
      this.email,
      this.password,
      this.phonenumber});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  void addUserToFirestore() {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String phoneNumber = phoneNumberController.text;

    if (name.isNotEmpty && email.isNotEmpty) {
      UserData user = UserData(
          name: name,
          email: email,
          password: password,
          phoneNumber: phoneNumber,
          deactivate: false);
      if (widget.isEditMode) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.documentId)
            .update(user.toMap());
      } else {
        FirebaseFirestore.instance.collection('users').add(user.toMap());
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.name ?? "";
    emailController.text = widget.email ?? "";
    passwordController.text = widget.password ?? "";
    phoneNumberController.text = widget.phonenumber ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.person,
                  size: 100,
                ),

                const SizedBox(height: 50),
                Text(
                  'Fill All The \'Fields',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                MyTextField(
                  controller: nameController,
                  hintText: 'Name',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                MyTextField(
                  controller: phoneNumberController,
                  hintText: 'Phone Number',
                  obscureText: false,
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  onTap: () {
                    if (nameController.text.isEmpty &&
                        emailController.text.isEmpty &&
                        passwordController.text.isEmpty &&
                        phoneNumberController.text.isEmpty){
                      Fluttertoast.showToast(msg: 'Please enter Fields');
                    }else{
                      addUserToFirestore();
                      nameController.clear();
                      passwordController.clear();
                      emailController.clear();
                      phoneNumberController.clear();
                      Get.back();
                    }

                  },
                  text: widget.isEditMode ? 'Update user' : 'Add User',
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
