import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import 'model/Pages_model.dart';

class AddPagesScreen extends StatefulWidget {
  final bool isEditMode;
  final String? documentId;
  final String? title;
  final String? longdescription;

  const AddPagesScreen({super.key, required this.isEditMode, this.documentId, this.title, this.longdescription});

  @override
  State<AddPagesScreen> createState() => _AddPagesScreenState();
}

class _AddPagesScreenState extends State<AddPagesScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController longdescriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void addUserToFirestore() {
    String title = titleController.text;
    String longdescription = longdescriptionController.text;
    Timestamp currenttime = Timestamp.now();
    if (title.isNotEmpty && longdescription.isNotEmpty) {
      PagesData pages = PagesData(title: title, longdescription: longdescription, deactivate: false,time: currenttime);
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
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Icon(
                    Icons.pages,
                    size: 100,
                    color: Color(0xff3B5998),
                  ),

                  const SizedBox(height: 75),

                  MyTextField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Title';
                      }
                    },
                    controller: titleController,
                    hintText: 'Title',
                    obscureText: false,
                    color: Color(0xff3B5998),
                  ),

                  const SizedBox(height: 10),

                  MyTextField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Long Description';
                      }
                    },
                    controller: longdescriptionController,
                    hintText: 'Long Description',
                    obscureText: false,
                    color: Color(0xff3B5998),
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  MyButton(
                    color: Colors.white,
                    backgroundcolor: Color(0xff3B5998),
                    onTap: () {
                      if(formKey.currentState!.validate()){
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
      ),
    );
  }
}
