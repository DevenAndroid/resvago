import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:resvago/admin/model/coupen_model.dart';
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void addCouponToFirestore() {
    String title = titleController.text;
    String description = descriptionController.text;
    String code = codeController.text;
    String discount = discountController.text;
    String validtilldate = validtilldateController.text;

    Timestamp currenttime = Timestamp.now();

    if (title.isNotEmpty && description.isNotEmpty) {
      CouponData user = CouponData(
          title: title,
          description: description,
          code: code,
          discount: discount,
          validtilldate: validtilldate,
          time: currenttime,
          deactivate: false);
      if (widget.isEditMode) {
        FirebaseFirestore.instance
            .collection('coupon')
            .doc(widget.documentId)
            .update(user.toMap());
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
                    Icons.card_giftcard,
                    size: 100,
                    color: Color(0xff3B5998),
                  ),

                  const SizedBox(height: 50),

                  const SizedBox(height: 25),

                  MyTextField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Title';
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
                        return 'Please enter Description';
                      }
                    },
                    controller: descriptionController,
                    hintText: 'Description',
                    obscureText: false,
                    color: Color(0xff3B5998),
                  ),
                  const SizedBox(height: 10),

                  MyTextField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Code';
                      }
                    },
                    controller: codeController,
                    hintText: 'Code',
                    obscureText: false,
                    color: Color(0xff3B5998),
                  ),
                  const SizedBox(height: 10),

                  MyTextField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Discount';
                      }
                    },
                    controller: discountController,
                    hintText: 'Discount',
                    obscureText: false,
                    color: Color(0xff3B5998),
                  ),
                  const SizedBox(height: 10),

                  MyTextField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Valid date';
                      }
                    },
                    controller: validtilldateController,
                    hintText: 'Valid Date',
                    obscureText: false,
                    color: Color(0xff3B5998),
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  MyButton(
                    color: Colors.white,
                    backgroundcolor: Color(0xff3B5998),
                    onTap: () {
                      if (formKey.currentState!.validate()) {
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
      ),
    );
  }
}
