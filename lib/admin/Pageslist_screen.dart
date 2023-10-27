import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:resvago/admin/addpages_screen.dart';

import 'model/Pages_model.dart';

class PagesListScreen extends StatefulWidget {
  const PagesListScreen({Key? key}) : super(key: key);

  @override
  State<PagesListScreen> createState() => _PagesListScreenState();
}

class _PagesListScreenState extends State<PagesListScreen> {
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
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Pages List',
          style: TextStyle(color: Color(0xff423E5E),fontWeight: FontWeight.bold),
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
          GestureDetector(
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
                Get.to(AddPagesScreen(
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
            icon: Icon(Icons.search),
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
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black), // Change the outline border color
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<PagesData>>(
              stream: getPagesStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<PagesData>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No Pages Found"));
                } else {
                  List<PagesData>? pages = snapshot.data;
                  final filteredPages = filterUsers(pages!, searchQuery);

                  return filteredPages.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredPages.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = filteredPages[index];

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
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                  child: ListTile(
                                    contentPadding: EdgeInsets.only(left: 15,right: 5),
                                      title: Text(
                                        item.title.toString(),
                                        style: const TextStyle(
                                            color: Color(0xff384953),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle:
                                          Text(item.longdescription.toString(),overflow: TextOverflow.ellipsis,),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          item.deactivate
                                              ? Image.asset('assets/images/deactivate.png',height: 20,width: 20,)
                                              : const SizedBox(),
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
                                                      Get.to(AddPagesScreen(
                                                        isEditMode: true,
                                                        documentId: item.docid,
                                                        title: item.title,
                                                        longdescription:
                                                            item.longdescription,
                                                      ));
                                                    },
                                                    child: const Text("Edit"),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 1,
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (ctx) =>
                                                            AlertDialog(
                                                          title: const Text(
                                                              "Delete Page"),
                                                          content: const Text(
                                                              "Are you sure you want to delete this Page"),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(ctx)
                                                                    .pop();
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        Colors.red,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                11)),
                                                                width: 100,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(14),
                                                                child: const Center(
                                                                    child: Text(
                                                                  "Cancel",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "Pages")
                                                                    .doc(item.docid)
                                                                    .delete()
                                                                    .then((value) {
                                                                  setState(() {});
                                                                });
                                                                Navigator.of(ctx)
                                                                    .pop();
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .green,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                11)),
                                                                width: 100,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(14),
                                                                child: const Center(
                                                                    child: Text(
                                                                  "okay",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
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
                                                      item.deactivate ? FirebaseFirestore.instance
                                                          .collection('Pages')
                                                          .doc(item.docid)
                                                          .update(
                                                              {"deactivate": false}):
                                                      FirebaseFirestore.instance
                                                          .collection('Pages')
                                                          .doc(item.docid)
                                                          .update(
                                                          {"deactivate": true});
                                                      setState(() {});
                                                    },
                                                    child: Text(item.deactivate
                                                        ? "Activate"
                                                        : "Deactivate"),
                                                  ),
                                                ];
                                              }),
                                        ],
                                      ))),
                            );
                          })
                      : const Center(
                          child: Text("No Pages Found"),
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

  List<PagesData> filterUsers(List<PagesData> users, String query) {
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

  Stream<List<PagesData>> getPagesStream() {
    return FirebaseFirestore.instance
        .collection('Pages')
        .orderBy('time', descending: isDescendingOrder)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PagesData(
                title: doc.data()['title'],
                longdescription: doc.data()['longdescription'],
                deactivate: doc.data()['deactivate'] ?? false,
                docid: doc.id))
            .toList());
  }
}
