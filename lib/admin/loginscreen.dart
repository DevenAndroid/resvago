import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:resvago/admin/homepage.dart';
import '../components/helper.dart';
import '../components/my_button.dart';

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
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Welcome back to\'LogIn',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  'Enter Your Email',
                  style: TextStyle(
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
                  style: TextStyle(color: Colors.white),
                  controller: emailController,
                  obscureText: false,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      errorStyle: TextStyle(color: Colors.red),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      fillColor: Colors.transparent,
                      filled: true,
                      hintText: 'Email',
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  'Password',
                  style: TextStyle(
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
                  style: TextStyle(color: Colors.white),
                  controller: passwordController,
                  obscureText: false,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      errorStyle: TextStyle(color: Colors.red),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      fillColor: Colors.transparent,
                      filled: true,
                      hintText: 'Password',
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 35),
              MyButton(
                color: Color(0xff3B5998),
                backgroundcolor: Colors.white,
                onTap: () {
                  OverlayEntry loader = Helper.overlayLoader(context);
                  Overlay.of(context).insert(loader);
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim())
                      .then((value) {
                    Helper.hideLoader(loader);
                    showToast('Login successfully');
                    Get.to(const HomePage());
                  });
                },
                text: 'Log In',
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ).appPaddingForScreen),
    );
  }
}
