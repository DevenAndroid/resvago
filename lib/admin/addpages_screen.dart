import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:resvago/admin/Pages_model.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';

class AddPagesScreen extends StatefulWidget {
  final bool isEditMode;
  final String? documentId;
  final String? title;
  final String? longdescription;


  const AddPagesScreen(
      {super.key, required this.isEditMode, this.documentId, this.title, this.longdescription});

  @override
  State<AddPagesScreen> createState() => _AddPagesScreenState();
}

class _AddPagesScreenState extends State<AddPagesScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController longdescriptionController = TextEditingController();


  void addUserToFirestore() {
    String title = titleController.text;
    String longdescription = longdescriptionController.text;

    if (title.isNotEmpty && longdescription.isNotEmpty) {
      PagesData pages =
          PagesData(title: title, longdescription: longdescription, deactivate: false);
      if (widget.isEditMode) {
        FirebaseFirestore.instance.collection('Pages').doc(widget.documentId).update(pages.toMap());
      } else {
        FirebaseFirestore.instance.collection('Pages').add(pages.toMap());
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.title ?? "";
    longdescriptionController.text = widget.longdescription ?? "";
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
                  controller: titleController,
                  hintText: 'Title',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: longdescriptionController,
                  hintText: 'Long Description',
                  obscureText: false,
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  onTap: () {
                    if (titleController.text.isEmpty &&
                        longdescriptionController.text.isEmpty) {
                      Fluttertoast.showToast(msg: 'Please enter Fields');
                    } else {
                      addUserToFirestore();
                      titleController.clear();
                      longdescriptionController.clear();
                      Get.back();
                    }
                  },
                  text: widget.isEditMode ? 'Update Pages' : 'Add Pages',
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