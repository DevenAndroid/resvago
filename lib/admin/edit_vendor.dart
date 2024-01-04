import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:resvago/components/my_button.dart';
import '../Firebase_service/firebase_service.dart';
import '../components/addsize.dart';
import '../components/apptheme.dart';
import '../components/helper.dart';
import '../components/loader.dart';
import '../components/my_textfield.dart';
import 'controller/Register_controller.dart';
import 'controller/vendor_controller.dart';
import 'model/category_model.dart';
import 'model/goggle_places_model.dart';
import 'model/user_model.dart';

class UserProfileScreen extends StatefulWidget {
  String uid;
   UserProfileScreen({super.key,required this.uid});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  File profileImage = File("");
  bool showValidation = false;
  bool showValidationImg = false;
  final _formKeySignup = GlobalKey<FormState>();
  final registerController = Get.put(RegisterController());
  var obscureText4 = true;
  var obscureText3 = true;
  RxBool checkboxColor = false.obs;
  bool value = false;
  var obscureText5 = true;
  Rx<File> image = File("").obs;
  RxBool showValidation1 = false.obs;
  String? _address = "";

  bool checkValidation(bool bool1, bool2) {
    if (bool1 == true && bool2 == true) {
      return true;
    } else {
      return false;
    }
  }

  final picker = ImagePicker();
  final controller = Get.put(AddProductController());

  int kk = 0;

  TextEditingController mobileController = TextEditingController();
  TextEditingController restaurantController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController aboutUsController = TextEditingController();
  // TextEditingController locationUsController = TextEditingController();
  dynamic preparationTime;
  dynamic averageMealForMember;
  dynamic setDelivery;
  dynamic cancellation;
  dynamic menuSelection;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FirebaseService firebaseService = FirebaseService();
  String googleApikey = "AIzaSyDDl-_JOy_bj4MyQhYbKbGkZ0sfpbTZDNU";
  Uint8List? pickedFile;
  List<Uint8List?> galleryFiles = [];
  String fileUrl = "";

  List<CategoryData>? categoryList;
  String? categoryValue;
  dynamic latitude = "";
  dynamic longitude = "";
  bool deactivated = false;

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

  Future<void> updateProfileToFirestore() async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      List<String> imagesLink = [];
      List<String> menuPhotoLink = [];
      String? imageUrlProfile = kIsWeb ? null : controller.categoryFile.path;
      if (kIsWeb) {
        if (pickedFile != null) {
          UploadTask uploadTask = FirebaseStorage.instance
              .ref("profile_image/${widget.uid}")
              .child("image")
              .putData(pickedFile!);
          TaskSnapshot snapshot = await uploadTask;
          imageUrlProfile = await snapshot.ref.getDownloadURL();
        } else {
          imageUrlProfile = fileUrl;
        }
      } else {
        // if (profileData.image.toString().isNotEmpty) {
        //   Reference gg = FirebaseStorage.instance.refFromURL(profileData.image.toString());
        //   await gg.delete();
        // }
        if (!controller.categoryFile.path.contains("http") && controller.categoryFile.path.isNotEmpty) {
          UploadTask uploadTask = FirebaseStorage.instance
              .ref("profileImage/${widget.uid}")
              .child("image")
              .putFile(controller.categoryFile);
          TaskSnapshot snapshot = await uploadTask;
          imageUrlProfile = await snapshot.ref.getDownloadURL();
        }
      }
      if (!kIsWeb) {
        for (var element in controller.galleryImages.asMap().entries) {
          if (element.value.path.contains("http")) {
            imagesLink.add(element.value.path);
          } else {
            UploadTask uploadTask = FirebaseStorage.instance
                .ref("restaurant_images/${widget.uid}")
                .child("${element.key}image")
                .putFile(element.value);
            TaskSnapshot snapshot = await uploadTask;
            String imageUrl = await snapshot.ref.getDownloadURL();
            imagesLink.add(imageUrl);
          }
        }
        for (var element in controller.menuGallery.asMap().entries) {
          if (element.value.path.contains("http")) {
            menuPhotoLink.add(element.value.path);
          } else {
            UploadTask uploadMenuImage = FirebaseStorage.instance
                .ref("menu_images/${widget.uid}")
                .child("${element.key}image")
                .putFile(element.value);

            TaskSnapshot snapshot1 = await uploadMenuImage;
            String imageUrl1 = await snapshot1.ref.getDownloadURL();
            menuPhotoLink.add(imageUrl1);
          }
        }
      }
      else {
        if (controller.galleryFiles.isNotEmpty) {
          for (var element in controller.galleryFiles.asMap().entries) {
            UploadTask uploadTask = FirebaseStorage.instance
                .ref("menu_images/${widget.uid}")
                .child("${element.key}image")
                .putData(element.value!);

            TaskSnapshot snapshot = await uploadTask;
            String imageUrl = await snapshot.ref.getDownloadURL();
            menuPhotoLink.add(imageUrl);
          }
        } else {
          for (var element in controller.galleryFilesUrl.asMap().entries) {
            menuPhotoLink.add(element.value.toString());
          }
        }

        if (controller.galleryFiles1.isNotEmpty) {
          for (var element in controller.galleryFiles1.asMap().entries) {
            UploadTask uploadTask = FirebaseStorage.instance
                .ref("restaurant_images/${widget.uid}")
                .child("${element.key}image")
                .putData(element.value!);

            TaskSnapshot snapshot = await uploadTask;
            String imageUrl = await snapshot.ref.getDownloadURL();
            imagesLink.add(imageUrl);
          }
        } else {
          for (var element in controller.galleryFilesUrl1.asMap().entries) {
            imagesLink.add(element.value.toString());
          }
        }
      }

