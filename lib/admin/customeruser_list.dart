import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:resvago/admin/addCustomer_user.dart';
import 'package:resvago/components/helper.dart';
import 'controller/profil_controller.dart';
import 'edit_customer.dart';
import 'model/customer_register_model.dart';

class CustomeruserListScreen extends StatefulWidget {
  const CustomeruserListScreen({Key? key}) : super(key: key);

  @override
  State<CustomeruserListScreen> createState() => _CustomeruserListScreenState();
}

class _CustomeruserListScreenState extends State<CustomeruserListScreen> {
  final controller = Get.put(ProfileController());
  bool userDeactivate = false;
  String searchQuery = '';
  bool isTextFieldVisible = false;
  bool isDescendingOrder = false;
  void toggleTextFieldVisibility() {
    setState(() {
      isTextFieldVisible = !isTextFieldVisible;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getAdminData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title:  Text(
          'Customer Users List'.tr,
          style: TextStyle(color: Color(0xFF423E5E), fontSize: 20, fontWeight: FontWeight.bold),
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
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                // isDescendingOrder = !isDescendingOrder;
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
                Get.to(const AddCustomerUserScreen(
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
          GestureDetector(
            onTap: (){
              isDescendingOrder = !isDescendingOrder;
              setState(() {

              });
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.search,
                size: 30,
                color: Color(0xff3B5998),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if(isDescendingOrder == true)
            Padding(
              key: ValueKey(isDescendingOrder),
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // Change the outline border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), // Change the outline border color when focused
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            StreamBuilder<List<CustomerRegisterData>>(
              stream: getUsersStreamFromFirestore(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator()); // Show a loading indicator while data is being fetched
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<CustomerRegisterData> users = snapshot.data ?? [];
                  final filteredUsers = filterUsers(users, searchQuery); // Apply the search filter

                  return filteredUsers.isNotEmpty
                      ? ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: filteredUsers.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = filteredUsers[index];
                            log("dydfyhf${item.code}");
                            return Container(
                              height: 90,
                              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(11),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Center(
                                  child: ListTile(
                                      contentPadding: const EdgeInsets.only(left: 15),
                                      title: RichText(
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.end,
                                        textDirection: TextDirection.rtl,
                                        softWrap: true,
                                        maxLines: 1,
                                        textScaleFactor: 1,
                                        text: TextSpan(
                                          text: item.userName.toString(),
                                          style: DefaultTextStyle.of(context).style,
                                        ),
                                      ),
                                      leading: const SizedBox(
                                        height: 80,
                                        width: 80,
                                        child: Icon(Icons.person),
                                      ),
                                      subtitle: Text(item.email),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          item.deactivate
                                              ? Image.asset(
                                                  'assets/images/deactivate.png',
                                                  height: 20,
                                                  width: 20,
                                                )
                                              : const SizedBox(),
                                          PopupMenuButton<int>(
                                              padding: EdgeInsets.zero,
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
                                                      Get.to(() => EditCustomer(
                                                            uid: item.docid,
                                                          ));
                                                      // Get.to(AddCustomerUserScreen(
                                                      //   isEditMode: true,
                                                      //   documentId: item.docid,
                                                      //   userName: item.userName,
                                                      //   email: item.email,
                                                      //   phonenumber: item.mobileNumber,
                                                      //   code: item.code,
                                                      //   country: item.country,
                                                      // ));
                                                    },
                                                    child: const Text("Edit"),
                                                  ),
                                                  if( controller.userType == "admin")
                                                  PopupMenuItem(
                                                    value: 1,
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (ctx) => AlertDialog(
                                                          title: const Text("Delete Customer"),
                                                          content: SizedBox(
                                                            height: 140,
                                                            child: Column(
                                                              children: [
                                                                const Text("Are you sure you want to delete this customer"),
                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: TextButton(
                                                                        onPressed: () {
                                                                          Navigator.of(ctx).pop();
                                                                        },
                                                                        child: Container(
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.red,
                                                                              borderRadius: BorderRadius.circular(11)),
                                                                          // width: 100,
                                                                          padding: const EdgeInsets.all(14),
                                                                          child: const Center(
                                                                              child: Text(
                                                                            "Cancel",
                                                                            style: TextStyle(color: Colors.white),
                                                                          )),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child: TextButton(
                                                                        onPressed: () async {
                                                                          FirebaseFirestore.instance
                                                                              .collection("customer_users")
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
                                                                          width: 100,
                                                                          padding: const EdgeInsets.all(14),
                                                                          child: const Center(
                                                                              child: Text(
                                                                            "okay",
                                                                            style: TextStyle(color: Colors.white),
                                                                          )),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: const Text("Delete"),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 1,
                                                    onTap: () {
                                                      item.deactivate
                                                          ? FirebaseFirestore.instance
                                                              .collection('customer_users')
                                                              .doc(item.docid)
                                                              .update({"deactivate": false})
                                                          : FirebaseFirestore.instance
                                                              .collection('customer_users')
                                                              .doc(item.docid)
                                                              .update({"deactivate": true});
                                                      setState(() {});
                                                    },
                                                    child: Text(item.deactivate ? "Activate" : "Deactivate"),
                                                  ),
                                                ];
                                              }),
                                        ],
                                      ))),
                            ).appPaddingForScreen;
                          })
                      : const Center(
                          child: Text("No User Found"),
                        );
                }
                return const CircularProgressIndicator();
              },
            )
          ],
        ),
      ),
    );
  }

  List<CustomerRegisterData> filterUsers(List<CustomerRegisterData> users, String query) {
    if (query.isEmpty) {
      return users; // Return all users if the search query is empty
    } else {
      // Filter the users based on the search query
      return users.where((user) {
        if (user.userName is String) {
          return user.userName.toLowerCase().contains(query.toLowerCase());
        }
        return false;
      }).toList();
    }
  }

  Stream<List<CustomerRegisterData>> getUsersStreamFromFirestore() {
    return FirebaseFirestore.instance.collection('customer_users').orderBy("time",descending: true).snapshots().map((querySnapshot) {
      List<CustomerRegisterData> users = [];
      try {
        for (var doc in querySnapshot.docs) {
          users.add(CustomerRegisterData(
            userName: doc.data()['userName'],
            email: doc.data()['email'],
            mobileNumber: doc.data()['mobileNumber'],
            code: doc.data()['code'],
            country: doc.data()['country'],
            deactivate: doc.data()['deactivate'] ?? false,
            docid: doc.id,
          ));
        }
      } catch (e) {
        print(e.toString());
        throw Exception(e.toString());
      }
      return users;
    });
  }
}
