import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:resvago/admin/resturent_model.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class AddResturentScreen extends StatefulWidget {
  final bool isEditMode;
  final String? documentId;
  final String? name;
  final String? description;


  const AddResturentScreen(
      {super.key,
        required this.isEditMode,
        this.documentId,
        this.name,
        this.description,});

  @override
  State<AddResturentScreen> createState() => _AddResturentScreenState();
}

class _AddResturentScreenState extends State<AddResturentScreen> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  void addresturentToFirestore() {
    String name = nameController.text;
    String description = descriptionController.text;

    if (name.isNotEmpty && description.isNotEmpty) {
      ResturentData resturent = ResturentData(
          name: name,
          description: description,
          deactivate: false);
      if (widget.isEditMode) {
        FirebaseFirestore.instance
            .collection('resturent')
            .doc(widget.documentId)
            .update(resturent.toMap());
      } else {
        FirebaseFirestore.instance.collection('resturent').add(resturent.toMap());
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.name ?? "";
    descriptionController.text = widget.description ?? "";

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
                  controller: descriptionController,
                  hintText: 'Description',
                  obscureText: false,
                ),
                const SizedBox(height: 10),


                // sign in button
                MyButton(
                  onTap: () {
                    if (nameController.text.isEmpty &&
                        descriptionController.text.isEmpty){
                      Fluttertoast.showToast(msg: 'Please enter Fields');
                    }else{
                      addresturentToFirestore();
                      nameController.clear();
                      descriptionController.clear();
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
