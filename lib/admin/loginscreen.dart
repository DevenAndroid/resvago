import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:resvago/admin/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/apptheme.dart';
import '../components/helper.dart';
import '../components/my_button.dart';
import '../main.dart';
import 'language_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

final GoogleSignIn googleSignIn = GoogleSignIn();

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialogLanguage(context);
    });
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
          child: Container(
        height: Get.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: kIsWeb
                    ? AssetImage(
                        "assets/images/loginscreen.png",
                      )
                    : AssetImage(
                        "assets/images/login.png",
                      ))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 150,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Welcome back to\'LogIn'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  'Enter Your Email'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: emailController,
                  obscureText: false,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      errorStyle: const TextStyle(color: Colors.red),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      fillColor: Colors.transparent,
                      filled: true,
                      hintText: 'Email'.tr,
                      labelText: 'Email'.tr,
                      labelStyle: const TextStyle(color: Colors.white),
                      hintStyle: const TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  'Password'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: passwordController,
                  obscureText: false,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      errorStyle: const TextStyle(color: Colors.red),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      fillColor: Colors.transparent,
                      filled: true,
                      hintText: 'Password'.tr,
                      labelText: 'Password'.tr,
                      labelStyle: const TextStyle(color: Colors.white),
                      hintStyle: const TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 35),
              MyButton(
                color: const Color(0xff3B5998),
                backgroundcolor: Colors.white,
                onTap: () async {
                  // await FirebaseAuth.instance
                  //     .createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text);
                  OverlayEntry loader = Helper.overlayLoader(context);
                  Overlay.of(context).insert(loader);
                  try {
                    await FirebaseAuth.instance
                        .signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim())
                        .then((value) {
                      Helper.hideLoader(loader);
                      FirebaseFirestore.instance.collection('admin_login').doc(value.user!.uid).set({
                        'email': emailController.text,
                        'Password': passwordController.text,
                        "UserId": FirebaseAuth.instance.currentUser!.uid
                      });
                      Helper.hideLoader(loader);
                      emailController.clear();
                      passwordController.clear();
                      showToast('Login successfully');
                      Get.to(const HomePage());
                    });
                  } catch (e) {
                    Helper.hideLoader(loader);
                    if (!kIsWeb) {
                      if (e.toString() ==
                          "[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.") {
                        Fluttertoast.showToast(msg: "Credential is incorrect");
                      } else {
                        Fluttertoast.showToast(msg: e.toString());
                      }
                    } else {
                      if (e.toString() ==
                          "[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.") {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Credential is incorrect"),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString()),
                        ));
                      }
                    }
                  }
                },
                text: 'Log In'.tr,
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ).appPaddingForScreen),
    );
  }

  updateLanguage(String gg) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("app_language", gg);
  }

  RxString selectedLAnguage = "English".obs;
  checkLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? appLanguage = sharedPreferences.getString("app_language");
    if (appLanguage == null || appLanguage == "English") {
      Get.updateLocale(const Locale('en', 'US'));
      selectedLAnguage.value = "English";
    } else if (appLanguage == "French") {
      Get.updateLocale(const Locale('fr', 'FR'));
      selectedLAnguage.value = "French";
    }
  }

  final keyIsFirstLoaded = 'is_first_loaded';

  Future<void> showDialogLanguage(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstLoaded = prefs.getBool(keyIsFirstLoaded);
    if (isFirstLoaded == null) {
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: const Icon(
                            Icons.clear_rounded,
                            color: Colors.black,
                          ),
                          onTap: () {
                            Get.back();
                            Get.back();
                            Get.back();
                            Get.back();
                            prefs.setBool(keyIsFirstLoaded, false);
                          },
                        )
                      ],
                    ),
                    RadioListTile(
                        value: "English",
                        groupValue: selectedLAnguage.value,
                        title: const Text(
                          "English",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff000000)),
                        ),
                        onChanged: (value) {
                          locale = const Locale('en', 'US');
                          Get.updateLocale(locale);
                          selectedLAnguage.value = value!;
                          // updateLanguage("English");
                          Get.back();
                          setState(() {});
                          if (kDebugMode) {
                            print(selectedLAnguage);
                          }
                        }),
                    RadioListTile(
                        value: "French",
                        groupValue: selectedLAnguage.value,
                        title: const Text(
                          "French",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff000000)),
                        ),
                        onChanged: (value) {
                          locale = const Locale('fr', 'FR');
                          Get.updateLocale(locale);
                          selectedLAnguage.value = value!;
                          // updateLanguage("French");
                          Get.back();
                          setState(() {});
                          if (kDebugMode) {
                            print(selectedLAnguage);
                          }
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                            Get.back();
                            Get.back();
                            Get.back();
                            updateLanguage(selectedLAnguage.value);
                            prefs.setBool(keyIsFirstLoaded, false);
                          },
                          child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppTheme.primaryColor),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Update".tr,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
    }
  }
}