      print("zbxcgxc${controller.galleryFiles1}");
      print("zbxcgxc${controller.galleryFiles}");
      await FirebaseFirestore.instance.collection("vendor_users").doc(widget.uid).update({
        "restaurantName": restaurantController.text.trim(),
        "address": _searchController.text.trim(),
        "password": passwordController.text.trim(),
        "email": emailController.text.trim(),
        "category": categoryController.text.trim(),
        "restaurantImage": imagesLink,
        "menuImage": menuPhotoLink,
        "image": imageUrlProfile,
        "aboutUs": aboutUsController.text.trim(),
        "mobileNumber": mobileController.text.trim(),
        "code": code,
        "country": country,
        "confirmPassword": confirmPassController.text.trim(),
        "preparationTime": preparationTime,
        "averageMealForMember": averageMealForMember,
        "setDelivery": setDelivery,
        "cancellation": cancellation,
        "menuSelection": menuSelection,
        "latitude": latitude,
        "longitude": longitude,
        "deactivate": deactivated
      }).then((value) => Fluttertoast.showToast(msg: "Profile Updated"));
      fetchdata();
      Get.back();
      Helpers.hideLoader(loader);
    } catch (e) {
      Helpers.hideLoader(loader);
      throw Exception(e);
    } finally {
      Helpers.hideLoader(loader);
    }
  }

  ProfileData profileData = ProfileData();
  void fetchdata() {
    FirebaseFirestore.instance.collection("vendor_users").doc(widget.uid).get().then((value) {
      if (value.exists) {
        if (value.data() == null) return;
        profileData = ProfileData.fromJson(value.data()!);
        print(profileData.toJson().toString());
        if (!kIsWeb) {
          controller.categoryFile = File(profileData.image ?? "");
        } else {
          fileUrl = profileData.image ?? "";
        }
        mobileController.text = (profileData.mobileNumber ?? "").toString();
        code = (profileData.code ?? "").toString();
        country = (profileData.country ?? "").toString();
        restaurantController.text = profileData.restaurantName.toString();
        categoryController.text = (profileData.category ?? "").toString();
        emailController.text = profileData.email.toString();
        latitude = profileData.latitude.toString();
        longitude = profileData.longitude.toString();
        _searchController.text = (profileData.address ?? "").toString();
        preparationTime = (profileData.preparationTime ?? "").toString();
        averageMealForMember = (profileData.averageMealForMember ?? "").toString();
        setDelivery = (profileData.setDelivery);
        cancellation = (profileData.cancellation);
        menuSelection = (profileData.menuSelection);
        aboutUsController.text = (profileData.aboutUs ?? "").toString();
        profileData.restaurantImage ??= [];
        deactivated = profileData.deactivate;
        controller.galleryImages.clear();
        if (!kIsWeb) {
          for (var element in profileData.restaurantImage!) {
            controller.galleryImages.add(File(element));
            controller.refreshInt.value = DateTime.now().millisecondsSinceEpoch;
          }
        } else {
          for (var element in profileData.restaurantImage!) {
            controller.galleryFilesUrl1.add(element);
            controller.refreshInt.value = DateTime.now().millisecondsSinceEpoch;
            print("erfse${controller.galleryFiles1.length}");
          }
        }
        profileData.menuGalleryImages ??= [];
        controller.menuGallery.clear();
        if (!kIsWeb) {
          for (var element in profileData.menuGalleryImages!) {
            controller.menuGallery.add(File(element));
            controller.refreshInt.value = DateTime.now().millisecondsSinceEpoch;
          }
        } else {
          for (var element in profileData.menuGalleryImages!) {
            controller.galleryFilesUrl.add(element);
            controller.refreshInt.value = DateTime.now().millisecondsSinceEpoch;
            print("fuyguh${controller.galleryFiles.length}");
          }
        }
        kk++;
        setState(() {});
        if (!categoryList!.map((e) => e.name.toString()).toList().contains(profileData.category)) {
          categoryValue = "";
        }
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      fetchdata();
    });
    getVendorCategories();
  }

  String code = "+353";
  String country = "IE";
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Form(
          key: _formKeySignup,
          child: Column(
            children: [
              Container(
                // padding: const EdgeInsets.all(15),
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                            width: kIsWeb ? 500 : size.width,
                            padding: const EdgeInsets.only(bottom: 30),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                            child: Image.asset('assets/images/Group.png')),
                        Positioned(
                          top: 90,
                          left: 0,
                          right: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: kIsWeb
                                    ? Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10000),
                                      child: Container(
                                          height: 100,
                                          width: 100,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffFAAF40),
                                            border: Border.all(color: const Color(0xff3B5998), width: 6),
                                            borderRadius: BorderRadius.circular(5000),
                                            // color: Colors.brown
                                          ),
                                          child: pickedFile != null
                                              ? Image.memory(
                                            pickedFile!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: controller.categoryFile.path,
                                              height: AddSize.size30,
                                              width: AddSize.size30,
                                              errorWidget: (_, __, ___) => const Icon(
                                                Icons.person,
                                                size: 60,
                                              ),
                                              placeholder: (_, __) => const SizedBox(),
                                            ),
                                          )
                                              : Image.network(
                                            fileUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: controller.categoryFile.path,
                                              height: AddSize.size30,
                                              width: AddSize.size30,
                                              errorWidget: (_, __, ___) => const Icon(
                                                Icons.person,
                                                size: 60,
                                              ),
                                              placeholder: (_, __) => const SizedBox(),
                                            ),
                                          )),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: IconButton(
                                        onPressed: () {
                                          Helper.addFilePicker().then((value) {
                                            pickedFile = value;
                                            setState(() {});
                                          });
                                        },
                                        icon: Container(
                                          height: 30,
                                          width: 30,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff04666E),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                                    : Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10000),
                                      child: Container(
                                          height: 100,
                                          width: 100,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffFAAF40),
                                            border: Border.all(color: const Color(0xff3B5998), width: 6),
                                            borderRadius: BorderRadius.circular(5000),
                                            // color: Colors.brown
                                          ),
                                          child: controller.categoryFile.path.contains("http") ||
                                              controller.categoryFile.path == ""
                                              ? Image.network(
                                            profileData.image.toString(),
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: profileData.image.toString(),
                                              height: AddSize.size30,
                                              width: AddSize.size30,
                                              errorWidget: (_, __, ___) => const Icon(
                                                Icons.person,
                                                size: 20,
                                                color: Colors.black,
                                              ),
                                              placeholder: (_, __) => const SizedBox(),
                                            ),
                                          )
                                              : Image.file(
                                            controller.categoryFile,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: controller.categoryFile.path,
                                              height: AddSize.size30,
                                              width: AddSize.size30,
                                              errorWidget: (_, __, ___) => const Icon(
                                                Icons.person,
                                                size: 60,
                                              ),
                                              placeholder: (_, __) => const SizedBox(),
                                            ),
                                          )
                                        // controller.categoryFile.path.contains("http") || controller.categoryFile.path == ""
                                        //     ? Image.network(
                                        //   controller.categoryFile.path,
                                        //         fit: BoxFit.cover,
                                        //         errorBuilder: (_, __, ___) => CachedNetworkImage(
                                        //           fit: BoxFit.cover,
                                        //           imageUrl: controller.categoryFile.path,
                                        //           height: AddSize.size30,
                                        //           width: AddSize.size30,
                                        //           errorWidget: (_, __, ___) => const Icon(
                                        //             Icons.person,
                                        //             size: 60,
                                        //           ),
                                        //           placeholder: (_, __) => const SizedBox(),
                                        //         ),
                                        //       )
                                        //     : Image.file(
                                        //   controller.categoryFile,
                                        //         fit: BoxFit.cover,
                                        //         errorBuilder: (_, __, ___) => CachedNetworkImage(
                                        //           fit: BoxFit.cover,
                                        //           imageUrl: controller.categoryFile.path,
                                        //           height: AddSize.size30,
                                        //           width: AddSize.size30,
                                        //           errorWidget: (_, __, ___) => const Icon(
                                        //             Icons.person,
                                        //             size: 60,
                                        //           ),
                                        //           placeholder: (_, __) => const SizedBox(),
                                        //         ),
                                        //       )
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          showActionSheet(context);
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff04666E),
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        restaurantController.text.toString(),
                        style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        emailController.text.toString(),
                        style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 12),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Restaurant Name'.tr,
                            style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RegisterTextFieldWidget(
                            controller: restaurantController,
                            validator: RequiredValidator(errorText: 'Please enter your Restaurant Name'.tr).call,
                            hint:
                            profileData.restaurantName == null ? "restaurant name".tr : profileData.restaurantName.toString(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Category".tr,
                            style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (categoryList != null)
                            RegisterTextFieldWidget(
                              readOnly: true,
                              controller: categoryController,
                              // length: 10,
                              // validator: MultiValidator([
                              //   RequiredValidator(errorText: 'Please enter your category'.tr),
                              // ]).call,
                              keyboardType: TextInputType.emailAddress,
                              hint: 'Select category'.tr,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    content: SizedBox(
                                      height: 400,
                                      width: double.maxFinite,
                                      child: ListView.builder(
                                        physics: const AlwaysScrollableScrollPhysics(),
                                        itemCount: categoryList!.length,
                                        shrinkWrap: true,
                                        itemBuilder: (BuildContext context, int index) {
                                          return InkWell(
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
                            Center(
                              child: Text("No Category Available".tr),
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Email".tr,
                            style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RegisterTextFieldWidget(
                            readOnly: true,
                            controller: emailController,
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'Please enter your email'.tr),
                              EmailValidator(errorText: 'Enter a valid email address'.tr),
                            ]).call,
                            keyboardType: TextInputType.emailAddress,
                            // textInputAction: TextInputAction.next,
                            hint: profileData.email == null ? "email" : profileData.email.toString(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Mobile Number".tr,
                            style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
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
                              RequiredValidator(errorText: 'Please enter your phone number'.tr),
                            ]).call,
                            dropdownTextStyle: const TextStyle(color: Colors.black),
                            style: const TextStyle(color: Colors.black),
                            flagsButtonPadding: const EdgeInsets.all(8),
                            dropdownIconPosition: IconPosition.trailing,
                            controller: mobileController,
                            decoration: InputDecoration(
                                hintStyle: const TextStyle(
                                  color: Color(0xFF384953),
                                  fontSize: 14,
                                  // fontFamily: 'poppins',
                                  fontWeight: FontWeight.w300,
                                ),
                                hintText: 'Phone Number'.tr,
                                // labelStyle: TextStyle(color: Colors.black),
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
                                log(phone.dialCode.toString());
                              });
                            },
                          ),
                          // RegisterTextFieldWidget(
                          //   // readOnly: true,
                          //   controller: mobileController,
                          //   length: 10,
                          //   // validator: RequiredValidator(errorText: 'Please enter your Mobile Number'.tr).call,
                          //   keyboardType: TextInputType.number,
                          //   // textInputAction: TextInputAction.next,
                          //   hint: profileData.mobileNumber == null ? "mobile number" : profileData.mobileNumber.toString(),
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Address".tr,
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
                                      latitude = selectedPlace!.geometry!.location!.lat;
                                      longitude = selectedPlace!.geometry!.location!.lng;
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
                          // RegisterTextFieldWidget(
                          //   readOnly: true,
                          //   controller: locationUsController,
                          //   length: 10,
                          //   validator: RequiredValidator(errorText: 'Please enter your address'.tr).call,
                          //   keyboardType: TextInputType.number,
                          //   // textInputAction: TextInputAction.next,
                          //   hint: profileData.address == null ? "Address" : profileData.address.toString(),
                          // ),
                          // InkWell(
                          //     onTap: () async {
                          //       var place = await PlacesAutocomplete.show(
                          //           hint: "Location".tr,
                          //           context: context,
                          //           apiKey: googleApikey,
                          //           mode: Mode.overlay,
                          //           types: [],
                          //           strictbounds: false,
                          //           onError: (err) {
                          //             log("error.....   ${err.errorMessage}");
                          //           });
                          //       if (place != null) {
                          //         setState(() {
                          //           _address = (place.description ?? "Location").toString();
                          //         });
                          //         final plist = GoogleMapsPlaces(
                          //           apiKey: googleApikey,
                          //           apiHeaders: await const GoogleApiHeaders().getHeaders(),
                          //         );
                          //         print(plist);
                          //         String placeid = place.placeId ?? "0";
                          //         final detail = await plist.getDetailsByPlaceId(placeid);
                          //         final geometry = detail.result.geometry!;
                          //         final lat = geometry.location.lat;
                          //         final lang = geometry.location.lng;
                          //         setState(() {
                          //           _address = (place.description ?? "Location").toString();
                          //           latitude = lat;
                          //           longitude = lang;
                          //         });
                          //       }
                          //     },
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Container(
                          //             height: 55,
                          //             decoration: BoxDecoration(
                          //                 border: Border.all(
                          //                     color: !checkValidation(showValidation1.value, _address == "")
                          //                         ? Colors.grey.shade300
                          //                         : Colors.red),
                          //                 borderRadius: BorderRadius.circular(5.0),
                          //                 color: Colors.white),
                          //             // width: MediaQuery.of(context).size.width - 40,
                          //             child: ListTile(
                          //               leading: const Icon(Icons.location_on),
                          //               title: Text(
                          //                 _address ?? "Location".toString(),
                          //                 style: TextStyle(fontSize: AddSize.font14),
                          //               ),
                          //               trailing: const Icon(Icons.search),
                          //               dense: true,
                          //             )),
                          //         checkValidation(showValidation1.value, _address == "")
                          //             ? Padding(
                          //                 padding: EdgeInsets.only(top: AddSize.size5),
                          //                 child: Text(
                          //                   "Location is required".tr,
                          //                   style: TextStyle(color: Colors.red.shade700, fontSize: AddSize.font12),
                          //                 ),
                          //               )
                          //             : const SizedBox()
                          //       ],
                          //     )),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "About Us".tr,
                            style: GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RegisterTextFieldWidget(
                            controller: aboutUsController,
                            minLines: 5,
                            maxLines: 5,
                            // validator: MultiValidator([
                            //   RequiredValidator(errorText: 'Please enter about yourself'.tr),
                            // ]).call,
                            keyboardType: TextInputType.text,
                            hint: 'About Us',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // if (!kIsWeb)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Upload Restaurant Images or Videos".tr,
                                style:
                                GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const ProductGalleryImages(),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Upload Restaurant Menu Card".tr,
                                style:
                                GoogleFonts.poppins(color: AppTheme.registortext, fontWeight: FontWeight.w500, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const ProductMenuImages(),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          MyButton(
                            onTap: () {
                              if (_formKeySignup.currentState!.validate() && _searchController.text != "") {
                                updateProfileToFirestore();
                              } else {
                                showValidation1.value = true;
                                setState(() {});
                              }
                            },
                            text: 'Update'.tr, color: Colors.white, backgroundcolor: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
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
        title: Text(
          'Select Picture from'.tr,
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Helper.addImagePicker(imageSource: ImageSource.camera, imageQuality: 50).then((value) async {
                // CroppedFile? croppedFile = await ImageCropper().cropImage(
                //   sourcePath: value.path,
                //   aspectRatioPresets: [
                //     CropAspectRatioPreset.square,
                //     CropAspectRatioPreset.ratio3x2,
                //     CropAspectRatioPreset.original,
                //     CropAspectRatioPreset.ratio4x3,
                //     CropAspectRatioPreset.ratio16x9
                //   ],
                //   uiSettings: [
                //     AndroidUiSettings(
                //         toolbarTitle: 'Cropper',
                //         toolbarColor: Colors.deepOrange,
                //         toolbarWidgetColor: Colors.white,
                //         initAspectRatio: CropAspectRatioPreset.original,
                //         lockAspectRatio: false),
                //     IOSUiSettings(
                //       title: 'Cropper',
                //     ),
                //     WebUiSettings(
                //       context: context,
                //     ),
                //   ],
                // );
                if (value != null) {
                  controller.categoryFile = File(value.path);
                  setState(() {});
                }

                Get.back();
              });
            },
            child: Text("Camera".tr),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Helper.addImagePicker(imageSource: ImageSource.gallery, imageQuality: 50).then((value) async {
                // CroppedFile? croppedFile = await ImageCropper().cropImage(
                //   sourcePath: value.path,
                //   aspectRatioPresets: [
                //     CropAspectRatioPreset.square,
                //     CropAspectRatioPreset.ratio3x2,
                //     CropAspectRatioPreset.original,
                //     CropAspectRatioPreset.ratio4x3,
                //     CropAspectRatioPreset.ratio16x9
                //   ],
                //   uiSettings: [
                //     AndroidUiSettings(
                //         toolbarTitle: 'Cropper',
                //         toolbarColor: Colors.deepOrange,
                //         toolbarWidgetColor: Colors.white,
                //         initAspectRatio: CropAspectRatioPreset.original,
                //         lockAspectRatio: false),
                //     IOSUiSettings(
                //       title: 'Cropper',
                //     ),
                //     WebUiSettings(
                //       context: context,
                //     ),
                //   ],
                // );
                if (value != null) {
                  controller.categoryFile = File(value.path);
                  setState(() {});
                }

                Get.back();
              });
            },
            child: Text('Gallery'.tr),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Get.back();
            },
            child: Text('Cancel'.tr),
          ),
        ],
      ),
    );
  }
}

