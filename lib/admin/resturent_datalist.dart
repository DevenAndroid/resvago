import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago/admin/addResturent_screen.dart';
import 'model/resturent_model.dart';

class ResturentDataScreen extends StatefulWidget {
  const ResturentDataScreen({Key? key}) : super(key: key);

  @override
  State<ResturentDataScreen> createState() => _ResturentDataScreenState();
}

class _ResturentDataScreenState extends State<ResturentDataScreen> {
  bool userDeactivate = false;
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
        title: const Text('Restaurant List',style: TextStyle(color: Colors.white),),
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back)),
        actions: [
          GestureDetector(
              onTap: () {
                Get.to(const AddResturentScreen(
                  isEditMode: false,
                ));
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.add_circle_outline,
                  size: 30,
                  color: Colors.white,
                ),
              )),

        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<ResturentData>>(
              stream: getResturentStreamFromFirestore(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show a loading indicator while data is being fetched
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // List<ResturentData> users = snapshot.data ?? [];
                  return snapshot.data!.isNotEmpty
                      ? ListView.builder(
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = snapshot.data![index];
                            log(item.image.toString());
                            // if (item.deactivate) {
                            //   return SizedBox.shrink();
                            // }
                            return Container(
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
                                    leading: Container(
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
                                                Get.to(AddResturentScreen(
                                                  isEditMode: true,
                                                  documentId: item.docid,
                                                  name: item.name,
                                                  description: item.description,
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
                                                          FirebaseFirestore.instance
                                                              .collection("resturent")
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
                                                FirebaseFirestore.instance
                                                    .collection('resturent')
                                                    .doc(item.docid)
                                                    .update({"deactivate": true});
                                              },
                                              child: Text(item.deactivate ? "Activate" : "Deactivate"),
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
                return const CircularProgressIndicator();
              },
            )
          ],
        ),
      ),
    );
  }
}

Stream<List<ResturentData>> getResturentStreamFromFirestore() {
  return FirebaseFirestore.instance.collection('resturent').orderBy('time', descending: true).snapshots().map((querySnapshot) {
    List<ResturentData> resturent = [];
    try {
      for (var doc in querySnapshot.docs) {
        resturent.add(ResturentData(
          name: doc.data()['name'],
          description: doc.data()['description'],
          image: doc.data()['image'],
          deactivate: doc.data()['deactivate'] ?? false,
          docid: doc.id,
        ));
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
    return resturent;
  });
}
