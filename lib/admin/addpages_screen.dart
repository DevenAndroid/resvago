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

  const AddPagesScreen(
      {super.key,
      required this.isEditMode,
      this.documentId,
      this.title,
      this.longdescription});

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

    List<String> arrangeNumbers = [];
    String? userNumber = (title ?? "");
    arrangeNumbers.clear();
    for (var i = 0; i < userNumber.length; i++) {
      arrangeNumbers.add(userNumber.substring(0, i + 1));
    }
    if (title.isNotEmpty && longdescription.isNotEmpty) {
      PagesData pages = PagesData(
          title: title,
          searchName: arrangeNumbers,
          longdescription: longdescription,
          deactivate: false,
          time: currenttime);
      if (widget.isEditMode) {
        FirebaseFirestore.instance
            .collection('Pages')
            .doc(widget.documentId)
            .update(pages.toMap());
      } else {
        FirebaseFirestore.instance.collection('Pages').add(pages.toMap());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title ?? "";
    longdescriptionController.text = widget.longdescription ?? "";
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: backAppBar(title: 'Add pages', context: context),
        backgroundColor: Color(0xff3B5998),
        body: Form(
            key: formKey,
            child: SizedBox(
              height: size.height,
              width: size.width,
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
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Text("Title",style: TextStyle(color: Colors.black),),
                                ),
                                const SizedBox(height: 5),
                                MyTextField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your Title';
                                    }
                                  },
                                  controller: titleController,
                                  hintText: 'Title',
                                  obscureText: false,
                                  color: Colors.white,
                                ),

                                const SizedBox(height: 10),
                                const Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Text("Long Description",style: TextStyle(color: Colors.black),),
                                ),
                                const SizedBox(height: 5),
                                MyTextField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter Long Description';
                                    }
                                  },
                                  controller: longdescriptionController,
                                  hintText: 'Long Description',
                                  obscureText: false,
                                  maxLines: 5,
                                  minLines: 5,
                                  color: Colors.white,
                                ),

                                SizedBox(
                                  height: size.height * .35,
                                ),

                                // sign in button
                                MyButton(
                                  color: Colors.white,
                                  backgroundcolor: Colors.black,
                                  onTap: () {
                                    if (formKey.currentState!
                                        .validate()) {
                                      addUserToFirestore();
                                      titleController.clear();
                                      longdescriptionController.clear();
                                      Get.back();
                                    }
                                  },
                                  text: widget.isEditMode
                                      ? 'Update Pages'
                                      : 'Add Pages',
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