class ProductGalleryImages extends StatefulWidget {
  const ProductGalleryImages({super.key});

  @override
  State<ProductGalleryImages> createState() => _ProductGalleryImagesState();
}

class _ProductGalleryImagesState extends State<ProductGalleryImages> {
  final controller = Get.put(AddProductController());

  showImagesBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.maxFinite,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                NewHelper()
                                    .videoPicker(
                                  imageSource: ImageSource.gallery,
                                )
                                    .then((value) {
                                  if (value == null) return;
                                  Get.back();
                                  if (controller.galleryImages.length < 5) {
                                    controller.galleryImages.add(value);
                                    setState(() {});
                                  }
                                });
                              },
                              height: 58,
                              elevation: 0,
                              color: Colors.white,
                              child: Text(
                                "Video".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(color: Colors.orange, fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                Get.back();
                                NewHelper()
                                    .addImagePicker(
                                  imageSource: ImageSource.camera,
                                )
                                    .then((value) {
                                  if (value == null) return;
                                  if (controller.galleryImages.length < 5) {
                                    controller.galleryImages.add(value);
                                    setState(() {});
                                  }
                                });
                              },
                              height: 58,
                              elevation: 0,
                              color: Colors.white,
                              child: Text(
                                "Take picture".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(color: Colors.orange, fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                Get.back();
                                NewHelper().multiImagePicker().then((value) {
                                  if (value == null) return;
                                  for (var element in value) {
                                    if (controller.galleryImages.length < 5) {
                                      controller.galleryImages.add(element);
                                    } else {
                                      break;
                                    }
                                  }
                                  setState(() {});
                                });
                              },
                              height: 58,
                              elevation: 0,
                              color: Colors.white,
                              child: Text(
                                "Choose From Gallery".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(color: Colors.orange, fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            // Get.toNamed(thankUScreen);
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.maxFinite, 60),
                              backgroundColor: Colors.orange,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              textStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
                          child: Text(
                            "Submit".tr,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.refreshInt.value > 0) {}
      return Card(
        elevation: 3,
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 0, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Image Gallery'.tr,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF000000),
                                ),
                              ),
                            ),
                            if (controller.showValidations && controller.galleryImages.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 5, top: 2),
                                child: Icon(
                                  Icons.error_outline_rounded,
                                  color: Theme.of(context).colorScheme.error,
                                  size: 21,
                                ),
                              ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (kIsWeb) {
                            Helper.addFilePicker().then((value) {
                              if (value == null) return;
                              if (controller.galleryFiles1.length < 5) {
                                controller.galleryFiles1.add(value);
                                setState(() {});
                              }
                            });
                          } else {
                            showImagesBottomSheet();
                          }
                        },
                        child: kIsWeb
                            ? Text(
                            'Choose From Gallery ${controller.galleryFiles1.isNotEmpty ? "${controller.galleryFiles1.length}/5" : ""}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ))
                            : Text(
                          'Choose From Gallery ${controller.galleryImages.isNotEmpty ? "${controller.galleryImages.length}/5" : ""}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                kIsWeb
                    ? controller.galleryFiles1.isNotEmpty
                    ? SizedBox(
                  height: 125,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: controller.galleryFiles1
                          .asMap()
                          .entries
                          .map((e) => Padding(
                        padding: const EdgeInsets.only(right: 18),
                        child: GestureDetector(
                            onTap: () {
                              Helper.addFilePicker().then((value) {
                                controller.galleryFiles1[e.key] = value;
                                setState(() {});
                              });
                            },
                            child: Container(
                              constraints: const BoxConstraints(minWidth: 50, minHeight: 125),
                              child: Image.memory(
                                e.value!,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.video_collection_rounded,
                                  color: Colors.blue,
                                ),
                              ),
                            )),
                      ))
                          .toList(),
                    ),
                  ),
                )
                    : SizedBox(
                  height: 125,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: controller.galleryFilesUrl1
                          .asMap()
                          .entries
                          .map((e) => Padding(
                        padding: const EdgeInsets.only(right: 18),
                        child: GestureDetector(
                            onTap: () {
                              Helper.addFilePicker().then((value) {
                                controller.galleryFilesUrl1[e.key] = value;
                                setState(() {});
                              });
                            },
                            child: Container(
                              constraints: const BoxConstraints(minWidth: 50, minHeight: 125),
                              child: Image.network(
                                e.value,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.video_collection_rounded,
                                  color: Colors.blue,
                                ),
                              ),
                            )),
                      ))
                          .toList(),
                    ),
                  ),
                )
                    :controller.galleryImages.isNotEmpty ? SizedBox(
                  height: 125,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: controller.galleryImages
                          .asMap()
                          .entries
                          .map((e) => Padding(
                        padding: const EdgeInsets.only(right: 18),
                        child: GestureDetector(
                            onTap: () {
                              NewHelper.showImagePickerSheet(
                                  gotImage: (value) {
                                    controller.galleryImages[e.key] = value;
                                    setState(() {});
                                  },
                                  context: context,
                                  removeOption: true,
                                  removeImage: (fg) {
                                    controller.galleryImages.removeAt(e.key);
                                    setState(() {});
                                  });
                            },
                            child: Container(
                              constraints: const BoxConstraints(minWidth: 50, minHeight: 125),
                              child: Image.file(
                                e.value,
                                errorBuilder: (_, __, ___) => Image.network(
                                  e.value.path,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.video_collection_rounded,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            )),
                      ))
                          .toList(),
                    ),
                  ),
                ):const SizedBox(),
                const SizedBox(
                  height: 12,
                ),
              ],
            )),
      );
    });
  }
}

