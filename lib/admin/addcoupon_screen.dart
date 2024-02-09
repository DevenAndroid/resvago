import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago/admin/model/coupen_model.dart';
import 'package:resvago/admin/model/vendor_register_model.dart';
import 'package:resvago/components/helper.dart';
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
  final String? maxDiscount;
  final String? resturentName;

  AddCouponScreen({
    super.key,
    required this.isEditMode,
    this.documentId,
    this.promocode,
    this.description,
    this.discount,
    this.code,
    this.startdate,
    this.enddate,
    this.maxDiscount,
    this.resturentName,
  });

  @override
  State<AddCouponScreen> createState() => _AddCouponScreenState();
}

class _AddCouponScreenState extends State<AddCouponScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController startdateController = TextEditingController();
  TextEditingController enddateController = TextEditingController();
  TextEditingController maxDiscountController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DateTime? selectedStartDateTime;
  DateTime? selectedEndDateTIme;
  final DateFormat selectedDateFormat = DateFormat("dd-MMM-yyyy");
  pickDate({required Function(DateTime gg) onPick, DateTime? initialDate, DateTime? firstDate, DateTime? lastDate}) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate ?? DateTime.now(),
        firstDate: firstDate ?? DateTime.now(),
        lastDate: lastDate ?? DateTime(2101),
        initialEntryMode: DatePickerEntryMode.calendarOnly);
    if (pickedDate == null) return;
    onPick(pickedDate);
    // updateValues();
  }

  void addCouponToFirestore() {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    String promocodename = titleController.text;
    String code = codeController.text;
    String maxDiscount = maxDiscountController.text;
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
        maxDiscount: maxDiscount,
        userID: userValue!.userID.toString(),
        userName: userValue!.restaurantName.toString(),
        endDate: enddate,
        time: currentTime,
        deactivate: false);
    if (widget.isEditMode) {
      FirebaseFirestore.instance.collection('Coupon_data').doc(widget.documentId).update(user.toMap()).then((value) async {
        showToast('Coupon Updated');
        Helper.hideLoader(loader);
        Get.back();
      });
    } else {
      FirebaseFirestore.instance.collection('Coupon_data').doc().set(user.toMap()).then((value) async {
        showToast('Coupon Added');
        Helper.hideLoader(loader);
        Get.back();
      });
    }
  }

  bool isDescendingOrder = true;

  List<RegisterData>? userList;
  RegisterData? userValue;
  getVendorCategories() {
    FirebaseFirestore.instance.collection("vendor_users").get().then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        userList ??= [];
        userList!.add(RegisterData.fromMap(gg));
      }
      for (var element in userList!) {
        if (element.restaurantName == widget.resturentName) {
          userValue = element;
        }
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.promocode ?? "";
    codeController.text = widget.code ?? "";
    discountController.text = widget.discount ?? "";
    startdateController.text = widget.startdate ?? "";
    enddateController.text = widget.enddate ?? "";
    maxDiscountController.text = widget.maxDiscount ?? "";
    getVendorCategories();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: backAppBar(title: widget.isEditMode ? 'Edit Coupon'.tr : 'Add Coupon'.tr, context: context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                  key: formKey,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * .04, vertical: size.height * .01).copyWith(bottom: 0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "Restaurant Name".tr,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 5),
                        if (userList != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 0, right: 0),
                            child: DropdownButtonFormField<dynamic>(
                              focusColor: Colors.white,
                              isExpanded: true,
                              iconEnabledColor: const Color(0xff97949A),
                              icon: const Icon(Icons.keyboard_arrow_down_rounded),
                              borderRadius: BorderRadius.circular(10),
                              hint: Text(
                                "Select Restaurant Name".tr,
                                style: const TextStyle(color: Color(0xff2A3B40), fontSize: 13, fontWeight: FontWeight.w300),
                                textAlign: TextAlign.justify,
                              ),
                              decoration: InputDecoration(
                                focusColor: const Color(0xFF384953),
                                hintStyle: GoogleFonts.poppins(color: const Color(0xFF384953),
                                  textStyle: GoogleFonts.poppins(color: const Color(0xFF384953),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  fontSize: 14,
                                  // fontFamily: 'poppins',
                                  fontWeight: FontWeight.w300,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(.10),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.all(Radius.circular(6.0))),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red.shade800),
                                    borderRadius: const BorderRadius.all(Radius.circular(6.0))),
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.black, width: 3.0),
                                    borderRadius: BorderRadius.circular(6.0)),
                              ),
                              value: userValue,
                              items: userList!.map((items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(
                                    items.restaurantName.toString(),
                                    style: const TextStyle(color: Colors.black, fontSize: 15),
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
                            ),
                          )
                        else
                          const Center(
                            child: Text("No Category Available"),
                          ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "PromoCode Name".tr,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 5),
                        MyTextField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter promocode';
                            }
                            return null;
                          },
                          controller: titleController,
                          hintText: 'PromoCode Name'.tr,
                          obscureText: false,
                          color: Colors.white,
                        ),

                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "Code".tr,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 5),
                        MyTextField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Code';
                            }
                            return null;
                          },
                          controller: codeController,
                          hintText: 'Code'.tr,
                          obscureText: false,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "Discount".tr,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 5),
                        MyTextField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Discount';
                            }
                            return null;
                          },
                          controller: discountController,
                          keyboardtype: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          hintText: 'Discount'.tr,
                          obscureText: false,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "Max Discount".tr,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 5),
                        MyTextField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Max Discount';
                            }
                            return null;
                          },
                          controller: maxDiscountController,
                          hintText: 'Max Discount'.tr,
                          keyboardtype: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          obscureText: false,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "Start Date".tr,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 5),
                        MyTextField(
                          realonly: true,
                          controller: startdateController,
                          ontap: () {
                            pickDate(
                                onPick: (DateTime gg) {
                                  startdateController.text = selectedDateFormat.format(gg);
                                  selectedStartDateTime = gg;
                                },
                                initialDate: selectedStartDateTime,
                                lastDate: selectedEndDateTIme);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter end date';
                            }
                            return null;
                          },
                          hintText: startdateController.text.isEmpty ? 'Select Start Date' : startdateController.text,
                          obscureText: false,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "End Date".tr,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 5),
                        MyTextField(
                          realonly: true,
                          controller: enddateController,
                          ontap: () {
                            pickDate(
                                onPick: (DateTime gg) {
                                  enddateController.text = selectedDateFormat.format(gg);
                                  selectedEndDateTIme = gg;
                                },
                                initialDate: selectedEndDateTIme ?? selectedStartDateTime,
                                firstDate: selectedStartDateTime);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter end date';
                            }
                            return null;
                          },
                          hintText: enddateController.text.isEmpty ? 'Select end Date'.tr : enddateController.text,
                          obscureText: false,
                          color: Colors.white,
                        ),

                        const SizedBox(height: 30),

                        // sign in button
                        MyButton(
                          color: Colors.white,
                          backgroundcolor: Colors.black,
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              addCouponToFirestore();
                              titleController.clear();
                              codeController.clear();
                              discountController.clear();
                              enddateController.clear();
                              startdateController.clear();
                              maxDiscountController.clear();
                            }
                          },
                          text: widget.isEditMode ? 'Update Coupon'.tr : 'Add Coupon'.tr,
                        ),
                      ]),
                    ),
                  ).appPaddingForScreen),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }
}
