import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago/admin/adduser_screen.dart';

import '../components/my_button.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({Key? key}) : super(key: key);

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50,),
            MyButton(
              onTap: () {
                Get.to(const AddUserScreen());
              },
              text: 'Add User',
            ),
          ],
        ),
      ),
    );
  }
}
