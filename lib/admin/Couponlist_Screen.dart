import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago/admin/addcoupon_screen.dart';
import 'package:resvago/admin/model/coupen_model.dart';

class CouponListScreen extends StatefulWidget {
  const CouponListScreen({Key? key}) : super(key: key);

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff3B5998),
        title: Text(
          'Coupon List',
          style: TextStyle(color: Colors.white),
        ),
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios)),
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
                color: Colors.white,
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
                  color: Colors.white,
                ),
              )),
          IconButton(
            icon: Icon(Icons.search),
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
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Change the outline border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Change the outline border color when focused
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: getCouponFromFirestore(),
              builder: (BuildContext context, AsyncSnapshot<List<CouponData>> snapshot) {
                if (snapshot.hasData) {
                  log(snapshot.data.toString());
                  if (snapshot.data == null) {
                    return const Center(
                      child: Text("No Coupon Found"),
                    );
                  }
                  List<CouponData> users = snapshot.data ?? [];
                  final filteredUsers = filterUsers(users, searchQuery);
                  return filteredUsers.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredUsers.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = filteredUsers[index];
                            // if (item.deactivate) {
                            //   return SizedBox.shrink();
                            // }
                            return Container(
                              height: 90,
                              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(11),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                  child: ListTile(
                                      title: RichText(
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.end,
                                        textDirection: TextDirection.rtl,
                                        softWrap: true,
                                        maxLines: 1,
                                        textScaleFactor: 1,
                                        text: TextSpan(
                                          text: item.title.toString(),
                                          style: DefaultTextStyle.of(context).style,
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: item.deactivate ? "Deactivate" : "",
                                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                      leading: Container(height: 100, width: 100, child: Icon(Icons.person)),
                                      subtitle: Text(item.description),
                                      trailing: PopupMenuButton<int>(
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
                                                    title: item.title,
                                                    description: item.description,
                                                    discount: item.discount,
                                                    code: item.code,
                                                    validtilldate: item.validtilldate,
                                                  ));
                                                },
                                                child: const Text("Edit"),
                                              ),
                                              PopupMenuItem(
                                                value: 1,
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (ctx) => AlertDialog(
                                                      title: const Text("Delete Coupon"),
                                                      content:
                                                          const Text("Are you sure you want to delete this Coupon"),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(ctx).pop();
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors.red,
                                                                borderRadius: BorderRadius.circular(11)),
                                                            width: 70,
                                                            padding: const EdgeInsets.all(14),
                                                            child: const Center(
                                                                child: Text(
                                                              "Cancel",
                                                              style: TextStyle(color: Colors.white),
                                                            )),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            FirebaseFirestore.instance
                                                                .collection("coupon")
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
                                                                borderRadius: BorderRadius.circular(11)),
                                                            width: 70,
                                                            padding: const EdgeInsets.all(14),
                                                            child: const Center(
                                                                child: Text(
                                                              "okay",
                                                              style: TextStyle(color: Colors.white),
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
                                                value: 1,
                                                onTap: () {
                                                  FirebaseFirestore.instance
                                                      .collection('coupon')
                                                      .doc(item.docid)
                                                      .update({"deactivate": true});
                                                },
                                                child: Text(item.deactivate ? "Activate" : "Deactivate"),
                                              ),
                                            ];
                                          }))),
                            );
                          })
                      : const Center(
                          child: Text("No Coupon Found"),
                        );
                }
                return const Center(child: CircularProgressIndicator());
              },
            )
          ],
        ),
      ),
    );
  }
  List<CouponData> filterUsers(List<CouponData> users, String query) {
    if (query.isEmpty) {
      return users; // Return all users if the search query is empty
    } else {
      // Filter the users based on the search query
      return users.where((user) {
        if (user.title is String) {
          return user.title.toLowerCase().contains(query.toLowerCase());
        }
        return false;
      }).toList();
    }
  }
  Future<List<CouponData>> getCouponFromFirestore() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('coupon').orderBy('time', descending: isDescendingOrder).get();

    List<CouponData> coupon = [];
    try {
      for (var doc in querySnapshot.docs) {
        log(doc.data().toString());
        coupon.add(CouponData(
            title: doc.data()['title'],
            description: doc.data()['description'],
            code: doc.data()['code'],
            discount: doc.data()['discount'],
            validtilldate: doc.data()['validtilldate'],
            deactivate: doc.data()['deactivate'] ?? false,
            docid: doc.id));
      }
    } catch (e) {
      log(e.toString());
      throw Exception();
    }
    log(querySnapshot.docs.map((e) => e.data().toString()).toString());
    return coupon;
  }
}

