import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:resvago/admin/adduser_screen.dart';

import 'model/user_model.dart';

class UsersDataScreen extends StatefulWidget {
  const UsersDataScreen({Key? key}) : super(key: key);

  @override
  State<UsersDataScreen> createState() => _UsersDataScreenState();
}

class _UsersDataScreenState extends State<UsersDataScreen> {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor:Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Vendor Users List',
          style: TextStyle(color: Color(0xFF423E5E),fontSize: 20,fontWeight: FontWeight.bold),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(15),
          child: GestureDetector(
            onTap: (){
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
                Get.to( const AddUsersScreen(
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
            icon: const Icon(Icons.search,size: 30,),
            onPressed: toggleTextFieldVisibility,
            color: Color(0xff3B5998),
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
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<UserData>>(
              stream: getUsersStreamFromFirestore(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: const CircularProgressIndicator()); // Show a loading indicator while data is being fetched
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<UserData> users = snapshot.data ?? [];
                  final filteredUsers = filterUsers(users, searchQuery); // Apply the search filter

                  return filteredUsers.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredUsers.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = filteredUsers[index];
                            log(item.image.toString());
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
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Center(
                                  child: ListTile(
                                      contentPadding: EdgeInsets.only(left: 15),
                                      title: RichText(
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.end,
                                        textDirection: TextDirection.rtl,
                                        softWrap: true,
                                        maxLines: 1,
                                        textScaleFactor: 1,
                                        text: TextSpan(
                                          text: item.restaurantName.toString(),
                                          style: DefaultTextStyle.of(context).style,
                                        ),
                                      ),
                                      leading: Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(item.image.toString()),
                                              fit: BoxFit.cover,
                                            ),
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(5)),
                                      ),
                                      subtitle: Text(item.email),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          item.deactivate == true
                                              ? Image.asset('assets/images/deactivate.png',height: 20,width: 20,)
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
                                                      Get.to(AddUsersScreen(
                                                        isEditMode: true,
                                                        documentId: item.docid,
                                                          restaurantNamename: item.restaurantName,
                                                        email: item.email,
                                                        category: item.category,
                                                        phoneNumber: item.mobileNumber,
                                                        image: item.image,
                                                        address: item.address
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
                                                          title: const Text("Delete user"),
                                                          content: const Text("Are you sure you want to delete this user"),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(ctx).pop();
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors.red,
                                                                    borderRadius: BorderRadius.circular(11)),
                                                                width: 100,
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
                                                                    .collection("vendor_users")
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
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    child: const Text("Delete"),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 1,
                                                    onTap: () {
                                                      if(item.deactivate == true) {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                            'vendor_users')
                                                            .doc(item.docid)
                                                            .update({
                                                          "deactivate": false
                                                        });
                                                    } else {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('vendor_users')
                                                            .doc(item.docid)
                                                            .update({
                                                          "deactivate": true
                                                        });
                                                      }
                                                    },
                                                    child: Text(item.deactivate == true ? "Activate" : "Deactivate"),
                                                  ),
                                                ];
                                              }),
                                        ],
                                      ))),
                            );
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

  List<UserData> filterUsers(List<UserData> users, String query) {
    if (query.isEmpty) {
      return users;
    } else {
      return users.where((user) {
        if (user.restaurantName is String) {
          return user.restaurantName.toLowerCase().contains(query.toLowerCase());
        }
        return false;
      }).toList();
    }
  }

  Stream<List<UserData>> getUsersStreamFromFirestore() {
    return FirebaseFirestore.instance
        .collection('vendor_users')
        .snapshots()
        .map((querySnapshot) {
      List<UserData> users = [];
      try {
        for (var doc in querySnapshot.docs) {
          users.add(UserData.fromMap(doc.data(),doc.id));
        }
      } catch (e) {
        print(e.toString());
        throw Exception(e.toString());
      }
      return users;
    });
  }
}
