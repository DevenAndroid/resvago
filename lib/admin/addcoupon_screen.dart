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

    List<String> arrangeNumbers = [];
    String? userNumber = (title ?? "");
    arrangeNumbers.clear();
    for (var i = 0; i < userNumber.length; i++) {
      arrangeNumbers.add(userNumber.substring(0, i + 1));
    }
    if (title.isNotEmpty && description.isNotEmpty) {
      CouponData user = CouponData(
          title: title,
          description: description,
          code: code,
          discount: discount,
          searchName: arrangeNumbers,
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
                    padding: EdgeInsets.symmetric(horizontal: size.width * .06, vertical: size.height * .06),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(right: 15),
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
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
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
                                borderRadius:
                                BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width * .04, vertical: size.height * .01)
                                  .copyWith(bottom: 0),
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  SizedBox(height: 50,),
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

                                   SizedBox(height: size.height * .18),

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
            )

        ));

  }
}
