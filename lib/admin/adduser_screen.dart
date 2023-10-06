import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:resvago/admin/user_model.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

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
      UserData user = UserData(name: name, email: email, password: password, phoneNumber: phoneNumber,);
      FirebaseFirestore.instance.collection('users').add(user.toMap());
    }
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
                    addUserToFirestore();
                    nameController.clear();
                    passwordController.clear();
                    emailController.clear();
                    phoneNumberController.clear();
                  },
                  text: 'Add User Data',
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
