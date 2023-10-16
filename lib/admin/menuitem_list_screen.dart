import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago/admin/addmenuitem_screen.dart';
import 'package:resvago/admin/model/menuitem_model.dart';

class MenuItemListScreen extends StatefulWidget {
  final CollectionReference collectionReference;
  final MenuItemData? menuItemData;
  const MenuItemListScreen({Key? key, required this.collectionReference, this.menuItemData}) : super(key: key);


  @override
  State<MenuItemListScreen> createState() => _MenuItemListScreenState();
}

class _MenuItemListScreenState extends State<MenuItemListScreen> {
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
        backgroundColor: Color(0xff3B5998),
        title: Text(
          widget.menuItemData != null ? "${widget.menuItemData!.name} Sub Category" : 'Category List',
          style: const TextStyle(color: Colors.white),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddMenuItemScreen(
                          collectionReference: widget.collectionReference,
                        )));
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
            StreamBuilder<List<MenuItemData>>(
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
                        return  Container(
                          height: 90,
                          margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                          width: Get.width,
                          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(11),boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                          ),
                          child: Center(
                            child:  ListTile(
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
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => AddMenuItemScreen(
                                                      collectionReference: widget.collectionReference,
                                                      menuItemData: item,
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
                                            widget.collectionReference
                                                .doc(item.docid)
                                                .update({"deactivate": true});
                                          },
                                          child: Text(item.deactivate ? "Activate" : "Deactivate"),
                                        ), PopupMenuItem(
                                          value: 1,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => MenuItemListScreen(
                                                        collectionReference: widget.collectionReference
                                                            .doc(item.docid)
                                                            .collection("sub_category"),
                                                        menuItemData: item,
                                                        key: ValueKey(DateTime.now().millisecondsSinceEpoch))));
                                            // Get.to(AddSubcategoryScreen(isEditMode: false,documentId: item.docid,));
                                          },
                                          child: const Text('View SubCategory'),
                                        ),
                                      ];
                                    }))
                          ),
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
    return widget.collectionReference.orderBy('time', descending: isDescendingOrder).snapshots().map((querySnapshot) {
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
