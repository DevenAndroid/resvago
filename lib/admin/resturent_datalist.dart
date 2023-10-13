import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago/admin/addResturent_screen.dart';
import 'model/resturent_model.dart';

class ResturentDataScreen extends StatefulWidget {
  final CollectionReference collectionReference;
  final ResturentData? resturentData;
  const ResturentDataScreen({Key? key, required this.collectionReference, this.resturentData}) : super(key: key);

  @override
  State<ResturentDataScreen> createState() => _ResturentDataScreenState();
}

class _ResturentDataScreenState extends State<ResturentDataScreen> {
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
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff3B5998),
        title: Text(
          widget.resturentData != null ? "${widget.resturentData!.name} Sub Category" : 'Category List',
          style: const TextStyle(color: Colors.white),
        ),
        leading: BackButton(),
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
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddRestaurentScreen(
                              collectionReference: widget.collectionReference,
                            )));
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.add_circle_outline,
                  size: 30,
                  color: Colors.white,
                ),
              )),
          IconButton(
            icon: const Icon(Icons.search),
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
            StreamBuilder<List<ResturentData>>(
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
                                    offset: const Offset(0, 3),
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
                                        text: item.name.toString(),
                                        style: DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: item.deactivate ? "Deactivate" : "",
                                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                                        ],
                                      ),
                                    ),
                                    leading: SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Image.network(
                                        item.image.toString(),
                                        fit: BoxFit.fill,
                                        errorBuilder: (_, __, ___) => const Icon(Icons.shopping_cart),
                                      ),
                                    ),
                                    subtitle: Text(item.description.toString()),
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
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => AddRestaurentScreen(
                                                              collectionReference: widget.collectionReference,
                                                              resturentData: item,
                                                            )));
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
                                                              color: Colors.red, borderRadius: BorderRadius.circular(11)),
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
                                                          widget.collectionReference
                                                              .doc(item.docid)
                                                              .delete()
                                                              .then((value) {
                                                            setState(() {});
                                                          });
                                                          Navigator.of(ctx).pop();
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.green, borderRadius: BorderRadius.circular(11)),
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
                                                widget.collectionReference.doc(item.docid).update({"deactivate": true});
                                              },
                                              child: Text(item.deactivate ? "Activate" : "Deactivate"),
                                            ),
                                            PopupMenuItem(
                                              value: 1,
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => ResturentDataScreen(
                                                            collectionReference: widget.collectionReference
                                                                .doc(item.docid)
                                                                .collection("sub_category"),
                                                            resturentData: item,
                                                            key: ValueKey(DateTime.now().millisecondsSinceEpoch))));
                                                // Get.to(AddSubcategoryScreen(isEditMode: false,documentId: item.docid,));
                                              },
                                              child: const Text('View SubCategory'),
                                            ),
                                          ];
                                        })),
                              ),
                            );
                          })
                      : const Center(
                          child: Text("No User Found"),
                        );
                }
              },
            )
          ],
        ),
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
    return widget.collectionReference.orderBy('time', descending: isDescendingOrder).snapshots().map((querySnapshot) {
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
