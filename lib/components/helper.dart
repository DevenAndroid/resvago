import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';


class Helper {
  static Future addImagePicker(
      {ImageSource imageSource = ImageSource.gallery,
        int imageQuality = 100}) async {
    try {
      final item = await ImagePicker()
          .pickImage(source: imageSource, imageQuality: imageQuality);
      if (item == null) {
        return null;
      } else {
        return File(item.path);
      }
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }
  static Future addFilePicker() async {
    try {
      final item = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['jpg','png','jpeg'],);
      if (item == null) {
        return null;
      } else {
        return kIsWeb ? item.files.first.bytes! : File(item.files.first.path!);
      }
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }


  static Future addFilePicker1({
    bool singleFile = false
  }) async {
    try {
      final item = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['jpg','png','jpeg','webp'],allowMultiple: true);
      if (item == null) {
        return null;
      } else {
        return kIsWeb ? singleFile ? item.files.first.bytes : item.files.map((e) => e.bytes).toList() : File(item.files.first.path!);
      }
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }

  static OverlayEntry overlayLoader(context) {
    OverlayEntry loader = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Positioned(
        height: size.height,
        width: size.width,
        top: 0,
        left: 0,
        child: Material(
            color: Colors.white10,
            child: const SizedBox(
                height: 35,
                width: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.blueAccent,
                    ),
                  ],
                ))),
      );
    });
    return loader;
  }

  static hideLoader(OverlayEntry loader) {
    Timer(const Duration(milliseconds: 500), () {
      try {
        loader.remove();
        // ignore: empty_catches
      } catch (e) {}
    });
  }
}

showToast(message) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 14);
}

extension AddPaddingtoAll on Widget{

  Widget get appPadding{
    if(kIsWeb){
      return Center(
        child: SizedBox(
          width: 700,
          child: this,
        ),
      );
    }
    return this;
  }

  Widget get appPaddingForScreen{
    if(kIsWeb){
      return Center(
        child: SizedBox(
          width: 1200,
          child: this,
        ),
      );
    }
    return this;
  }

  Widget addPadding(EdgeInsetsGeometry padding){
    return Padding(padding: padding,child: this,);
  }

}

extension DateOnlyCompare on DateTime {
  bool isSmallerThen(DateTime other) {
    return (year == other.year && month == other.month && day < other.day) ||
        (year == other.year && month < other.month) || (year < other.year);
  }

  bool get isPreviousDay {
    DateTime now = DateTime.now();
    return DateTime(year, month, day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays == -1;
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month
        && day == other.day;
  }
}