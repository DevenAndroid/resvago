import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:resvago/admin/homepage.dart';
import '../components/helper.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';

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
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          decoration: const BoxDecoration(
              image: DecorationImage(fit: BoxFit.fill,
                  image: AssetImage(
            "assets/images/login.png",
          ))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 150,),
                const Align(
                  alignment: Alignment.center,
                  child:  Text(
                    'Welcome back to\'LogIn',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Padding(
                  padding:  EdgeInsets.only(left: 25),
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
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  color: Colors.transparent
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding:  EdgeInsets.only(left: 25),
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
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                    maxLines: 1,
                    color: Colors.transparent

                ),
                const SizedBox(height: 35),
                MyButton(
                  color: Color(0xff3B5998),
                  backgroundcolor: Colors.white,
                  onTap: () {
                    OverlayEntry loader = Helper.overlayLoader(context);
                    Overlay.of(context).insert(loader);
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: emailController.text.trim(), password: passwordController.text.trim())
                        .then((userCredential) {
                      Get.to(const LineChartSample1());
                      Helper.hideLoader(loader);
                    }).catchError((error) {
                      Helper.hideLoader(loader);
                      Fluttertoast.showToast(msg: 'Failed to login up: $error');
                    });
                  },
                  text: 'Log In',
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
