import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../Firebase_service/firebase_service.dart';
import '../components/apptheme.dart';
import '../components/helper.dart';
import '../components/my_textfield.dart';
import 'model/wallet_model.dart';

class WalletScreen extends StatefulWidget {
  String uId;

  WalletScreen({super.key, required this.uId});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final List<String> moneyList = ["500", "800", "1000"];
  final TextEditingController addMoneyController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  double total = 0;
  double total1 = 0;
  double combinedTotal = 0; // Variable to store the sum

  @override
  void initState() {
    super.initState();
    getWithDrawData();
  }

  FirebaseService firebaseService = FirebaseService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<WithdrawMoneyModel>? withdrawModel;
  Future getWithDrawData() async {
    withdrawModel ??= [];
    withdrawModel!.clear();
    FirebaseFirestore.instance
        .collection('withDrawMoney')
        .where("userId", isEqualTo: widget.uId)
        .orderBy("time", descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        withdrawModel!.add(WithdrawMoneyModel.fromJson(gg));
      }
      setState(() {});
    });
  }

  Future<void> updateWithdrawStatus(String docId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('withDrawMoney').doc(docId).get();
      if (documentSnapshot.exists) {
        await FirebaseFirestore.instance.collection('withDrawMoney').doc(docId).update({
          "userId": widget.uId,
          "status": "Reject",
        });
        print("Withdrawal status updated successfully.");
      } else {
        print("Document with ID $docId does not exist.");
      }
    } catch (e) {
      print("Error updating withdrawal status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(total);
    }

    return Scaffold(
      appBar: backAppBar(
        title: "Payment Request".tr,
        context: context,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            surfaceTintColor: Colors.white,
            automaticallyImplyLeading: false,
            expandedHeight: 20.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Amount".tr,
                        style: GoogleFonts.poppins(color: const Color(0xFF3B5998), fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                      Text(
                        "Date".tr,
                        style: GoogleFonts.poppins(color: const Color(0xFF3B5998), fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                      Text(
                        "Status".tr,
                        style: GoogleFonts.poppins(color: const Color(0xFF3B5998), fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ],
                  ),
                  const Divider()
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                var walletItem = withdrawModel![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${walletItem.amount}",
                            style: GoogleFonts.poppins(color: const Color(0xFF454B5C), fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          Text(
                            DateFormat("dd-MM-yy hh:mm a").format(DateTime.parse(
                              DateTime.fromMillisecondsSinceEpoch(walletItem.time).toLocal().toString(),
                            )),
                            style: GoogleFonts.poppins(color: const Color(0xFF8C9BB2), fontWeight: FontWeight.w500, fontSize: 11),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (walletItem.status == "Processing") {
                                _showPopup1(docid: walletItem.docid, status: walletItem.status);
                              } else {
                                null;
                              }
                            },
                            child: Text(
                              walletItem.status.toString(),
                              style: GoogleFonts.poppins(
                                  color: walletItem.status == "Approve"
                                      ? Colors.green
                                      : walletItem.status == "Reject"
                                      ? Colors.red
                                      : const Color(0xFFFFB26B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.black12.withOpacity(0.09),
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                    ],
                  ),
                );
              },
              childCount: withdrawModel!.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
            ),
          ),
        ],
      ),
    );
  }

  chipList(title) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return ChoiceChip(
      padding: EdgeInsets.symmetric(horizontal: width * .005, vertical: height * .005),
      backgroundColor: AppTheme.backgroundcolor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide(color: Colors.grey.shade300)),
      label: Text("+\$${title}", style: TextStyle(color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.w500)),
      selected: false,
      onSelected: (value) {
        setState(() {
          addMoneyController.text = title;
          FocusManager.instance.primaryFocus!.unfocus();
        });
      },
    );
  }

  void _showPopup1({
    required docid,
    required status,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            surfaceTintColor: Colors.white,
            title: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Payment Request', style: TextStyle(fontWeight: FontWeight.w500)),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(40)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(
                            Icons.clear_rounded,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (status == "Processing") {
                          FirebaseFirestore.instance.collection('withDrawMoney').doc(docid).update({
                            "userId": widget.uId,
                            "status": "Reject",
                          }).then((value) {
                            getWithDrawData();
                            Navigator.of(context).pop();
                            setState(() {});
                          });
                        } else {
                          null;
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                          child: Center(
                              child: Text(
                            'Reject',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (status == "Processing") {
                          FirebaseFirestore.instance.collection('withDrawMoney').doc(docid).update({
                            "userId": widget.uId,
                            "status": "Approve",
                          }).then((value) {
                            showToast("Payment has been approved");
                            getWithDrawData();
                            Navigator.of(context).pop();
                            setState(() {});
                          });
                        } else {
                          null;
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                          child: Center(
                              child: Text(
                            'Approve',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ]));
      },
    );
  }
}
