import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {
  RxInt refreshInt = 0.obs;
  List<File> galleryImages = [];
  List<File> menuGallery = [];
  List<Uint8List?> galleryFiles = [];
  List<Uint8List?> galleryFiles1 = [];
  List<String> galleryFilesUrl = [];
  List<String> galleryFilesUrl1 = [];
  bool showValidations = false;
  File categoryFile = File("");
}
