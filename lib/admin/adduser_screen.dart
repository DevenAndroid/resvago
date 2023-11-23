import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:resvago/admin/model/user_model.dart';
import 'package:resvago/admin/userdata_screen.dart';
import '../components/addsize.dart';
import '../components/helper.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import 'location_controller.dart';
import 'model/resturent_model.dart';

class AddUsersScreen extends StatefulWidget {
  final UserData? userData;
  final bool isEditMode;
  final String? documentId;
  final String? restaurantNamename;
  final String? email;
  final String? category;
  final String? phoneNumber;
  final String? image;
  final String? address;

  const AddUsersScreen({
    super.key,
    required this.isEditMode,
    this.documentId,
    this.restaurantNamename,
    this.phoneNumber,
    this.image,
    this.email,
    this.address,
    this.category,
    this.userData,
  });

  @override
  State<AddUsersScreen> createState() => _AddUsersScreenState();
}

class _AddUsersScreenState extends State<AddUsersScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final locationController = Get.put(LocationController());

  File categoryFile = File("");
  UserData? get userData => widget.userData;
  List<ResturentData>? categoryList;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String result = "Email not found";
  bool isPasswordVisible = false;
  bool showValidation = false;
  bool showValidationImg = false;
  String? categoryValue;
  bool isDescendingOrder = true;
  String googleApikey = "AIzaSyDDl-_JOy_bj4MyQhYbKbGkZ0sfpbTZDNU";
  String? _address = "";
  RxBool showValidation1 = false.obs;
  dynamic latitude = "";
  dynamic longitude = "";
  bool checkValidation(bool bool1, bool2) {
    if (bool1 == true && bool2 == true) {
      return true;
    } else {
      return false;
    }
  }

  getVendorCategories() {
    FirebaseFirestore.instance
        .collection("resturent")
        .orderBy('time', descending: isDescendingOrder)
        .get()
        .then((value) {
      for (var element in value.docs) {
        var gg = element.data();
        categoryList ??= [];
        categoryList!.add(ResturentData.fromMap(gg));
      }
      setState(() {});
    });
  }
  String code = "+91";

  void checkEmailInFirestore() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('vendor_users')
        .where('email', isEqualTo: emailController.text)
        .get();
    if (result.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Email already exits');
      return;
    }
    final QuerySnapshot phoneResult = await FirebaseFirestore.instance
        .collection('vendor_users')
        .where('mobileNumber', isEqualTo: code + phoneNumberController.text)
        .get();
    if (phoneResult.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Mobile Number already exits');
      return;
    }
    addusersToFirestore();
  }


  Future<void> addusersToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    String name = nameController.text;
    String email = emailController.text;
    String category = categoryValue!;
    String phoneNumber = phoneNumberController.text;
    String? address = _address;
    Timestamp currentTime = Timestamp.now();

    List<String> arrangeNumbers = [];
    String? userNumber = (name ?? "");
    arrangeNumbers.clear();
    for (var i = 0; i < userNumber.length; i++) {
      arrangeNumbers.add(userNumber.substring(0, i + 1));
    }

    String imageUrlProfile = categoryFile.path;
    if (!categoryFile.path.contains("http")) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref("categoryImages")
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(categoryFile);
      TaskSnapshot snapshot = await uploadTask;
      imageUrlProfile = await snapshot.ref.getDownloadURL();
    }
    if (name.isNotEmpty && email.isNotEmpty) {
      UserData users = UserData(
          restaurantName: name,
          searchName: arrangeNumbers,
          email: email,
          deactivate: false,
          image: imageUrlProfile,
          category: category,
          mobileNumber: phoneNumber,
          address: address,
          docid: code + phoneNumber,
          latitude: latitude.toString(),
          longitude: longitude.toString(),
          time: currentTime);
      if (widget.isEditMode) {
        FirebaseFirestore.instance
            .collection('vendor_users')
            .doc(widget.documentId)
            .update(users.toMap());
        Helper.hideLoader(loader);
        showToast('Updated User Details');

      } else {
        FirebaseFirestore.instance
            .collection('vendor_users')
            .doc(code + phoneNumber)
            .set(users.toMap())
            .then((value) => () {

                  nameController.clear();
                  emailController.clear();
                  categoryController.clear();
                  phoneNumberController.clear();
                  addressController.clear();
                });
        Helper.hideLoader(loader);
        showToast('User Details Added');


      }
      Get.back();
      Helper.hideLoader(loader);

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isEditMode == true) {
      nameController.text = widget.restaurantNamename ?? "";
      emailController.text = widget.email ?? "";
      categoryValue = widget.category ?? "";
      phoneNumberController.text = widget.phoneNumber ?? "";
      _address = widget.address ?? "";
      categoryFile = File(widget.image ?? "");
      log(categoryValue.toString());
    }
    getVendorCategories();
    locationController.checkGps(context).then((value) {});
    locationController.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: backAppBar(title: widget.isEditMode ? 'Edit Users' :'Add Users', context: context),
        backgroundColor: const Color(0xff3B5998),
        body: Form(
            key: formKey,
            child: SizedBox(
              height: size.height,
              width: size.width,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                                horizontal: size.width * .04,
                                vertical: size.height * .01)
                            .copyWith(bottom: 0),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Text("Restaurant Name",style: TextStyle(color: Colors.black),),
                                ),
                                const SizedBox(height: 5),
                                MyTextField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter Restaurant name';
                                    }
                                  },
                                  controller: nameController,
                                  hintText: 'Enter Restaurant Name',
                                  keyboardtype: TextInputType.name,
                                  obscureText: false,
                                  color: Colors.white,
                                ),

                                const SizedBox(height: 10),
                                const Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Text("Email",style: TextStyle(color: Colors.black),),
                                ),
                                const SizedBox(height: 5),
                                MyTextField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                  },
                                  controller: emailController,
                                  hintText: 'Enter Email',
                                  obscureText: false,
                                  keyboardtype:
                                      TextInputType.emailAddress,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 10),
                                const Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Text("Select Category",style: TextStyle(color: Colors.black),),
                                ),
                                const SizedBox(height: 5),
                                if (categoryList != null)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child:
                                        DropdownButtonFormField<dynamic>(
                                      dropdownColor:  Colors.white,
                                      focusColor:  Colors.white,
                                      isExpanded: true,
                                      iconEnabledColor:
                                          const Color(0xff97949A),
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Colors.black,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      hint: Text(
                                        "Select category".tr,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.justify,
                                      ),
                                      decoration: InputDecoration(
                                        focusColor:
                                            Colors.black,
                                        hintStyle: GoogleFonts.poppins(
                                          color: Colors.black,
                                          textStyle: GoogleFonts.poppins(
                                            color:
                                          Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          fontSize: 14,
                                          // fontFamily: 'poppins',
                                          fontWeight: FontWeight.w300,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 15,
                                                vertical: 15),
                                        // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                              Colors.black,),
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black,
                                            ),
                                            borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(
                                                        6.0))),
                                        errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    Colors.red.shade800),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(
                                                        6.0))),
                                        border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.black,
                                                width: 3.0),
                                            borderRadius:
                                                BorderRadius.circular(
                                                    6.0)),
                                      ),
                                      value: categoryValue,
                                      items: categoryList!.map((items) {
                                        return DropdownMenuItem(
                                          value: items.name.toString(),
                                          child: Text(
                                            items.name.toString(),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        categoryValue =
                                            newValue.toString();
                                        log(categoryValue.toString());
                                        setState(() {});
                                      },
                                      validator: (value) {
                                        if (categoryValue == null) {
                                          return 'Please select category';
                                        }
                                        return null;
                                      },
                                    ),
                                  )
                                else
                                  const Center(
                                    child: Text("No Category Available"),
                                  ),
                                const SizedBox(height: 10),
                                const Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Text("Phone Number",style: TextStyle(color: Colors.black),),
                                ),
                                const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.only(left: 17,right: 17),
                                  child: IntlPhoneField(
                                    cursorColor: Colors.black,
                                    dropdownIcon: const Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: Colors.black,
                                    ),
                                    dropdownTextStyle: const TextStyle(color: Colors.black),
                                    style: const TextStyle(color: Colors.black),
                                    flagsButtonPadding: const EdgeInsets.all(8),
                                    dropdownIconPosition: IconPosition.trailing,
                                    controller: phoneNumberController,
                                    decoration: InputDecoration(
                                        hintStyle: GoogleFonts.poppins(
                                          color: const Color(0xFF384953),
                                          textStyle: GoogleFonts.poppins(
                                            color: const Color(0xFF384953),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          fontSize: 14,
                                          // fontFamily: 'poppins',
                                          fontWeight: FontWeight.w300,
                                        ),
                                        hintText: 'Phone Number',
                                        // labelStyle: TextStyle(color: Colors.black),
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(),
                                        ),
                                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF384953))),
                                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF384953)))),
                                    initialCountryCode: 'IN',
                                    keyboardType: TextInputType.number,
                                    onCountryChanged: (phone){
                                      setState(() {
                                        code = "+${phone.dialCode}";
                                        log(code.toString());
                                      });
                                    },
                                    onChanged: (phone) {
                                      // log("fhdfhdf");
                                      // setState(() {
                                      //   code = phone.countryCode.toString();
                                      //   log(code.toString());
                                      // });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Text("Address",style: TextStyle(color: Colors.black),),
                                ),
                                const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: InkWell(
                                      onTap: () async {
                                        var place = await PlacesAutocomplete.show(
                                            hint: "Location",
                                            context: context,
                                            apiKey: googleApikey,
                                            mode: Mode.overlay,
                                            types: [],
                                            strictbounds: false,
                                            onError: (err) {
                                              log("error.....   ${err.errorMessage}");
                                            });
                                        if (place != null) {
                                          setState(() {
                                            _address = (place.description ?? "Location").toString();
                                          });
                                          final plist = GoogleMapsPlaces(
                                            apiKey: googleApikey,
                                            apiHeaders: await const GoogleApiHeaders().getHeaders(),
                                          );
                                          print(plist);
                                          String placeid = place.placeId ?? "0";
                                          final detail = await plist.getDetailsByPlaceId(placeid);
                                          final geometry = detail.result.geometry!;
                                          final lat = geometry.location.lat;
                                          final lang = geometry.location.lng;
                                          setState(() {
                                            _address = (place.description ?? "Location").toString();
                                            latitude = lat;
                                            longitude = lang;
                                            print("Address iss...$_address");
                                          });
                                        }
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              height: 55,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: !checkValidation(
                                                              showValidation1
                                                                  .value,
                                                              _address ==
                                                                  "")
                                                          ? Colors.black
                                                          : Colors.red),
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(5.0),
                                                  color: Colors.white),
                                              // width: MediaQuery.of(context).size.width - 40,
                                              child: ListTile(
                                                leading: const Icon(
                                                    Icons.location_on),
                                                title: Text(
                                                  _address ??
                                                      "Location"
                                                          .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                ),
                                                trailing: const Icon(
                                                    Icons.search),
                                                dense: true,
                                              )),
                                          checkValidation(
                                                  showValidation1.value,
                                                  _address == "")
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets
                                                          .only(top: 5),
                                                  child: Text(
                                                    "      Location is required",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .red.shade700,
                                                        fontSize: 12),
                                                  ),
                                                )
                                              : const SizedBox()
                                        ],
                                      )),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(20),
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 40, bottom: 10),
                                    color: showValidationImg == false
                                        ? const Color(0xFFFAAF40)
                                        : Colors.red,
                                    dashPattern: const [6],
                                    strokeWidth: 1,
                                    child: InkWell(
                                      onTap: () {
                                        _showActionSheet(context);
                                      },
                                      child: categoryFile.path != ""
                                          ? Stack(
                                              children: [
                                                Container(
                                                  decoration:
                                                      BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(10),
                                                    color: Colors.white,
                                                    image:
                                                        DecorationImage(
                                                      image: FileImage(
                                                          categoryFile),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                                  width: double.maxFinite,
                                                  height: 180,
                                                  alignment:
                                                      Alignment.center,
                                                  child: categoryFile.path
                                                      .contains(
                                                      "http") ||
                                                      categoryFile
                                                          .path.isEmpty
                                                      ? Image.network(
                                                    categoryFile.path,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (_, __,
                                                        ___) =>
                                                        CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          imageUrl:
                                                          categoryFile
                                                              .path,
                                                          height:
                                                          AddSize.size30,
                                                          width:
                                                          AddSize.size30,
                                                          errorWidget:
                                                              (_, __, ___) =>
                                                          const Icon(
                                                            Icons.person,
                                                            size: 60,
                                                          ),
                                                          placeholder: (
                                                              _,
                                                              __,
                                                              ) =>
                                                          const SizedBox(),
                                                        ),
                                                  )
                                                      : Image.memory(
                                                    categoryFile
                                                        .readAsBytesSync(),
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (_, __,
                                                        ___) =>
                                                        CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          imageUrl:
                                                          categoryFile
                                                              .path,
                                                          height:
                                                          AddSize.size30,
                                                          width:
                                                          AddSize.size30,
                                                          errorWidget:
                                                              (_, __, ___) =>
                                                          const Icon(
                                                            Icons.person,
                                                            size: 60,
                                                          ),
                                                          placeholder: (
                                                              _,
                                                              __,
                                                              ) =>
                                                          const SizedBox(),
                                                        ),
                                                  )
                                                ),
                                              ],
                                            )
                                          : Container(
                                              padding:
                                                  const EdgeInsets.only(
                                                      top: 8),
                                              margin: const EdgeInsets
                                                  .symmetric(
                                                  vertical: 8,
                                                  horizontal: 8),
                                              width: double.maxFinite,
                                              height: 130,
                                              alignment: Alignment.center,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                children: [
                                                  Image.asset(
                                                    'assets/images/gallery.png',
                                                    height: 60,
                                                    width: 50,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Text(
                                                    'Accepted file types: JPEG, Doc, PDF, PNG',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .black54),
                                                    textAlign:
                                                        TextAlign.center,
                                                  ),
                                                  const SizedBox(
                                                    height: 11,
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                // sign in button
                                const SizedBox(
                                  height: 20,
                                ),
                                MyButton(
                                  color: Colors.white,
                                  backgroundcolor:  Colors.black,
                                  onTap: () {
                                    if (formKey.currentState!
                                        .validate()) {
                                      checkEmailInFirestore();
                                    }
                                  },
                                  text: widget.isEditMode
                                      ? 'Update User'
                                      : 'Add User',
                                ),

                                const SizedBox(height: 50),
                              ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
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
