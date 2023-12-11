import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:resvago/admin/addcoupon_screen.dart';
import 'package:resvago/admin/model/coupen_model.dart';
import 'package:resvago/components/helper.dart';

import 'model/vendor_register_model.dart';

class CouponListScreen extends StatefulWidget {
  String? username;
  CouponListScreen({
    super.key,
    this.username,
  });

  @override
  State<CouponListScreen> createState() => _CouponListScreenState();
}

class _CouponListScreenState extends State<CouponListScreen> {
  bool userDeactivate = false;
  String searchQuery = '';
  bool isTextFieldVisible = false;
  bool isDescendingOrder = true;
  void toggleTextFieldVisibility() {
    setState(() {
      isTextFieldVisible = !isTextFieldVisible;
    });
  }

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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 10,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text(
            'Coupon List',
            style: TextStyle(
                color: Color(0xff423E5E), fontWeight: FontWeight.bold),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(15),
            child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: SvgPicture.asset('assets/images/arrowback.svg')),
          ),
          actions: [
            InkWell(
              onTap: () {
                setState(() {
                  isDescendingOrder = !isDescendingOrder;
                });
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.filter_list,
                  size: 30,
                  color: Color(0xff3B5998),
                ),
              ),
            ),
            GestureDetector(
                onTap: () {
                  Get.to(const AddCouponScreen(
                    isEditMode: false,
                  ));
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 0),
                  child: Icon(
                    Icons.add_circle_outline,
                    size: 30,
                    color: Color(0xff3B5998),
                  ),
                )),
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Color(0xff3B5998),
              ),
              onPressed: toggleTextFieldVisibility,
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(isTextFieldVisible ? 60.0 : 0.0),
            child: Visibility(
              visible: isTextFieldVisible,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.black), // Change the outline border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .black), // Change the outline border color when focused
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        body: StreamBuilder<List<CouponData>>(
          stream: getCouponStream(),
          builder:
              (BuildContext context, AsyncSnapshot<List<CouponData>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No Coupon Found"));
            } else {
              List<CouponData>? users = snapshot.data;
              final filteredUsers = filterUsers(users!, searchQuery);

              return filteredUsers.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredUsers.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = filteredUsers[index];
                        log(item.promoCodeName.toString());
                        // if (item.deactivate) {
                        //   return SizedBox.shrink();
                        // }
                        return Container(
                          height: 90,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(11),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Image.asset(
                                        'assets/images/couponimage.png'),
                                  )),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item.promoCodeName.toString(),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      item.code,
                                      style: const TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${item.discount.toString()}%",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                              item.deactivate
                                  ? Image.asset(
                                      'assets/images/deactivate.png',
                                      height: 20,
                                      width: 20,
                                    )
                                  : const SizedBox(),
                              Spacer(),
                              PopupMenuButton<int>(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.black,
                                  ),
                                  color: Colors.white,
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        value: 1,
                                        onTap: () {
                                          Get.to(AddCouponScreen(
                                            isEditMode: true,
                                            documentId: item.docid,
                                            promocode: item.promoCodeName,
                                            discount: item.discount,
                                            code: item.code,
                                            startdate: item.startDate,
                                            maxDiscount: item.maxDiscount,
                                            enddate: item.endDate,
                                            resturentName: item.userName,
                                          ));
                                        },
                                        child: const Text("Edit"),
                                      ),
                                      PopupMenuItem(
                                        value: 2,
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title:
                                                  const Text("Delete Coupon"),
                                              content: const Text(
                                                  "Are you sure you want to delete this Coupon"),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(11)),
                                                    width: 100,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            14),
                                                    child: const Center(
                                                        child: Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            "Coupon_data")
                                                        .doc(item.docid)
                                                        .delete()
                                                        .then((value) {
                                                      setState(() {});
                                                    });
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(11)),
                                                    width: 100,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            14),
                                                    child: const Center(
                                                        child: Text(
                                                      "okay",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: const Text("Delete"),
                                      ),
                                      PopupMenuItem(
                                        value: 3,
                                        onTap: () {
                                          item.deactivate
                                              ? FirebaseFirestore.instance
                                                  .collection('Coupon_data')
                                                  .doc(item.docid)
                                                  .update({"deactivate": false})
                                              : FirebaseFirestore.instance
                                                  .collection('Coupon_data')
                                                  .doc(item.docid)
                                                  .update({"deactivate": true});
                                          setState(() {});
                                        },
                                        child: Text(item.deactivate
                                            ? "Activate"
                                            : "Deactivate"),
                                      ),
                                    ];
                                  }),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        ).appPaddingForScreen;
                      })
                  : const Center(
                      child: Text("No Coupon Found"),
                    );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }

  List<CouponData> filterUsers(List<CouponData> users, String query) {
    if (query.isEmpty) {
      return users; // Return all users if the search query is empty
    } else {
      // Filter the users based on the search query
      return users.where((user) {
        if (user.promoCodeName is String) {
          return user.promoCodeName.toLowerCase().contains(query.toLowerCase());
        }
        return false;
      }).toList();
    }
  }

  Stream<List<CouponData>> getCouponStream() {
    return FirebaseFirestore.instance
        .collection('Coupon_data')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CouponData(
                  code: doc.data()['code'],
                  discount: doc.data()['discount'],
                  docid: doc.id,
                  userValue: doc.data()['userValue'],
                  userName: doc.data()['userName'],
                  deactivate: doc.data()['deactivate'],
                  promoCodeName: doc.data()['promoCodeName'],
                  startDate: doc.data()['startDate'],
                  maxDiscount: doc.data()['maxDiscount'],
                  endDate: doc.data()['endDate'],
                ))
            .toList());
  }
}
