import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:resvago/admin/addproduct_screen.dart';
import 'package:resvago/admin/model/menuitem_model.dart';

class ProductCategoryScreen extends StatefulWidget {
  final CollectionReference collectionReference;
  final MenuItemData? menuItemData;
  const ProductCategoryScreen(
      {Key? key, required this.collectionReference, this.menuItemData})
      : super(key: key);

  @override
  State<ProductCategoryScreen> createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
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
          widget.menuItemData != null
              ? "${widget.menuItemData!.name} Sub Category"
              : 'Product Category',
          style: const TextStyle(color: Color(0xff423E5E),fontWeight: FontWeight.bold),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddProductScreen(
                              collectionReference: widget.collectionReference,
                            )));
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
      body: StreamBuilder<List<MenuItemData>>(
        stream: getMenuItemStreamFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading indicator while data is being fetched
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<MenuItemData> users = snapshot.data ?? [];
            final filteredUsers = filterUsers(users, searchQuery); //
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
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                            child: ListTile(
                                contentPadding:
                                    EdgeInsets.only(left: 15, right: 5),
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
                                        image: NetworkImage(
                                            item.image.toString()),
                                        fit: BoxFit.cover,
                                      ),
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(5)),
                                ),
                                subtitle: Text(item.description),
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
                                                            AddProductScreen(
                                                              collectionReference:
                                                                  widget
                                                                      .collectionReference,
                                                              menuItemData:
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
                                                        "Delete Product Category"),
                                                    content: const Text(
                                                        "Are you sure you want to delete this Product Categor"),
                                                    actions: <Widget>[
                                                      Expanded(
                                                        child: TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    ctx)
                                                                .pop();
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .red,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        11)),
                                                            width: 100,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(
                                                                    14),
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
                                                              setState(
                                                                  () {});
                                                            });
                                                            Navigator.of(
                                                                    ctx)
                                                                .pop();
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .green,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        11)),
                                                            width: 100,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(
                                                                    14),
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
                                                        builder: (context) => ProductCategoryScreen(
                                                            collectionReference: widget
                                                                .collectionReference
                                                                .doc(item
                                                                    .docid)
                                                                .collection(
                                                                    "sub_category"),
                                                            menuItemData:
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
                                ))),
                      );
                    })
                : const Center(
                    child: Text("No SubCategory Found"),
                  );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  List<MenuItemData> filterUsers(List<MenuItemData> users, String query) {
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

  Stream<List<MenuItemData>> getMenuItemStreamFromFirestore() {
    return widget.collectionReference
        .orderBy('time', descending: isDescendingOrder)
        .snapshots()
        .map((querySnapshot) {
      List<MenuItemData> itemmenu = [];
      try {
        for (var doc in querySnapshot.docs) {
          var gg = doc.data() as Map;
          itemmenu.add(MenuItemData(
            name: gg['name'],
            description: gg['description'],
            image: gg['image'],
            deactivate: gg['deactivate'] ?? false,
            docid: doc.id,
          ));
        }
      } catch (e) {
        print(e.toString());
        throw Exception(e.toString());
      }
      return itemmenu;
    });
  }
}
