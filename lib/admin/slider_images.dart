import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../components/helper.dart';
import 'controller/profil_controller.dart';

class SliderImagesScreen extends StatefulWidget {
  const SliderImagesScreen({super.key});

  @override
  State<SliderImagesScreen> createState() => _SliderImagesScreenState();
}

class _SliderImagesScreenState extends State<SliderImagesScreen> {
  final controller = Get.put(ProfileController());
  File categoryFile = File("");
  String? imageUrl;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future<void> uploadImage() async {
    try {
      String imageUrlProfile = categoryFile.path;
      if (!categoryFile.path.contains("http")) {
        UploadTask uploadTask = FirebaseStorage.instance
            .ref("categoryImages")
            .child(DateTime.now().millisecondsSinceEpoch.toString())
            .putFile(categoryFile);
        TaskSnapshot snapshot = await uploadTask;
        imageUrlProfile = await snapshot.ref.getDownloadURL();
      }
      await FirebaseFirestore.instance.collection('slider').add({
        'imageUrl': imageUrlProfile,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
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
          'Image Slider'.tr,
          style:
              TextStyle(color: Color(0xff423E5E), fontWeight: FontWeight.bold),
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
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
                onTap: () {
                  _showActionSheet(context);
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 0),
                  child: Icon(
                    Icons.add_circle_outline,
                    size: 30,
                    color: Color(0xff3B5998),
                  ),
                )),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('slider').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          var images = snapshot.data!.docs;
          List<Widget> imageWidgets = [];
          for (var image in images) {
            var imageUrl = image['imageUrl'];
            var imageWidget = Image.network(imageUrl, fit: BoxFit.cover);
            imageWidgets.add(imageWidget);
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
            itemCount: imageWidgets.length,
            itemBuilder: (context, index) {
              var documentId = images[index].id;
              return Stack(
                children: [
                  imageWidgets[index],
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        print("object");
                        FirebaseFirestore.instance
                            .collection('slider')
                            .doc(documentId)
                            .delete();
                      },
                    ),
                  ),
                ],
              );
            },
          ).appPaddingForScreen;
        },
      ),
    );
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          'Select Picture from',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Helper.addImagePicker(
                      imageSource: ImageSource.camera, imageQuality: 75)
                  .then((value) async {
                if (value != null) {
                  categoryFile = File(value.path);
                  uploadImage();
                  setState(() {});
                }

                Get.back();
              });
            },
            child: const Text("Camera"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Helper.addImagePicker(
                      imageSource: ImageSource.gallery, imageQuality: 75)
                  .then((value) async {
                if (value != null) {
                  categoryFile = File(value.path);
                  uploadImage();
                  setState(() {});
                }

                Get.back();
              });
            },
            child: const Text('Gallery'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
