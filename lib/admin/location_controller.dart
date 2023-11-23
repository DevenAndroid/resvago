import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  RxBool servicestatus = false.obs;
  RxBool haspermission = false.obs;
  late LocationPermission permission;
  String? location;
  String? addressType;
  late Position position;
  RxString long = "0.0".obs, lat = "0.0".obs;
  var locality = 'No location set'.obs;
  var country = 'Getting Country..'.obs;
  late StreamSubscription<Position> positionStream;

  Future checkGps(context) async {
    servicestatus.value = await Geolocator.isLocationServiceEnabled();
    if (servicestatus.value) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.denied) {
          haspermission.value = true;
        }
      } else {
        haspermission.value = true;
      }

      if (haspermission.value) {
        await getLocation();
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              "Location",
            ),
            content: const Text(
              "Please turn on GPS location service to narrow down the nearest eateries.",
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Approve'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await Geolocator.openLocationSettings();
                  servicestatus.value =
                  await Geolocator.isLocationServiceEnabled();
                  if (servicestatus.value) {
                    permission = await Geolocator.checkPermission();

                    if (permission == LocationPermission.denied) {
                      permission = await Geolocator.requestPermission();
                      if (permission == LocationPermission.denied) {
                      } else if (permission ==
                          LocationPermission.deniedForever) {
                      } else {
                        haspermission.value = true;
                      }
                    } else {
                      haspermission.value = true;
                    }

                    if (haspermission.value) {
                      await getLocation();
                    }
                  }
                },
              ),
            ],
          ));
    }
  }

  Future getLocation() async {
    log("Getting user location.........");
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    long.value = position.longitude.toString();
    lat.value = position.latitude.toString();
    print("Address$position");
    await placemarkFromCoordinates(
        double.parse(lat.value), double.parse(long.value))
        .then((value) async {
      locality.value = value.last.locality!;
      country.value = 'Country : ${value.last.country}';
      print(locality.value);
      print(country.value);
    });
  }

  // getApiLocation() async {
  //   log("Getting user location.........");
  //   await placemarkFromCoordinates(
  //       double.parse(lat.value == '' ? "0" : lat.value),
  //       double.parse(long.value == '' ? "0" : long.value))
  //       .then((value) {
  //     locality.value = 'Locality: ${value.first.locality}';
  //     country.value = 'Country : ${value.last.country}';
  //     log(value.map((e) => e.locality).toList().toString());
  //     log(locality.value);
  //     log(country.value);
  //   });
  // }



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getLocation();
    checkGps(Get.context);
  }
}