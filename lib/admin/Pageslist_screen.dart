import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff3B5998),
        title: Text('Pages List',style: TextStyle(color: Colors.white),),
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back)),
        actions: [
          GestureDetector(
              onTap: () {
                Get.to(AddPagesScreen(
                  isEditMode: false,
                ));
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.add_circle_outline,
                  size: 30,
                  color: Colors.white,
                ),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: getPagesFromFirestore(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<PagesData>> snapshot) {
                if (snapshot.hasData) {
                  log(snapshot.data.toString());
                  if (snapshot.data == null) {
                    return const Center(
                      child: Text("No Pages Found"),
                    );
                  }
                  return snapshot.data!.isNotEmpty
                      ? ListView.builder(
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = snapshot.data![index];
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
                            child: ListTile(
                                title:RichText(
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
                                          text: item.deactivate ? "Deactivate" : "", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red)),
                                    ],
                                  ),
                                ),
                                subtitle: Text(item.longdescription.toString()),
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
                                            Get.to(AddPagesScreen(
                                              isEditMode: true,
                                              documentId: item.docid,
                                              title: item.title,
                                              longdescription: item.longdescription,
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
                                                title:
                                                const Text("Delete user"),
                                                content: const Text(
                                                    "Are you sure you want to delete this user"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(11)),
                                                      width: 70,

                                                      padding:
                                                      const EdgeInsets.all(
                                                          14),
                                                      child: const Center(
                                                          child: Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                                color:
                                                                Colors.white),
                                                          )),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection("Pages")
                                                          .doc(item.docid)
                                                          .delete()
                                                          .then((value) {
                                                        setState(() {});
                                                      });
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(11)),
                                                      width: 70,
                                                      padding:
                                                      const EdgeInsets.all(
                                                          14),
                                                      child: const Center(
                                                          child: Text(
                                                            "okay",
                                                            style: TextStyle(
                                                                color:
                                                                Colors.white),
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
                                                .collection('Pages')
                                                .doc(item.docid)
                                                .update({"deactivate": true});
                                          },
                                          child: Text(item.deactivate ? "Activate" : "Deactivate"),
                                        ),
                                      ];
                                    }))
                          ),
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
}

Future<List<PagesData>> getPagesFromFirestore() async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
  await FirebaseFirestore.instance.collection('Pages').orderBy('time', descending: true).get();

  List<PagesData> pages = [];
  try {
    for (var doc in querySnapshot.docs) {
      log(doc.data().toString());
      pages.add(PagesData(
          title: doc.data()['title'],
          longdescription: doc.data()['longdescription'],
          deactivate: doc.data()['deactivate'] ?? false,
          docid: doc.id));
    }
  } catch (e) {
    log(e.toString());
    throw Exception();
  }
  log(querySnapshot.docs.map((e) => e.data().toString()).toString());
  return pages;
}
