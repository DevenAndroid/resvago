import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/admin_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  // AdminModel? adminModel;
  // void getAdminData() {
  //   FirebaseFirestore.instance.collection("customer_care_login").get().then((value) {
  //     if(value.docs.first.data().isNotEmpty){
  //       adminModel = AdminModel.fromJson(value.docs.first.data());
  //       log(jsonEncode(value.docs.first.data()).toString());
  //     }
  //   });
  // }
  String userType = "";
  String userEmail = "";

  getAdminData() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userType = sharedPreferences.getString("login_type")!;
    userEmail = sharedPreferences.getString("User_email")!;
  }
}