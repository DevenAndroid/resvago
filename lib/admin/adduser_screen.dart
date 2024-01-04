import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:resvago/admin/userdata_screen.dart';
import 'package:resvago/components/my_button.dart';
import 'package:resvago/firebase_service/firebase_userSerivce.dart';
import '../Firebase_service/firebase_service.dart';
import '../components/addsize.dart';
import '../components/appassets.dart';
import '../components/apptheme.dart';
import '../components/helper.dart';
import '../components/my_textfield.dart';
import 'controller/Register_controller.dart';
import 'model/category_model.dart';
import 'model/goggle_places_model.dart';
import 'model/user_model.dart';

class AddUserScreen extends StatefulWidget {
  final UserData? userData;
  final bool isEditMode;
  final String? documentId;
  final String? restaurantNamename;
  final String? email;
  final String? category;
  final String? phoneNumber;
  final String? image;
  final String? address;
  final String? code;
  final String? country;
  final String? latitude;
  final String? longitude;
  const AddUserScreen({
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
    this.code,
    this.country,
    this.latitude,
    this.longitude,
  });

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  File profileImage = File("");
  bool showValidation = false;
  bool showValidationImg = false;
  final registerController = Get.put(RegisterController());
  var obscureText4 = true;
  var obscureText3 = true;
  RxBool checkboxColor = false.obs;
  bool value = false;
  var obscureText5 = true;
  Rx<File> image = File("").obs;
  List<CategoryData>? categoryList;
  String? _address = "";
  dynamic latitude = "";
  dynamic longitude = "";
  RxBool showValidation1 = false.obs;
  String code = "+353";
  String country = "IE";
  bool checkValidation(bool bool1, bool2) {
    if (bool1 == true && bool2 == true) {
      return true;
    } else {
      return false;
    }
  }

  TextEditingController restaurantNameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String googleApikey = "AIzaSyDDl-_JOy_bj4MyQhYbKbGkZ0sfpbTZDNU";
  File categoryFile = File("");
  Uint8List? pickedFile;
  String fileUrl = "";
  int kk = 0;
  // File categoryFile = File("");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FirebaseService firebaseService = FirebaseService();
  FirebaseUserService firebaseUserService = FirebaseUserService();

  void checkEmailInFirestore() async {
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('vendor_users').where('email', isEqualTo: emailController.text).get();
    if (result.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Email already exits');
      return;
    }
    final QuerySnapshot phoneResult = await FirebaseFirestore.instance
        .collection('vendor_users')
        .where('mobileNumber', isEqualTo: code + mobileNumberController.text)
        .get();
    if (phoneResult.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Mobile Number already exits');
      return;
    }
    addUserToFirestore();
  }

  Geoflutterfire? geo;

