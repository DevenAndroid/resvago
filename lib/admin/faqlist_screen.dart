import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:resvago/admin/addpages_screen.dart';
import 'package:resvago/admin/faq_screen.dart';
import 'package:resvago/components/helper.dart';
import 'controller/profil_controller.dart';
import 'model/Pages_model.dart';
import 'model/faq_model.dart';

class FaqListScreen extends StatefulWidget {
  const FaqListScreen({super.key, required this.collectionReference});
  final CollectionReference collectionReference;
  @override
  State<FaqListScreen> createState() => _FaqListScreenState();
}

class _FaqListScreenState extends State<FaqListScreen> {
  final controller = Get.put(ProfileController());
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
        title: Text(
          'FAQ List'.tr,
          style: const TextStyle(color: Color(0xff423E5E), fontWeight: FontWeight.bold),
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
                Get.to(AddFAQScreen(collectionReference: widget.collectionReference));
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.add_circle_outline,
                  size: 30,
                  color: Color(0xff3B5998),
                ),
              )),
        ],
      ),
      body: StreamBuilder<List<FAQModel>>(
        stream: getPagesStream(),
        builder: (BuildContext context, AsyncSnapshot<List<FAQModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("FAQ Not Found"));
          } else {
            List<FAQModel>? pages = snapshot.data;
            return pages!.isNotEmpty
                ? ListView.builder(
                    itemCount: pages.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item = pages[index];

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
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Center(
                            child: ListTile(
                                contentPadding: const EdgeInsets.only(left: 15, right: 5),
                                title: Text(
                                  item.answer.toString(),
                                  style: const TextStyle(color: Color(0xff384953), fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  item.question.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
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
                                                Get.to(AddFAQScreen(
                                                  collectionReference: widget.collectionReference,
                                                  menuItemData: item,
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
                                                    title: const Text("Delete Page"),
                                                    content: const Text("Are you sure you want to delete this Page"),
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
                                                item.deactivate
                                                    ? FirebaseFirestore.instance
                                                        .collection('Pages')
                                                        .doc(item.docid)
                                                        .update({"deactivate": false})
                                                    : FirebaseFirestore.instance
                                                        .collection('Pages')
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
                    child: Text("FAQ not found"),
                  );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Stream<List<FAQModel>> getPagesStream() {
    return FirebaseFirestore.instance.collection('FAQ').orderBy('time', descending: isDescendingOrder).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => FAQModel(
                answer: doc.data()['answer'],
                question: doc.data()['question'],
                deactivate: doc.data()['deactivate'] ?? false,
                docid: doc.id))
            .toList());
  }
}
