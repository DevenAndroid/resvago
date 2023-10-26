import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resvago/admin/model/coupen_model.dart';
import 'package:resvago/admin/model/vendor_register_model.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import 'Couponlist_Screen.dart';

class AddCouponScreen extends StatefulWidget {
  final bool isEditMode;
  final String? documentId;
  final String? promocode;
  final String? description;
  final String? code;
  final String? discount;
  final String? startdate;
  final String? enddate;

  const AddCouponScreen({
    super.key,
    required this.isEditMode,
    this.documentId,
    this.promocode,
    this.description,
    this.discount,
    this.code,
    this.startdate,
    this.enddate,
  });

  @override
  State<AddCouponScreen> createState() => _AddCouponScreenState();
}

class _AddCouponScreenState extends State<AddCouponScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController startdateController = TextEditingController();
  TextEditingController enddateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void addCouponToFirestore() {
    String promocodename = titleController.text;
    String description = descriptionController.text;
    String code = codeController.text;
    String discount = discountController.text;
    String startdate = startdateController.text;
    String enddate = enddateController.text;
    Timestamp currentTime = Timestamp.now();

    List<String> arrangeNumbers = [];
    String? userNumber = (promocodename ?? "");
    arrangeNumbers.clear();
    for (var i = 0; i < userNumber.length; i++) {
      arrangeNumbers.add(userNumber.substring(0, i + 1));
    }

    CouponData user = CouponData(
        promoCodeName: promocodename,
        code: code,
        discount: discount,
        startDate: startdate,
        userID: userValue!.userID.toString(),
        userName: userValue!.restaurantName.toString(),
        endDate: enddate,
        time: currentTime,
        deactivate: false);
    print("object");
    if (widget.isEditMode) {
      FirebaseFirestore.instance
          .collection('Coupon_data')
          .doc(widget.documentId)
          .update(user.toMap());
    } else {
      FirebaseFirestore.instance
          .collection('Coupon_data')
          .doc()
          .set(user.toMap())
          .then((value) => Get.to(CouponListScreen(
                username: userValue!.restaurantName.toString(),
              )));
    }
  }

  bool isDescendingOrder = true;

  List<RegisterData>? userList;
  RegisterData? userValue;
  getVendorCategories() {
    FirebaseFirestore.instance.collection("vendor_users").get().then((value) {
      print(value.docs);
      for (var element in value.docs) {
        var gg = element.data();
        print(gg);
        userList ??= [];
        userList!.add(RegisterData.fromMap(gg));
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.promocode ?? "";
    descriptionController.text = widget.description ?? "";
    codeController.text = widget.code ?? "";
    discountController.text = widget.discount ?? "";
    startdateController.text = widget.startdate ?? "";
    enddateController.text = widget.enddate ?? "";
    getVendorCategories();
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
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * .06,
                        vertical: size.height * .06),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10)
                              .copyWith(right: 15),
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
                          "Add Coupons",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
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
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(25),
                                    topLeft: Radius.circular(25))),
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
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      if (userList != null)
                                        DropdownButtonFormField<dynamic>(
                                          focusColor: Colors.white,
                                          isExpanded: true,
                                          iconEnabledColor:
                                              const Color(0xff97949A),
                                          icon: const Icon(Icons
                                              .keyboard_arrow_down_rounded),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          hint: Text(
                                            "Select Restaurant Name".tr,
                                            style: const TextStyle(
                                                color: Color(0xff2A3B40),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w300),
                                            textAlign: TextAlign.justify,
                                          ),
                                          decoration: InputDecoration(
                                            focusColor: const Color(0xFF384953),
                                            hintStyle: GoogleFonts.poppins(
                                              color: const Color(0xFF384953),
                                              textStyle: GoogleFonts.poppins(
                                                color: const Color(0xFF384953),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300,
                                              ),
                                              fontSize: 14,
                                              // fontFamily: 'poppins',
                                              fontWeight: FontWeight.w300,
                                            ),
                                            filled: true,
                                            fillColor:
                                                Colors.white.withOpacity(.10),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 15),
                                            // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: const Color(0xFF384953)
                                                      .withOpacity(.24)),
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        const Color(0xFF384953)
                                                            .withOpacity(.24)),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(6.0))),
                                            errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red.shade800),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(6.0))),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        const Color(0xFF384953)
                                                            .withOpacity(.24),
                                                    width: 3.0),
                                                borderRadius:
                                                    BorderRadius.circular(6.0)),
                                          ),
                                          value: userValue,
                                          items: userList!.map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(
                                                items.restaurantName.toString(),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            userValue = newValue;
                                            setState(() {});
                                          },
                                          validator: (value) {
                                            if (userValue == null) {
                                              return 'Please select category';
                                            }
                                            return null;
                                          },
                                        )
                                      else
                                        const Center(
                                          child: Text("No Category Available"),
                                        ),
                                      const SizedBox(height: 10),
                                      MyTextField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter promocode';
                                          }
                                        },
                                        controller: titleController,
                                        hintText: 'PromoCode Name',
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
                                            return 'Please enter start date';
                                          }
                                        },
                                        controller: startdateController,
                                        hintText: 'Start Date',
                                        obscureText: false,
                                        color: Color(0xff3B5998),
                                      ),
                                      const SizedBox(height: 10),

                                      MyTextField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter end date';
                                          }
                                        },
                                        controller: enddateController,
                                        hintText: 'End Date',
                                        obscureText: false,
                                        color: Color(0xff3B5998),
                                      ),
                                      SizedBox(height: size.height * .1),

                                      // sign in button
                                      MyButton(
                                        color: Colors.white,
                                        backgroundcolor: Color(0xff3B5998),
                                        onTap: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            addCouponToFirestore();
                                            titleController.clear();
                                            codeController.clear();
                                            discountController.clear();
                                            enddateController.clear();
                                            startdateController.clear();
                                          }
                                        },
                                        text: widget.isEditMode
                                            ? 'Update Coupon'
                                            : 'Add Coupon',
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
            )));
  }
}