  Future<void> addUserToFirestore() async {
    // formKey.currentState!.save();
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      geo = Geoflutterfire();
      GeoFirePoint geoFirePoint =
          geo!.point(latitude: double.tryParse(latitude.toString()) ?? 0, longitude: double.tryParse(longitude.toString()) ?? 0);
      String? imageUrlProfile = kIsWeb ? null : categoryFile.path;
      if (kIsWeb) {
        if (pickedFile != null) {
          UploadTask uploadTask = FirebaseStorage.instance
              .ref("profile_image/${FirebaseAuth.instance.currentUser!.uid}")
              .child("image")
              .putData(pickedFile!);
          TaskSnapshot snapshot = await uploadTask;
          imageUrlProfile = await snapshot.ref.getDownloadURL();
        } else {
          imageUrlProfile = fileUrl;
        }
      } else {
        if (!categoryFile.path.contains("http") && categoryFile.path.isNotEmpty) {
          UploadTask uploadTask = FirebaseStorage.instance
              .ref("profileImage/${FirebaseAuth.instance.currentUser!.uid}")
              .child("image")
              .putFile(categoryFile);
          TaskSnapshot snapshot = await uploadTask;
          imageUrlProfile = await snapshot.ref.getDownloadURL();
        }
      }
      String? uid;
      if (!widget.isEditMode) {
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: "123456",
        )
            .then((UserCredential userCredential) {
          uid = userCredential.user!.uid;
          print("User UID: $uid");
          log(uid.toString());
        }).catchError((e) {
          print("Error creating user: $e");
        });
      }
      if (widget.isEditMode) {
        CollectionReference collection = FirebaseFirestore.instance.collection('vendor_users');
        var documentReference = collection.doc(widget.documentId);
        documentReference.set({
          "restaurantName": restaurantNameController.text.trim(),
          "category": categoryController.text.trim(),
          "email": emailController.text.trim(),
          "docid": widget.documentId,
          "mobileNumber": mobileNumberController.text.trim(),
          "country": country,
          "code": code,
          "address": _searchController.text.trim(),
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
          'password': "123456",
          'image': imageUrlProfile,
          "time": DateTime.now(),
          "userID": mobileNumberController.text.trim(),
          "deactivate": false
        });
      } else {
        CollectionReference collection = FirebaseFirestore.instance.collection('vendor_users');
        var documentReference = collection.doc(uid);
        documentReference.set({
          "restaurantName": restaurantNameController.text.trim(),
          "category": categoryController.text.trim(),
          "email": emailController.text.trim(),
          "docid": uid,
          "mobileNumber": mobileNumberController.text.trim(),
          "country": country,
          "code": code,
          "address": _searchController.text.trim(),
          "latitude": selectedPlace!.geometry!.location!.lat.toString(),
          "longitude": selectedPlace!.geometry!.location!.lng.toString(),
          'password': "123456",
          'image': imageUrlProfile,
          "time": DateTime.now(),
          "userID": mobileNumberController.text.trim(),
          "deactivate": false
        });
      }
      Get.back();
    } catch (e) {
      Helper.hideLoader(loader);
      throw Exception(e);
    } finally {
      Helper.hideLoader(loader);
    }
  }

  bool isDescendingOrder = true;

  getVendorCategories() {
    FirebaseFirestore.instance.collection("resturent").where("deactivate", isEqualTo: false).get().then((value) {
      categoryList ??= [];
      categoryList!.clear();
      for (var element in value.docs) {
        var gg = element.data();
        categoryList!.add(CategoryData.fromMap(gg));
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.isEditMode == true) {
        getVendorCategories();
        restaurantNameController.text = widget.restaurantNamename ?? "";
        emailController.text = widget.email ?? "";
        categoryController.text = widget.category ?? "";
        mobileNumberController.text = widget.phoneNumber ?? "";
        code = widget.code ?? "";
        country = widget.country ?? "";
        latitude = widget.latitude ?? "";
        longitude = widget.longitude ?? "";
        _searchController.text = widget.address ?? "";
        kk++;
        if (!kIsWeb) {
          categoryFile = File(widget.image ?? "");
        } else {
          fileUrl = widget.image ?? "";
        }
      }
      getVendorCategories();
    });
  }

  final TextEditingController _searchController = TextEditingController();
  GooglePlacesModel? googlePlacesModel;
  Places? selectedPlace;

  Future<void> _searchPlaces(String query) async {
    const cloudFunctionUrl = 'https://us-central1-resvago-ire.cloudfunctions.net/searchPlaces';
    FirebaseFunctions.instance.httpsCallableFromUri(Uri.parse('$cloudFunctionUrl?query=$query')).call().then((value) {
      List<Places> places = [];
      if (value.data != null) {
        value.data.forEach((v) {
          places.add(Places.fromJson(v));
        });
      }
      googlePlacesModel = GooglePlacesModel(places: places);
      setState(() {});
    });
  }

  Timer? timer;

  makeDelay({
    required Function() delay,
  }) {
    if (timer != null) timer!.cancel();
    timer = Timer(const Duration(milliseconds: 300), delay);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: backAppBar(title: "Restaurant Registration", context: context, backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Restaurant Name",
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: restaurantNameController,
                        // length: 10,
                        validator: RequiredValidator(errorText: 'Please enter your Restaurant Name ').call,
                        // keyboardType: TextInputType.none,
                        // textInputAction: TextInputAction.next,
                        hint: 'Mac Restaurant',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Category",
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (categoryList != [])
                        RegisterTextFieldWidget(
                          readOnly: true,
                          controller: categoryController,
                          // length: 10,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Please enter your category'),
                          ]).call,
                          keyboardType: TextInputType.emailAddress,
                          hint: 'Select category',
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                surfaceTintColor: Colors.white,
                                content: SizedBox(
                                  height: 400,
                                  width: double.maxFinite,
                                  child: ListView.builder(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    itemCount: categoryList!.length,
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, int index) {
                                      return GestureDetector(
                                          onTap: () {
                                            categoryController.text = categoryList![index].name;
                                            Get.back();
                                            setState(() {});
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                                            child: Text(categoryList![index].name),
                                          ));
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      else
                        const Center(
                          child: Text("No Category Available"),
                        ),
                      const SizedBox(
                        height: 10,
                      ),

                      Text(
                        "Email",
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: emailController,
                        // length: 10,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Please enter your email'),
                          EmailValidator(errorText: 'Enter a valid email address'),
                        ]).call,
                        keyboardType: TextInputType.emailAddress,
                        // textInputAction: TextInputAction.next,
                        hint: 'Enter your email',
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      widget.isEditMode
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Mobile Number",
                                  style: GoogleFonts.poppins(
                                      color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                IntlPhoneField(
                                  key: ValueKey(kk),
                                  cursorColor: Colors.black,
                                  dropdownIcon: const Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Colors.black,
                                  ),
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: 'Please enter your phone number'),
                                  ]).call,
                                  dropdownTextStyle: const TextStyle(color: Colors.black),
                                  style: const TextStyle(color: Colors.black),
                                  flagsButtonPadding: const EdgeInsets.all(8),
                                  dropdownIconPosition: IconPosition.trailing,
                                  controller: mobileNumberController,
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
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(),
                                      ),
                                      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF384953))),
                                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF384953)))),
                                  initialCountryCode: country,
                                  keyboardType: TextInputType.number,
                                  onCountryChanged: (phone) {
                                    setState(() {
                                      code = "+${phone.dialCode}";
                                      country = phone.code;
                                      log(phone.code.toString());
                                    });
                                  },
                                ),
                              ],
                            )
                          : const SizedBox(),

                      Text(
                        "Address",
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RegisterTextFieldWidget(
                        controller: _searchController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Please enter your location'.tr),
                        ]).call,
                        keyboardType: TextInputType.emailAddress,
                        hint: 'Search your location',
                        onChanged: (value) {
                          makeDelay(delay: () {
                            _searchPlaces(value);
                            setState(() {});
                          });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      googlePlacesModel != null
                          ? Container(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: googlePlacesModel!.places!.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  final item = googlePlacesModel!.places![index];
                                  return InkWell(
                                      onTap: () {
                                        _searchController.text = item.name ?? "";
                                        selectedPlace = item;
                                        googlePlacesModel = null;
                                        log(selectedPlace!.geometry!.toJson().toString());
                                        setState(() {});
                                        // places = [];
                                        // setState(() {});
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                                        child: Text(item.name ?? ""),
                                      ));
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(
                        height: 20,
                      ),
                      // kIsWeb
                      //     ? DottedBorder(
                      //   borderType: BorderType.RRect,
                      //   radius: const Radius.circular(20),
                      //   padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                      //   color: showValidationImg == false ? const Color(0xFFFAAF40) : Colors.red,
                      //   dashPattern: const [6],
                      //   strokeWidth: 1,
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       Helper.addFilePicker().then((value) {
                      //         pickedFile = value;
                      //         setState(() {});
                      //       });
                      //     },
                      //     child: pickedFile != null
                      //         ? Stack(
                      //       children: [
                      //         Container(
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(10),
                      //             color: Colors.white,
                      //           ),
                      //           margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      //           width: double.maxFinite,
                      //           height: 180,
                      //           alignment: Alignment.center,
                      //           child: Image.memory(pickedFile!),
                      //         ),
                      //       ],
                      //     )
                      //         : Container(
                      //       padding: const EdgeInsets.only(top: 8),
                      //       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      //       width: double.maxFinite,
                      //       height: 130,
                      //       alignment: Alignment.center,
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Image.network(
                      //             fileUrl,
                      //             height: 60,
                      //             width: 50,
                      //             errorBuilder: (_, __, ___) => Image.asset(
                      //               AppAssets.gallery,
                      //               height: 60,
                      //               width: 50,
                      //             ),
                      //           ),
                      //           const SizedBox(
                      //             height: 5,
                      //           ),
                      //           Text(
                      //             'Accepted file types: JPEG, Doc, PDF, PNG'.tr,
                      //             style: TextStyle(fontSize: 16, color: Colors.black54),
                      //             textAlign: TextAlign.center,
                      //           ),
                      //           const SizedBox(
                      //             height: 11,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // )
                      //     : DottedBorder(
                      //   borderType: BorderType.RRect,
                      //   radius: const Radius.circular(4),
                      //   padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                      //   color: showValidationImg == false ? const Color(0xFFFAAF40) : Colors.red,
                      //   dashPattern: const [6],
                      //   strokeWidth: 1,
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       showActionSheet(context);
                      //     },
                      //     child: categoryFile.path != ""
                      //         ? Stack(
                      //       children: [
                      //         Container(
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(10),
                      //             color: Colors.white,
                      //             image: DecorationImage(image: FileImage(profileImage), fit: BoxFit.fill),
                      //           ),
                      //           margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      //           width: double.maxFinite,
                      //           height: 180,
                      //           alignment: Alignment.center,
                      //           child: Image.file(categoryFile,
                      //               errorBuilder: (_, __, ___) => Image.network(categoryFile.path,
                      //                   errorBuilder: (_, __, ___) => const SizedBox())),
                      //         ),
                      //       ],
                      //     )
                      //         : Container(
                      //       padding: const EdgeInsets.only(top: 8),
                      //       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      //       width: double.maxFinite,
                      //       height: 130,
                      //       alignment: Alignment.center,
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Image.asset(
                      //             AppAssets.gallery,
                      //             height: 50,
                      //             width: 40,
                      //           ),
                      //           const SizedBox(
                      //             height: 5,
                      //           ),
                      //           Text(
                      //             'Accepted file types: JPEG, Doc, PDF, PNG'.tr,
                      //             style:
                      //             TextStyle(fontSize: 14, color: Color(0xff141C21), fontWeight: FontWeight.w300),
                      //             textAlign: TextAlign.center,
                      //           ),
                      //           const SizedBox(
                      //             height: 11,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyButton(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            if (widget.isEditMode) {
                              addUserToFirestore();
                            }
                            if (!widget.isEditMode) {
                              checkEmailInFirestore();
                            }
                          } else {
                            showValidationImg = true;
                            showValidation = true;
                            setState(() {});
                          }
                        },
                        text: 'Save',
                        color: Colors.white,
                        backgroundcolor: Colors.black,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ).appPaddingForScreen,
        ),
      ),
    );
  }

  void showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          'Select Picture from',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Helper.addImagePicker(imageSource: ImageSource.camera, imageQuality: 50).then((value) async {
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
              Helper.addImagePicker(imageSource: ImageSource.gallery, imageQuality: 50).then((value) async {
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
