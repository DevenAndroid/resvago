import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:resvago/admin/coupen_model.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';

class AddCouponScreen extends StatefulWidget {
  final bool isEditMode;
  final String? documentId;
  final String? title;
  final String? description;
  final String? code;
  final String? discount;
  final String? validtilldate;

  const AddCouponScreen({
    super.key,
    required this.isEditMode,
    this.documentId,
    this.title,
    this.description,
    this.discount,
    this.code,
    this.validtilldate,
  });



  @override
  State<AddCouponScreen> createState() => _AddCouponScreenState();
}

class _AddCouponScreenState extends State<AddCouponScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController validtilldateController = TextEditingController();

  void addCouponToFirestore() {
    String title = titleController.text;
    String description = descriptionController.text;
    String code = codeController.text;
    String discount = discountController.text;
    String validtilldate = validtilldateController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      CouponData user = CouponData(
          title: title,
          description: description,
          code: code,
          discount: discount,
          validtilldate: validtilldate,
          deactivate: false);
      if (widget.isEditMode) {
        FirebaseFirestore.instance.collection('coupon').doc(widget.documentId).update(user.toMap());
      } else {
        FirebaseFirestore.instance.collection('coupon').add(user.toMap());
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.title ?? "";
    descriptionController.text = widget.description ?? "";
    codeController.text = widget.code ?? "";
    discountController.text = widget.discount ?? "";
    validtilldateController.text = widget.validtilldate ?? "";
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
                  controller: descriptionController,
                  hintText: 'Description',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                MyTextField(
                  controller: codeController,
                  hintText: 'Code',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                MyTextField(
                  controller: discountController,
                  hintText: 'Discount',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                MyTextField(
                  controller: validtilldateController,
                  hintText: 'Valid Date',
                  obscureText: false,
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  onTap: () {
                    if (titleController.text.isEmpty &&
                        descriptionController.text.isEmpty &&
                        codeController.text.isEmpty &&
                        discountController.text.isEmpty) {
                      Fluttertoast.showToast(msg: 'Please enter Fields');
                    } else {
                      addCouponToFirestore();
                      titleController.clear();
                      descriptionController.clear();
                      codeController.clear();
                      discountController.clear();
                      Get.back();
                    }
                  },
                  text: widget.isEditMode ? 'Update Coupon' : 'Add Coupon',
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
