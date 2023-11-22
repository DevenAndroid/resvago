import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:resvago/admin/addVendor_screen.dart';
import 'model/resturent_model.dart';

class VendorDataScreen extends StatefulWidget {
  final CollectionReference collectionReference;
  final ResturentData? resturentData;
  const VendorDataScreen(
      {Key? key, required this.collectionReference, this.resturentData})
      : super(key: key);

  @override
  State<VendorDataScreen> createState() => _VendorDataScreenState();
}

class _VendorDataScreenState extends State<VendorDataScreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          widget.resturentData != null
              ? "${widget.resturentData!.name} Sub Category"
              : 'Vendor Category',
          style: const TextStyle(color: Color(0xff423E5E),fontWeight: FontWeight.bold),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(15),
          child: GestureDetector(
              onTap:(){
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddVendorScreen(
                              collectionReference: widget.collectionReference,
                            )));
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.add_circle_outline,
                  size: 30,
                  color: Color(0xff3B5998),
                ),
              )),
          IconButton(
            icon: const Icon(Icons.search,color: Color(0xff3B5998),),
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
      body: StreamBuilder<List<ResturentData>>(
        stream: getResturentStreamFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<ResturentData> resturent = snapshot.data ?? [];
            final filteredUsers = filterUsers(resturent, searchQuery);
            // List<ResturentData> users = snapshot.data ?? [];
            return filteredUsers.isNotEmpty
                ? ListView.builder(
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
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: ListTile(
                            contentPadding: const EdgeInsets.only(right: 0,left: 10),
                              title: Text(
                                item.name.toString(),
                                style: const TextStyle(
                                    color: Color(0xff384953),
                                fontWeight: FontWeight.bold),
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
                              subtitle: Text(item.description.toString(),
                                  style: const TextStyle(
                                      color: Color(0xff384953),
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
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
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddVendorScreen(
                                                            collectionReference:
                                                                widget
                                                                    .collectionReference,
                                                            resturentData:
                                                                item,
                                                          )));
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
                                                      "Delete Vendor Category"),
                                                  content: const Text(
                                                      "Are you sure you want to delete this Vendor Category"),
                                                  actions: <Widget>[
                                                    Expanded(
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.of(ctx)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .red,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          11)),
                                                          width: 100,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(14),
                                                          child:
                                                              const Center(
                                                                  child:
                                                                      Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: TextButton(
                                                        onPressed: () {
                                                          widget
                                                              .collectionReference
                                                              .doc(item
                                                                  .docid)
                                                              .delete()
                                                              .then(
                                                                  (value) {
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
                                                          child:
                                                              const Center(
                                                                  child:
                                                                      Text(
                                                            "okay",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                        ),
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
                                              item.deactivate ? widget.collectionReference
                                                  .doc(item.docid)
                                                  .update({
                                                "deactivate": false
                                              }) :
                                              widget.collectionReference
                                                  .doc(item.docid)
                                                  .update({
                                                "deactivate": true
                                              });
                                              setState(() {});
                                            },
                                            child: Text(item.deactivate
                                                ? "Activate"
                                                : "Deactivate"),
                                          ),
                                          PopupMenuItem(
                                            value: 1,
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => VendorDataScreen(
                                                          collectionReference: widget
                                                              .collectionReference
                                                              .doc(item
                                                                  .docid)
                                                              .collection(
                                                                  "sub_category"),
                                                          resturentData:
                                                              item,
                                                          key: ValueKey(
                                                              DateTime.now()
                                                                  .millisecondsSinceEpoch))));
                                            },
                                            child: const Text(
                                                'View SubCategory'),
                                          ),
                                        ];
                                      }),
                                ],
                              )),
                        ),
                      );
                    })
                : const Center(
                    child: Text("No SubCategory Found"),
                  );
          }
        },
      ),
    );
  }

  List<ResturentData> filterUsers(List<ResturentData> users, String query) {
    if (query.isEmpty) {
      return users;
    } else {
      return users.where((user) {
        if (user.name is String) {
          return user.name.toLowerCase().contains(query.toLowerCase());
        }
        return false;
      }).toList();
    }
  }

  Stream<List<ResturentData>> getResturentStreamFromFirestore() {
    return widget.collectionReference
        .orderBy('time', descending: isDescendingOrder)
        .snapshots()
        .map((querySnapshot) {
      List<ResturentData> resturent = [];
      try {
        for (var doc in querySnapshot.docs) {
          var gg = doc.data() as Map;
          resturent.add(ResturentData(
            name: gg['name'],
            description: gg['description'],
            image: gg['image'],
            deactivate: gg['deactivate'] ?? false,
            docid: doc.id,
          ));
        }
      } catch (e) {
        throw Exception(e.toString());
      }
      return resturent;
    });
  }
}
