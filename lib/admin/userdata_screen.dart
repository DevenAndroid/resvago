import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff3B5998),
        title: const Text(
          'Users List',
          style: TextStyle(color: Colors.white),
        ),
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back_ios)),
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
                Get.to( AddUsersScreen(
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
                style: const TextStyle(color: Colors.white),
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
            StreamBuilder<List<UserData>>(
              stream: getUsersStreamFromFirestore(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show a loading indicator while data is being fetched
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<UserData> users = snapshot.data ?? [];
                  final filteredUsers = filterUsers(users, searchQuery); // Apply the search filter

                  return filteredUsers.isNotEmpty
                      ? ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
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
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
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
                                          text: item.name.toString(),
                                          style: DefaultTextStyle.of(context).style,
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: item.deactivate ? "Deactivate" : "",
                                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                      leading: Container(
                                        height: 100,
                                        width: 100,
                                        child: Image.network(
                                          item.image.toString(),
                                          fit: BoxFit.fill,
                                          errorBuilder: (_, __, ___) => const Icon(Icons.shopping_cart),
                                        ),
                                      ),
                                      subtitle: Text(item.email),
                                      trailing: PopupMenuButton<int>(
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
                                                    name: item.name,
                                                    email: item.email,
                                                    password: item.password,
                                                    phoneNumber: item.phoneNumber,
                                                    image: item.image,
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
                                                                .collection("users")
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
                                                  FirebaseFirestore.instance
                                                      .collection('users')
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
      return users; // Return all users if the search query is empty
    } else {
      // Filter the users based on the search query
      return users.where((user) {
        if (user.name is String) {
          return user.name.toLowerCase().contains(query.toLowerCase());
        }
        return false;
      }).toList();
    }
  }

  Stream<List<UserData>> getUsersStreamFromFirestore() {
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy('time', descending: isDescendingOrder)
        .snapshots()
        .map((querySnapshot) {
      List<UserData> users = [];
      try {
        for (var doc in querySnapshot.docs) {
          users.add(UserData(
            name: doc.data()['name'],
            email: doc.data()['email'],
            image: doc.data()['image'],
            password: doc.data()['password'],
            phoneNumber: doc.data()['phoneNumber'],
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