class ProductMenuImages extends StatefulWidget {
  const ProductMenuImages({super.key});

  @override
  State<ProductMenuImages> createState() => _ProductMenuImagesState();
}

class _ProductMenuImagesState extends State<ProductMenuImages> {
  final controller = Get.put(AddProductController());

  showImagesBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.maxFinite,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                Get.back();
                                NewHelper()
                                    .addImagePicker(
                                  imageSource: ImageSource.camera,
                                )
                                    .then((value) {
                                  if (value == null) return;
                                  if (controller.menuGallery.length < 5) {
                                    controller.menuGallery.add(value);
                                    setState(() {});
                                  }
                                });
                              },
                              height: 58,
                              elevation: 0,
                              color: Colors.white,
                              child: Text(
                                "Take picture".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(color: Colors.orange, fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                Get.back();
                                NewHelper().multiImagePicker().then((value) {
                                  if (value == null) return;
                                  for (var element in value) {
                                    if (controller.menuGallery.length < 5) {
                                      controller.menuGallery.add(element);
                                    } else {
                                      break;
                                    }
                                  }
                                  setState(() {});
                                });
                              },
                              height: 58,
                              elevation: 0,
                              color: Colors.white,
                              child: Text(
                                "Choose From Gallery".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(color: Colors.orange, fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            // Get.toNamed(thankUScreen);
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.maxFinite, 60),
                              backgroundColor: Colors.orange,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              textStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
                          child: Text(
                            "Submit".tr,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.refreshInt.value > 0) {}
      return Card(
        elevation: 3,
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 0, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Image Gallery'.tr,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF000000),
                                ),
                              ),
                            ),
                            if (controller.showValidations && controller.menuGallery.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 5, top: 2),
                                child: Icon(
                                  Icons.error_outline_rounded,
                                  color: Theme.of(context).colorScheme.error,
                                  size: 21,
                                ),
                              ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (kIsWeb) {
                            Helper.addFilePicker().then((value) {
                              if (value == null) return;
                              if (controller.galleryFiles.length < 5) {
                                controller.galleryFiles.add(value);
                                setState(() {});
                              }
                            });
                          } else {
                            showImagesBottomSheet();
                          }
                        },
                        child: kIsWeb
                            ? Text(
                            'Choose From Gallery ${controller.galleryFiles.isNotEmpty ? "${controller.galleryFiles.length}/5" : ""}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ))
                            : Text(
                          'Choose From Gallery ${controller.menuGallery.isNotEmpty ? "${controller.menuGallery.length}/5" : ""}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                kIsWeb
                    ? controller.galleryFiles.isNotEmpty
                    ? SizedBox(
                  height: 125,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: controller.galleryFiles
                          .asMap()
                          .entries
                          .map((e) => Padding(
                        padding: const EdgeInsets.only(right: 18),
                        child: GestureDetector(
                            onTap: () {
                              Helper.addFilePicker().then((value) {
                                controller.galleryFiles[e.key] = value;
                                setState(() {});
                              });
                            },
                            child: Container(
                              constraints: const BoxConstraints(minWidth: 50, minHeight: 125),
                              child: Image.memory(
                                e.value!,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                              ),
                            )),
                      ))
                          .toList(),
                    ),
                  ),
                )
                    : SizedBox(
                  height: 125,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: controller.galleryFilesUrl
                          .asMap()
                          .entries
                          .map((e) => Padding(
                        padding: const EdgeInsets.only(right: 18),
                        child: GestureDetector(
                            onTap: () {
                              Helper.addFilePicker().then((value) {
                                controller.galleryFilesUrl[e.key] = value;
                                setState(() {});
                              });
                            },
                            child: Container(
                              constraints: const BoxConstraints(minWidth: 50, minHeight: 125),
                              child: Image.network(
                                e.value,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                              ),
                            )),
                      ))
                          .toList(),
                    ),
                  ),
                )
                    : controller.menuGallery.isNotEmpty
                    ? SizedBox(
                  height: 125,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: controller.menuGallery
                          .asMap()
                          .entries
                          .map((e) => Padding(
                        padding: const EdgeInsets.only(right: 18),
                        child: GestureDetector(
                            onTap: () {
                              NewHelper.showImagePickerSheet(
                                  gotImage: (value) {
                                    controller.menuGallery[e.key] = value;
                                    setState(() {});
                                  },
                                  context: context,
                                  removeOption: true,
                                  removeImage: (fg) {
                                    controller.menuGallery.removeAt(e.key);
                                    setState(() {});
                                  });
                            },
                            child: Container(
                              constraints: const BoxConstraints(minWidth: 50, minHeight: 125),
                              child: Image.file(
                                e.value,
                                errorBuilder: (_, __, ___) => Image.network(
                                  e.value.path,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            )),
                      ))
                          .toList(),
                    ),
                  ),
                )
                    : const SizedBox(),
                const SizedBox(
                  height: 12,
                ),
              ],
            )),
      );
    });
  }
}
